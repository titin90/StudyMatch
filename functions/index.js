const {onDocumentUpdated, onDocumentCreated} = require('firebase-functions/v2/firestore');
const {onSchedule} = require('firebase-functions/v2/scheduler');
const admin = require('firebase-admin');

admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

/**
 * Envía una notificación a un usuario específico
 */
async function sendNotificationToUser(userId, title, body, data = {}) {
  try {
    const userDoc = await db.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      console.log(`Usuario ${userId} no existe`);
      return;
    }

    const fcmToken = userDoc.data().fcmToken;
    if (!fcmToken) {
      console.log(`Usuario ${userId} no tiene token FCM`);
      return;
    }

    const message = {
      notification: {
        title: title,
        body: body,
      },
      data: data,
      token: fcmToken,
    };

    const response = await messaging.send(message);
    console.log(`Notificación enviada exitosamente: ${response}`);
  } catch (error) {
    console.error('Error al enviar notificación:', error);
  }
}

/**
 * Envía notificación a todos los miembros de una sala excepto al que realizó la acción
 */
async function notifyRoomMembers(roomId, excludeUserId, title, body, data = {}) {
  try {
    const roomDoc = await db.collection('study_rooms').doc(roomId).get();
    if (!roomDoc.exists) {
      console.log(`Sala ${roomId} no existe`);
      return;
    }

    const members = roomDoc.data().members || [];
    const membersToNotify = members.filter(id => id !== excludeUserId);

    // Obtener tokens de todos los miembros
    const userDocs = await Promise.all(
      membersToNotify.map(id => db.collection('users').doc(id).get())
    );

    const tokens = userDocs
      .filter(doc => doc.exists && doc.data().fcmToken)
      .map(doc => doc.data().fcmToken);

    if (tokens.length === 0) {
      console.log('No hay tokens para enviar notificaciones');
      return;
    }

    // Enviar notificación multicast
    const message = {
      notification: {
        title: title,
        body: body,
      },
      data: data,
      tokens: tokens,
    };

    const response = await messaging.sendEachForMulticast(message);
    console.log(`${response.successCount} notificaciones enviadas exitosamente`);
    if (response.failureCount > 0) {
      console.log(`${response.failureCount} notificaciones fallaron`);
    }
  } catch (error) {
    console.error('Error al notificar miembros de sala:', error);
  }
}

/**
 * Detecta cuando alguien se une a una sala
 */
exports.onUserJoinedRoom = onDocumentUpdated('study_rooms/{roomId}', async (event) => {
  const roomId = event.params.roomId;
  const beforeMembers = event.data.before.data().members || [];
  const afterMembers = event.data.after.data().members || [];

  // Detectar nuevos miembros
  const newMembers = afterMembers.filter(id => !beforeMembers.includes(id));

  if (newMembers.length > 0) {
    // Obtener información de la sala y del nuevo miembro
    const roomData = event.data.after.data();
    const roomName = roomData.topic || 'una sala';
    const creatorId = roomData.creatorId;

    for (const newMemberId of newMembers) {
      // Obtener nombre del nuevo miembro
      const userDoc = await db.collection('users').doc(newMemberId).get();
      const userName = userDoc.exists ? userDoc.data().name || 'Alguien' : 'Alguien';

      // Notificar al creador
      if (creatorId && creatorId !== newMemberId) {
        await sendNotificationToUser(
          creatorId,
          '🎉 Nuevo miembro en tu sala',
          `${userName} se unió a "${roomName}"`,
          { roomId: roomId, type: 'user_joined' }
        );
      }

      // Notificar a otros miembros (excepto el creador que ya fue notificado y el nuevo miembro)
      const otherMembers = afterMembers.filter(
        id => id !== creatorId && id !== newMemberId
      );
      
      for (const memberId of otherMembers) {
        await sendNotificationToUser(
          memberId,
          '👋 Nuevo miembro',
          `${userName} se unió a "${roomName}"`,
          { roomId: roomId, type: 'user_joined' }
        );
      }
    }
  }
});

/**
 * Detecta cuando alguien abandona una sala
 */
exports.onUserLeftRoom = onDocumentUpdated('study_rooms/{roomId}', async (event) => {
  const roomId = event.params.roomId;
  const beforeMembers = event.data.before.data().members || [];
  const afterMembers = event.data.after.data().members || [];

  // Detectar miembros que salieron
  const leftMembers = beforeMembers.filter(id => !afterMembers.includes(id));

  if (leftMembers.length > 0) {
    // Obtener información de la sala
    const roomData = event.data.after.data();
    const roomName = roomData.topic || 'una sala';
    const creatorId = roomData.creatorId;

    for (const leftMemberId of leftMembers) {
      // Obtener nombre del miembro que salió
      const userDoc = await db.collection('users').doc(leftMemberId).get();
      const userName = userDoc.exists ? userDoc.data().name || 'Alguien' : 'Alguien';

      // Notificar al creador
      if (creatorId && creatorId !== leftMemberId) {
        await sendNotificationToUser(
          creatorId,
          '👋 Miembro abandonó tu sala',
          `${userName} salió de "${roomName}"`,
          { roomId: roomId, type: 'user_left' }
        );
      }

      // Notificar a otros miembros restantes (excepto el creador)
      const otherMembers = afterMembers.filter(id => id !== creatorId);
      
      for (const memberId of otherMembers) {
        await sendNotificationToUser(
          memberId,
          '👋 Miembro salió',
          `${userName} abandonó "${roomName}"`,
          { roomId: roomId, type: 'user_left' }
        );
      }
    }
  }
});

/**
 * Detecta cuando se envía un nuevo mensaje o archivo en una sala
 */
exports.onNewMessage = onDocumentCreated('study_rooms/{roomId}/messages/{messageId}', async (event) => {
  const roomId = event.params.roomId;
  const messageData = event.data.data();
  const senderId = messageData.senderId;
  const senderName = messageData.senderName || 'Alguien';
  const messageType = messageData.type || 'text';
  const messageText = messageData.text || '';

  // Obtener información de la sala
  const roomDoc = await db.collection('study_rooms').doc(roomId).get();
  if (!roomDoc.exists) {
    console.log(`Sala ${roomId} no existe`);
    return;
  }

  const roomName = roomDoc.data().topic || 'una sala';

  // Determinar el título y cuerpo de la notificación
  let title, body;
  if (messageType === 'file') {
    title = `📎 Archivo en ${roomName}`;
    body = messageText 
      ? `${senderName}: ${messageText}` 
      : `${senderName} compartió un archivo`;
  } else {
    title = `💬 Mensaje en ${roomName}`;
    body = `${senderName}: ${messageText}`;
  }

  // Notificar a todos los miembros excepto al que envió el mensaje
  await notifyRoomMembers(
    roomId,
    senderId,
    title,
    body,
    { roomId: roomId, type: 'new_message', messageType: messageType }
  );
});

/**
 * Notifica a usuarios que tienen inscrito un ramo cuando se crea una sala de ese ramo
 */
exports.onRoomCreated = onDocumentCreated('study_rooms/{roomId}', async (event) => {
  const roomId = event.params.roomId;
  const roomData = event.data.data();
  const courseCode = roomData.courseCode;
  const roomName = roomData.topic || 'una sala';
  const creatorId = roomData.creatorId;
  const campus = roomData.campus || 'Online';
  const isOnline = roomData.type === 'Online';

  // Si no tiene código de ramo, no notificar
  if (!courseCode || courseCode === 'N/A' || courseCode === '') {
    console.log('Sala sin código de ramo, no se envían notificaciones');
    return;
  }

  console.log(`Nueva sala creada: ${roomName} (${courseCode})`);

  try {
    // Obtener todos los usuarios
    const usersSnapshot = await db.collection('users').get();
    const notificationsToSend = [];

    // Definir el appId (mismo que en Flutter)
    const appId = 'default-app-id';

    for (const userDoc of usersSnapshot.docs) {
      const userId = userDoc.id;

      // No notificar al creador
      if (userId === creatorId) continue;

      // Verificar si el usuario no tiene token FCM
      const fcmToken = userDoc.data().fcmToken;
      if (!fcmToken) continue;

      // Obtener los ramos del usuario desde artifacts
      const ramosPath = `artifacts/${appId}/users/${userId}/profile_data/data`;
      const ramosDoc = await db.doc(ramosPath).get();

      if (!ramosDoc.exists) continue;

      const currentRamos = ramosDoc.data().current_ramos || [];

      // Verificar si el usuario tiene inscrito este ramo
      if (currentRamos.includes(courseCode)) {
        const location = isOnline ? '🌐 Online' : `📍 ${campus}`;
        const title = `🆕 Nueva sala de ${courseCode}`;
        const body = `"${roomName}" • ${location}`;

        notificationsToSend.push({
          userId: userId,
          token: fcmToken,
          title: title,
          body: body,
        });
      }
    }

    // Enviar notificaciones
    if (notificationsToSend.length === 0) {
      console.log('No hay usuarios con este ramo inscrito');
      return;
    }

    console.log(`Enviando notificaciones a ${notificationsToSend.length} usuarios`);

    // Enviar en lotes para mejor performance
    const messages = notificationsToSend.map(notif => ({
      notification: {
        title: notif.title,
        body: notif.body,
      },
      data: {
        roomId: roomId,
        type: 'new_room',
        courseCode: courseCode,
        roomName: roomName,
      },
      token: notif.token,
    }));

    // Enviar todas las notificaciones
    const response = await messaging.sendEach(messages);
    console.log(`${response.successCount} notificaciones enviadas exitosamente`);
    if (response.failureCount > 0) {
      console.log(`${response.failureCount} notificaciones fallaron`);
    }

  } catch (error) {
    console.error('Error al notificar creación de sala:', error);
  }
});

/**
 * Función programada que se ejecuta cada 5 minutos para verificar 
 * si hay salas próximas a comenzar (30 minutos antes)
 */
exports.checkUpcomingRooms = onSchedule('every 5 minutes', async (event) => {
  console.log('Verificando salas próximas a comenzar...');
  
  try {
    const now = admin.firestore.Timestamp.now();
    const nowDate = now.toDate();
    
    // Calculamos el rango: desde 30 minutos en el futuro hasta 35 minutos
    // (para cubrir la ventana de 5 minutos que se ejecuta esta función)
    const startRange = new Date(nowDate.getTime() + 30 * 60000); // +30 min
    const endRange = new Date(nowDate.getTime() + 35 * 60000);   // +35 min
    
    const startTimestamp = admin.firestore.Timestamp.fromDate(startRange);
    const endTimestamp = admin.firestore.Timestamp.fromDate(endRange);
    
    console.log(`Buscando salas entre ${startRange.toISOString()} y ${endRange.toISOString()}`);
    
    // Buscar salas cuyo scheduledTime esté en el rango
    const roomsSnapshot = await db.collection('study_rooms')
      .where('scheduledTime', '>=', startTimestamp)
      .where('scheduledTime', '<=', endTimestamp)
      .get();
    
    if (roomsSnapshot.empty) {
      console.log('No hay salas próximas a comenzar');
      return;
    }
    
    console.log(`Encontradas ${roomsSnapshot.size} salas próximas a comenzar`);
    
    // Procesar cada sala
    for (const roomDoc of roomsSnapshot.docs) {
      const roomId = roomDoc.id;
      const roomData = roomDoc.data();
      const roomName = roomData.topic || 'una sala';
      const members = roomData.members || [];
      const scheduledTime = roomData.scheduledTime.toDate();
      const isOnline = roomData.type === 'Online';
      const campus = roomData.campus || 'Online';
      
      // Verificar si ya se envió notificación para esta sala
      // (para evitar duplicados en ejecuciones consecutivas)
      const notificationSent = roomData.reminderSent || false;
      if (notificationSent) {
        console.log(`Sala ${roomId} ya tiene notificación enviada`);
        continue;
      }
      
      console.log(`Procesando sala: ${roomName} (${members.length} miembros)`);
      
      // Formatear la hora
      const hours = scheduledTime.getHours().toString().padStart(2, '0');
      const minutes = scheduledTime.getMinutes().toString().padStart(2, '0');
      const timeStr = `${hours}:${minutes}`;
      
      // Obtener tokens de todos los miembros
      const memberTokens = [];
      for (const memberId of members) {
        try {
          const userDoc = await db.collection('users').doc(memberId).get();
          if (userDoc.exists) {
            const fcmToken = userDoc.data().fcmToken;
            if (fcmToken) {
              memberTokens.push({
                userId: memberId,
                token: fcmToken,
                name: userDoc.data().name || 'Usuario',
              });
            }
          }
        } catch (error) {
          console.error(`Error obteniendo usuario ${memberId}:`, error);
        }
      }
      
      if (memberTokens.length === 0) {
        console.log(`Sala ${roomId} no tiene miembros con tokens FCM`);
        continue;
      }
      
      // Preparar notificaciones
      const location = isOnline ? '🌐 Online' : `📍 ${campus}`;
      const title = `⏰ Recordatorio de sesión`;
      const body = `"${roomName}" comienza en 30 minutos • ${timeStr} • ${location}`;
      
      const messages = memberTokens.map(member => ({
        notification: {
          title: title,
          body: body,
        },
        data: {
          roomId: roomId,
          type: 'room_reminder',
          roomName: roomName,
          scheduledTime: scheduledTime.toISOString(),
        },
        token: member.token,
      }));
      
      // Enviar notificaciones
      const response = await messaging.sendEach(messages);
      console.log(`Sala ${roomId}: ${response.successCount} notificaciones enviadas, ${response.failureCount} fallidas`);
      
      // Marcar como notificación enviada para evitar duplicados
      await db.collection('study_rooms').doc(roomId).update({
        reminderSent: true,
      });
    }
    
    console.log('Verificación de salas completada');
    
  } catch (error) {
    console.error('Error en verificación de salas próximas:', error);
  }
});

/**
 * Resetea el flag reminderSent cuando se actualiza la hora de una sala
 * para que se pueda enviar un nuevo recordatorio
 */
exports.onRoomScheduleUpdated = onDocumentUpdated('study_rooms/{roomId}', async (event) => {
  const beforeData = event.data.before.data();
  const afterData = event.data.after.data();
  
  // Verificar si se actualizó scheduledTime
  const beforeTime = beforeData.scheduledTime;
  const afterTime = afterData.scheduledTime;
  
  if (!beforeTime || !afterTime) return;
  
  // Comparar timestamps
  const beforeMillis = beforeTime.toMillis();
  const afterMillis = afterTime.toMillis();
  
  // Si la hora cambió, resetear el flag de recordatorio
  if (beforeMillis !== afterMillis) {
    console.log(`Hora de sala ${event.params.roomId} actualizada, reseteando reminderSent`);
    
    await event.data.after.ref.update({
      reminderSent: false,
    });
  }
});
