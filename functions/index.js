const {onDocumentUpdated, onDocumentCreated} = require('firebase-functions/v2/firestore');
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
