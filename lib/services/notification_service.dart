import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Handler para mensajes en segundo plano (debe ser top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Mensaje recibido en segundo plano: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _initialized = false;

  /// Inicializa el servicio de notificaciones
  Future<void> initialize() async {
    if (_initialized) return;

    // Solicitar permisos
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      print('Usuario no autorizó las notificaciones');
      return;
    }

    // Configurar notificaciones locales para Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Crear canal de notificación para Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'studymatch_channel', // id
      'StudyMatch Notificaciones', // nombre
      description: 'Notificaciones de salas de estudio',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Obtener y guardar el token FCM
    String? token = await _fcm.getToken();
    if (token != null) {
      await _saveTokenToFirestore(token);
    }

    // Escuchar cambios de token
    _fcm.onTokenRefresh.listen(_saveTokenToFirestore);

    // Configurar handlers de mensajes
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    _initialized = true;
    print('NotificationService inicializado correctamente');
  }

  /// Guarda el token FCM en Firestore
  Future<void> _saveTokenToFirestore(String token) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });
      print('Token FCM guardado: $token');
    } catch (e) {
      print('Error al guardar token FCM: $e');
    }
  }

  /// Maneja mensajes cuando la app está en primer plano
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Mensaje recibido en primer plano: ${message.messageId}');

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'studymatch_channel',
            'StudyMatch Notificaciones',
            channelDescription: 'Notificaciones de salas de estudio',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: message.data['roomId'],
      );
    }
  }

  /// Maneja cuando el usuario toca una notificación que abrió la app
  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    print('Usuario abrió la app desde notificación: ${message.messageId}');
    // Aquí podrías navegar a la sala específica usando message.data['roomId']
  }

  /// Maneja cuando el usuario toca una notificación local
  void _onNotificationTapped(NotificationResponse response) {
    print('Notificación tocada con payload: ${response.payload}');
    // Aquí podrías navegar a la sala específica usando response.payload (roomId)
  }

  /// Suscribe al usuario a notificaciones de una sala específica
  Future<void> subscribeToRoom(String roomId) async {
    try {
      await _fcm.subscribeToTopic('room_$roomId');
      print('Suscrito a notificaciones de sala: $roomId');
    } catch (e) {
      print('Error al suscribirse a sala: $e');
    }
  }

  /// Desuscribe al usuario de notificaciones de una sala
  Future<void> unsubscribeFromRoom(String roomId) async {
    try {
      await _fcm.unsubscribeFromTopic('room_$roomId');
      print('Desuscrito de notificaciones de sala: $roomId');
    } catch (e) {
      print('Error al desuscribirse de sala: $e');
    }
  }

  /// Limpia el token al cerrar sesión
  Future<void> clearToken() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': FieldValue.delete(),
      });
      print('Token FCM eliminado');
    } catch (e) {
      print('Error al eliminar token FCM: $e');
    }
  }
}
