# Estado Actual del Proyecto - StudyMatch

## 📋 Índice

1. [Resumen Ejecutivo](#-resumen-ejecutivo)
2. [Features Implementadas](#-features-implementadas)
3. [Features Pendientes](#-features-pendientes)
4. [Problemas Conocidos](#-problemas-conocidos)
5. [Deuda Técnica](#-deuda-técnica)
6. [Roadmap](#-roadmap)

---

## 📊 Resumen Ejecutivo

### Estado del Proyecto
🟢 **MVP Funcional** - La aplicación tiene un flujo completo de usuario y las funcionalidades básicas están operativas.

### Porcentaje de Completitud

```
Autenticación          ████████████████████ 100%
Perfiles               ███████████████░░░░░  75%
Salas de Estudio       ████████████████░░░░  80%
Chat                   ██████████████░░░░░░  70%
Selección de Ramos     ████████████████████ 100%
Notificaciones         ░░░░░░░░░░░░░░░░░░░░   0%
Búsqueda Avanzada      ░░░░░░░░░░░░░░░░░░░░   0%
Sistema de Reportes    ░░░░░░░░░░░░░░░░░░░░   0%
```

### Última Actualización
**Fecha:** Octubre 2025  
**Versión:** 1.0.0-beta  
**Plataforma:** Flutter 3.9.2

---

## ✅ Features Implementadas

### 1. 🔐 Autenticación Completa

| Feature                        | Estado | Descripción                                    |
|--------------------------------|--------|------------------------------------------------|
| Registro con email/password    | ✅     | Validación de dominio @usm.cl                  |
| Login con email/password       | ✅     | Manejo de errores Firebase                     |
| Persistencia de sesión         | ✅     | StreamBuilder en main.dart                     |
| Logout                         | ✅     | Cierre de sesión desde ProfileScreen          |
| Recuperación de contraseña     | ❌     | Pendiente implementar                          |

**Archivos:**
- `lib/screens/login_screen.dart` ✅
- `lib/screens/signup_screen.dart` ✅

**Validaciones:**
- Email debe terminar en @usm.cl o @sansano.usm.cl
- Contraseña mínimo 6 caracteres (regla de Firebase)
- Confirmación de contraseña en registro

---

### 2. 👤 Gestión de Perfiles

| Feature                        | Estado | Descripción                                    |
|--------------------------------|--------|------------------------------------------------|
| Crear perfil en registro       | ✅     | Documento en /users/{uid}                      |
| Ver perfil propio              | ✅     | ProfileScreen con datos de Firestore           |
| Editar perfil                  | ❌     | No implementado                                |
| Foto de perfil                 | ❌     | Campo existe pero sin funcionalidad            |
| Ver perfil de otros usuarios   | ❌     | No implementado                                |

**Archivos:**
- `lib/screens/profile_screen.dart` ✅

**Campos del Perfil:**
```dart
{
  'name': String,           // ✅ Implementado
  'email': String,          // ✅ Implementado
  'phone': String,          // ✅ Implementado
  'career_id': String,      // ✅ Implementado
  'career_name': String,    // ✅ Implementado
  'campus': String,         // ✅ Implementado
  'profileImageUrl': null,  // ⚠️ Campo existe, sin funcionalidad
  'createdAt': Timestamp,   // ✅ Implementado
}
```

---

### 3. 📚 Selección de Ramos

| Feature                        | Estado | Descripción                                    |
|--------------------------------|--------|------------------------------------------------|
| Lista de ramos por carrera     | ✅     | Filtrado automático según career_id            |
| Selección múltiple             | ✅     | Checkboxes con guardado automático             |
| Agrupación por año             | ✅     | UI organizada con _groupRamosByYear()          |
| Guardado en Firestore          | ✅     | Canvas path: artifacts/.../current_ramos       |
| Editar ramos después           | ✅     | Accesible desde HomeScreen                     |

**Archivos:**
- `lib/screens/ramo_selection_screen.dart` ✅
- `lib/ramo_data.dart` ✅

**Carreras con Ramos Definidos:**
- ✅ Ingeniería Civil Informática (5 ramos)
- ✅ Ingeniería Civil Industrial (7 ramos)
- ❌ Ingeniería Comercial (pendiente)
- ❌ Arquitectura (pendiente)
- ❌ Técnico Universitario (pendiente)

---

### 4. 🏠 Salas de Estudio

| Feature                          | Estado | Descripción                                  |
|----------------------------------|--------|----------------------------------------------|
| Crear sala                       | ✅     | Form completo en CreateRoomScreen            |
| Ver lista de salas               | ✅     | HomeScreen con StreamBuilder                 |
| Filtrar por ramo                 | ✅     | Dropdown con "Mostrar Todos"                 |
| Validar inscripción antes de unirse | ✅ | _checkAndJoinRoom() en HomeScreen            |
| Unirse a sala                    | ✅     | Agregar UID a array 'members'                |
| Salir de sala                    | ❌     | No implementado                              |
| Cerrar sala (creador)            | ❌     | No implementado                              |
| Ver detalles de sala             | ⚠️     | Información básica en card, no screen dedicado |
| Notificar nuevos miembros        | ❌     | No implementado                              |

**Archivos:**
- `lib/screens/home_screen.dart` ✅
- `lib/screens/create_room_screen.dart` ✅

**Validaciones al Crear Sala:**
- ✅ Usuario debe estar inscrito en el ramo
- ✅ Fecha/hora deben ser futuras
- ✅ Todos los campos requeridos completos
- ✅ Solo ramos activos del usuario en dropdown

**Campos de Sala:**
```dart
{
  'creatorId': String,        // ✅
  'creatorEmail': String,     // ✅
  'courseCode': String,       // ✅
  'courseName': String,       // ✅
  'topic': String,            // ✅
  'campus': String,           // ✅
  'type': String,             // ✅ "Online" o "Presencial"
  'scheduledTime': Timestamp, // ✅
  'createdAt': Timestamp,     // ✅
  'members': Array<String>,   // ✅
  'status': String,           // ✅ "active" (no se usa aún)
}
```

---

### 5. 💬 Chat en Tiempo Real

| Feature                        | Estado | Descripción                                    |
|--------------------------------|--------|------------------------------------------------|
| Enviar mensajes                | ✅     | Texto simple con timestamp del servidor        |
| Recibir mensajes en tiempo real| ✅     | StreamBuilder con .snapshots()                 |
| Ver nombre del remitente       | ✅     | Campo 'senderName' en cada mensaje             |
| Scroll automático              | ⚠️     | Lista en reverse, pero sin auto-scroll al nuevo mensaje |
| Indicador de "escribiendo"     | ❌     | No implementado                                |
| Notificaciones push            | ❌     | No implementado                                |
| Enviar imágenes/archivos       | ❌     | No implementado                                |
| Reacciones a mensajes          | ❌     | No implementado                                |
| Editar/eliminar mensajes       | ❌     | No implementado                                |
| Buscar en chat                 | ❌     | No implementado                                |

**Archivos:**
- `lib/screens/chat_room_screen.dart` ✅

**Esquema de Mensaje:**
```dart
{
  'text': String,        // ✅
  'senderId': String,    // ✅
  'senderName': String,  // ✅
  'timestamp': Timestamp,// ✅
}
```

---

### 6. 🎨 UI/UX

| Feature                        | Estado | Descripción                                    |
|--------------------------------|--------|------------------------------------------------|
| Tema de colores coherente      | ✅     | Azul (#0560FA) y naranja (#EC8000)             |
| Diseño responsivo              | ⚠️     | Funciona, pero sin optimización por tamaño     |
| Animaciones de transición      | ❌     | Transiciones por defecto de Flutter            |
| Dark mode                      | ❌     | No implementado                                |
| Personalización de colores     | ❌     | No implementado                                |
| Accesibilidad                  | ❌     | Sin soporte VoiceOver/TalkBack                 |

**Paleta de Colores:**
```dart
primaryColor: Color(0xFF0560FA)    // Azul USM
accentColor: Color(0xFFEC8000)     // Naranja USM
backgroundColor: Colors.grey[100]
textPrimaryColor: Colors.black87
textSecondaryColor: Colors.grey[600]
```

---

## ❌ Features Pendientes

### 1. 🔔 Sistema de Notificaciones

| Feature                          | Prioridad | Complejidad |
|----------------------------------|-----------|-------------|
| Notificaciones push (FCM)        | Alta      | Media       |
| Notificaciones in-app            | Media     | Baja        |
| Notificar nuevos mensajes        | Alta      | Media       |
| Notificar invitación a sala      | Media     | Media       |
| Notificar recordatorio de sesión | Baja      | Alta        |

**Dependencias Requeridas:**
```yaml
firebase_messaging: ^14.0.0
flutter_local_notifications: ^15.0.0
```

**Archivos a Crear:**
- `lib/services/notification_service.dart`
- `lib/utils/fcm_handler.dart`

---

### 2. 🔍 Búsqueda Avanzada

| Feature                          | Prioridad | Complejidad |
|----------------------------------|-----------|-------------|
| Buscar salas por ramo            | Media     | Baja        |
| Buscar salas por fecha           | Media     | Media       |
| Buscar salas por campus          | Baja      | Baja        |
| Buscar por palabra clave (topic) | Alta      | Media       |
| Filtros combinados               | Media     | Alta        |

**Implementación Sugerida:**
```dart
// home_screen.dart
Query _buildSearchQuery() {
  Query query = _firestore.collection('study_rooms');
  
  if (_searchRamo != null) {
    query = query.where('courseCode', isEqualTo: _searchRamo);
  }
  
  if (_searchCampus != null) {
    query = query.where('campus', isEqualTo: _searchCampus);
  }
  
  if (_searchDate != null) {
    query = query.where('scheduledTime', 
        isGreaterThanOrEqualTo: Timestamp.fromDate(_searchDate!));
  }
  
  return query;
}
```

---

### 3. ⭐ Sistema de Valoraciones

| Feature                          | Prioridad | Complejidad |
|----------------------------------|-----------|-------------|
| Valorar sesión de estudio        | Media     | Media       |
| Ver rating promedio de usuario   | Media     | Media       |
| Comentarios de valoraciones      | Baja      | Alta        |
| Sistema de reputación            | Baja      | Alta        |

**Esquema Propuesto:**
```dart
// Colección: ratings
{
  'roomId': String,
  'userId': String,
  'rating': int,              // 1-5 estrellas
  'comment': String?,
  'createdAt': Timestamp,
}

// Agregar a /users/{uid}
{
  'averageRating': double,
  'totalRatings': int,
}
```

---

### 4. 📁 Compartir Archivos

| Feature                          | Prioridad | Complejidad |
|----------------------------------|-----------|-------------|
| Subir archivos PDF               | Alta      | Alta        |
| Subir imágenes                   | Media     | Media       |
| Descargar archivos               | Alta      | Media       |
| Previsualizar archivos           | Baja      | Alta        |
| Límite de tamaño                 | Alta      | Baja        |

**Dependencias Requeridas:**
```yaml
firebase_storage: ^11.0.0
file_picker: ^5.0.0
```

**Implementación Sugerida:**
```dart
Future<void> _uploadFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'jpg', 'png'],
  );
  
  if (result != null) {
    final file = File(result.files.single.path!);
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('rooms/${widget.room.id}/${result.files.single.name}');
    
    await storageRef.putFile(file);
    final downloadUrl = await storageRef.getDownloadURL();
    
    // Guardar URL en Firestore
    await _firestore
        .collection('study_rooms')
        .doc(widget.room.id)
        .collection('files')
        .add({
      'name': result.files.single.name,
      'url': downloadUrl,
      'uploaderId': _auth.currentUser!.uid,
      'uploadedAt': FieldValue.serverTimestamp(),
    });
  }
}
```

---

### 5. 📊 Dashboard/Estadísticas

| Feature                          | Prioridad | Complejidad |
|----------------------------------|-----------|-------------|
| Salas creadas por usuario        | Baja      | Baja        |
| Salas a las que se unió          | Baja      | Baja        |
| Tiempo total de estudio          | Baja      | Alta        |
| Ramos más estudiados             | Baja      | Media       |
| Gráficos de actividad            | Muy Baja  | Alta        |

**Dependencias Requeridas:**
```yaml
fl_chart: ^0.65.0
```

---

### 6. 👥 Sistema de Amigos

| Feature                          | Prioridad | Complejidad |
|----------------------------------|-----------|-------------|
| Enviar solicitud de amistad      | Baja      | Media       |
| Aceptar/rechazar solicitudes     | Baja      | Media       |
| Ver lista de amigos              | Baja      | Baja        |
| Invitar amigo a sala             | Media     | Media       |
| Chat privado con amigo           | Muy Baja  | Alta        |

---

### 7. 🔒 Seguridad y Moderación

| Feature                          | Prioridad | Complejidad |
|----------------------------------|-----------|-------------|
| Reportar usuario                 | Media     | Media       |
| Reportar sala inapropiada        | Media     | Media       |
| Bloquear usuario                 | Baja      | Media       |
| Sistema de moderadores           | Baja      | Alta        |
| Filtro de palabras ofensivas     | Media     | Media       |

---

## ⚠️ Problemas Conocidos

### 1. 🐛 Bugs Identificados

| Problema                         | Severidad | Estado     | Archivo Afectado              |
|----------------------------------|-----------|------------|-------------------------------|
| ~~Null check en _formatTime()~~  | Baja      | ✅ Resuelto| ~~chat_room_screen.dart~~     |
| Scroll no automático en chat     | Media     | 🔴 Abierto | chat_room_screen.dart         |
| Foto de perfil no funcional      | Baja      | 🔴 Abierto | profile_screen.dart           |
| Sin validación de foto al registrar | Muy Baja | 🔴 Abierto| signup_screen.dart           |

---

### 2. 📱 Problemas de UX

| Problema                                     | Impacto | Solución Propuesta                  |
|----------------------------------------------|---------|-------------------------------------|
| No hay confirmación al salir de crear sala  | Bajo    | Agregar AlertDialog                 |
| Lista de ramos muy larga sin scroll suave   | Medio   | Implementar SliverAppBar            |
| No hay feedback visual al unirse a sala     | Alto    | Agregar SnackBar de confirmación    |
| Botón "enviar" siempre habilitado en chat   | Bajo    | Deshabilitar cuando campo está vacío|
| Sin indicador de conexión a internet        | Alto    | Agregar package connectivity_plus   |

---

### 3. 🔧 Deuda Técnica

#### Código Duplicado

**Problema:**
La función `_getRamosDocPath()` está duplicada en varios archivos.

**Archivos Afectados:**
- `home_screen.dart` (línea ~194)
- `ramo_selection_screen.dart` (línea ~63)
- `create_room_screen.dart` (línea ~149)
- `profile_screen.dart` (línea ~86)

**Solución:**
Crear archivo `lib/utils/firestore_paths.dart`:
```dart
const String appId = String.fromEnvironment(
  'APP_ID',
  defaultValue: 'default-app-id',
);

class FirestorePaths {
  static String ramosDocPath(String userId) {
    return 'artifacts/$appId/users/$userId/profile_data/data';
  }
  
  static String userDocPath(String userId) {
    return 'users/$userId';
  }
  
  static String studyRoomPath(String roomId) {
    return 'study_rooms/$roomId';
  }
  
  static String roomMessagesPath(String roomId) {
    return 'study_rooms/$roomId/messages';
  }
}
```

---

#### Sin Manejo de Estados Complejos

**Problema:**
Todos los widgets usan `StatefulWidget` con `setState()`. Para estados complejos esto puede causar rebuilds innecesarios.

**Solución Recomendada:**
Implementar gestión de estado con **Provider** o **Riverpod**.

**Ejemplo con Provider:**
```yaml
dependencies:
  provider: ^6.0.0
```

```dart
// lib/providers/auth_provider.dart
class AuthProvider extends ChangeNotifier {
  User? _user;
  
  User? get user => _user;
  
  Future<void> signIn(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }
}
```

---

#### Sin Pruebas Unitarias

**Estado Actual:**
- 0 pruebas unitarias
- 0 pruebas de integración
- 0 pruebas de widget

**Recomendación:**
Crear directorio `test/` con:
```
test/
├── unit/
│   ├── models/
│   │   └── ramo_test.dart
│   └── utils/
│       └── validators_test.dart
├── widget/
│   ├── login_screen_test.dart
│   └── chat_room_screen_test.dart
└── integration/
    └── create_room_flow_test.dart
```

**Ejemplo de Test:**
```dart
// test/unit/utils/validators_test.dart
import 'package:test/test.dart';

void main() {
  group('Email Validation', () {
    test('Valid USM email returns true', () {
      expect(isValidInstitutionalEmail('juan@usm.cl'), true);
    });
    
    test('Invalid email returns false', () {
      expect(isValidInstitutionalEmail('juan@gmail.com'), false);
    });
  });
}
```

---

#### Sin Manejo de Errores Centralizado

**Problema:**
Cada pantalla maneja errores de forma distinta. No hay logging centralizado.

**Solución:**
Crear servicio de errores:

```dart
// lib/services/error_service.dart
class ErrorService {
  static void handleError(dynamic error, {StackTrace? stackTrace}) {
    // 1. Log a consola
    debugPrint('ERROR: $error');
    if (stackTrace != null) {
      debugPrint('STACK TRACE: $stackTrace');
    }
    
    // 2. Enviar a servicio de monitoreo (ej: Sentry)
    // Sentry.captureException(error, stackTrace: stackTrace);
    
    // 3. Mostrar mensaje user-friendly
    String userMessage = _getUserFriendlyMessage(error);
    // Mostrar snackbar o dialog
  }
  
  static String _getUserFriendlyMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No existe una cuenta con este correo';
        case 'wrong-password':
          return 'Contraseña incorrecta';
        default:
          return 'Error de autenticación';
      }
    }
    
    if (error is FirebaseException) {
      return 'Error de conexión con el servidor';
    }
    
    return 'Ha ocurrido un error inesperado';
  }
}
```

---

#### Sin Persistencia Offline

**Problema:**
La app no funciona sin conexión a internet. Firestore tiene soporte para caché offline pero no está habilitado explícitamente.

**Solución:**
```dart
// main.dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

// Habilitar persistencia offline
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```

---

## 🗺️ Roadmap

### Versión 1.1 (Corto Plazo - 1-2 meses)

**Objetivo:** Mejorar estabilidad y experiencia del MVP

| Feature                          | Prioridad | Estimación |
|----------------------------------|-----------|------------|
| Corregir scroll en chat          | Alta      | 2 horas    |
| Implementar foto de perfil       | Alta      | 1 semana   |
| Agregar edición de perfil        | Alta      | 3 días     |
| Notificaciones push básicas      | Alta      | 1 semana   |
| Búsqueda por palabra clave       | Media     | 3 días     |
| Confirmaciones de acciones       | Media     | 2 días     |
| Refactorizar código duplicado    | Alta      | 1 semana   |
| Escribir pruebas unitarias       | Media     | 1 semana   |

**Total Estimado:** 5-6 semanas

---

### Versión 1.2 (Mediano Plazo - 3-4 meses)

**Objetivo:** Expandir funcionalidades core

| Feature                          | Prioridad | Estimación |
|----------------------------------|-----------|------------|
| Compartir archivos PDF/imágenes  | Alta      | 2 semanas  |
| Sistema de valoraciones          | Media     | 1 semana   |
| Salir de sala                    | Alta      | 2 días     |
| Cerrar sala (creador)            | Alta      | 2 días     |
| Dashboard con estadísticas       | Baja      | 1 semana   |
| Filtros avanzados de búsqueda    | Media     | 1 semana   |
| Dark mode                        | Baja      | 3 días     |

**Total Estimado:** 6-7 semanas

---

### Versión 2.0 (Largo Plazo - 6+ meses)

**Objetivo:** Features avanzadas y escalabilidad

| Feature                          | Prioridad | Estimación |
|----------------------------------|-----------|------------|
| Sistema de amigos                | Media     | 2 semanas  |
| Chat privado entre usuarios      | Baja      | 2 semanas  |
| Videollamadas integradas         | Muy Baja  | 3 semanas  |
| Sistema de reportes/moderación   | Media     | 2 semanas  |
| Integración con Canvas LMS       | Alta      | 4 semanas  |
| Gamificación (badges, niveles)   | Muy Baja  | 2 semanas  |
| App para iOS                     | Alta      | 2 semanas  |
| Backend en Node.js/Express       | Media     | 4 semanas  |

**Total Estimado:** 19-20 semanas

---

## 📈 Métricas de Éxito

### KPIs a Monitorear

| Métrica                          | Objetivo | Herramienta               |
|----------------------------------|----------|---------------------------|
| Usuarios registrados             | 500+     | Firebase Analytics        |
| Salas creadas por semana         | 50+      | Firestore query           |
| Tasa de retención (7 días)       | 40%      | Firebase Analytics        |
| Mensajes enviados por día        | 200+     | Firestore query           |
| Tiempo promedio en la app        | 15 min   | Firebase Analytics        |
| Tasa de error en login           | < 5%     | Firebase Crashlytics      |
| Rating promedio de la app        | 4.0+     | Google Play Store / App Store |

---

## 🚀 Cómo Contribuir

### Prioridades de Desarrollo

1. **Crítico:** Bugs que impiden usar la app
2. **Alto:** Features que mejoran experiencia core
3. **Medio:** Mejoras de UX/UI
4. **Bajo:** Features nice-to-have

### Issues Abiertos

Para ver la lista completa de issues y contribuir:
1. Revisar `README.md` del proyecto
2. Buscar issues etiquetados con `good-first-issue`
3. Comentar en el issue antes de empezar a trabajar

---

## 📞 Contacto

**Desarrollador Principal:** [Nombre del equipo]  
**Email:** [email@example.com]  
**Repositorio:** [GitHub URL]

---

**[← Volver al Índice](README.md)**
