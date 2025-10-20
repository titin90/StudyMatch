# Almacenamiento de Datos - StudyMatch

## 📊 Arquitectura de Almacenamiento

StudyMatch utiliza una arquitectura **híbrida** de almacenamiento:

```
┌─────────────────────────────────────────────────┐
│           ALMACENAMIENTO LOCAL                  │
│  (Datos estáticos en el código)                │
│                                                 │
│  • Mallas curriculares (ramo_data.dart)        │
│  • Colores y constantes de UI                  │
│  • Configuración de la app                     │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│           CLOUD FIRESTORE                       │
│  (Base de datos en tiempo real)                │
│                                                 │
│  • Perfiles de usuarios                        │
│  • Salas de estudio                            │
│  • Mensajes de chat                            │
│  • Ramos activos por usuario                   │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│         FIREBASE AUTHENTICATION                 │
│  (Gestión de usuarios)                         │
│                                                 │
│  • Credenciales de usuario                     │
│  • Tokens de sesión                            │
└─────────────────────────────────────────────────┘
```

---

## 💾 ALMACENAMIENTO LOCAL

### 1. Datos Estáticos de Ramos

**Archivo:** `lib/ramo_data.dart`

#### Clase `Ramo`

```dart
class Ramo {
  final String code;        // "IWI-131"
  final String name;        // "Programación"
  final String careerId;    // "INF"
  final String year;        // "1"
  final String semester;    // "I"
  final int credits;        // 4

  const Ramo({
    required this.code,
    required this.name,
    required this.careerId,
    required this.year,
    required this.semester,
    this.credits = 5,
  });
}
```

#### Estructura de Datos

```dart
// Lista por carrera
final List<Ramo> civilInformaticaRamos = [
  const Ramo(
    code: 'IWI-131',
    name: 'Programación',
    careerId: 'INF',
    year: '1',
    semester: 'I',
    credits: 4,
  ),
  // ... más ramos
];

final List<Ramo> civilIndustrialRamos = [ /* ... */ ];

// Lista consolidada
final List<Ramo> allRamos = [
  ...civilInformaticaRamos,
  ...civilIndustrialRamos,
];
```

#### ¿Por qué Local?

✅ **No cambian frecuentemente** - Las mallas curriculares son estables
✅ **Acceso instantáneo** - No requiere conexión a internet
✅ **Sin costo** - No consume cuota de Firestore
✅ **Fácil de actualizar** - Basta editar el archivo

#### Carreras Disponibles

| ID   | Nombre de la Carrera              | Ramos Definidos |
|------|-----------------------------------|-----------------|
| INF  | Ingeniería Civil Informática      | 5 ramos         |
| IND  | Ingeniería Civil Industrial       | 7 ramos         |
| COM  | Ingeniería Comercial              | Pendiente       |
| ARQ  | Arquitectura                      | Pendiente       |
| TEC  | Técnico Universitario             | Pendiente       |
| OTR  | Otra / No Especificada            | N/A             |

#### Cómo Agregar Más Ramos

```dart
// 1. Crear lista para nueva carrera
final List<Ramo> ingenieriaComercialRamos = [
  const Ramo(
    code: 'ECO-101',
    name: 'Economía General',
    careerId: 'COM',
    year: '1',
    semester: 'I',
    credits: 5,
  ),
  // ... más ramos
];

// 2. Agregar a la lista consolidada
final List<Ramo> allRamos = [
  ...civilInformaticaRamos,
  ...civilIndustrialRamos,
  ...ingenieriaComercialRamos,  // ← Nueva carrera
];
```

---

## ☁️ CLOUD FIRESTORE

Firebase Firestore es la base de datos principal. Estructura **NoSQL** basada en documentos.

### Estructura General

```
firestore/
├── users/
│   └── {uid}/
│       ├── name
│       ├── email
│       ├── career_id
│       ├── career_name
│       ├── campus
│       ├── phone
│       └── activeCourses (lista)
│
├── study_rooms/
│   └── {roomId}/
│       ├── courseCode
│       ├── courseName
│       ├── topic
│       ├── creatorId
│       ├── members (lista)
│       ├── campus
│       ├── type
│       ├── scheduledTime
│       ├── createdAt
│       ├── status
│       └── messages/ (subcolección)
│           └── {messageId}/
│               ├── text
│               ├── senderId
│               ├── senderName
│               └── timestamp
│
└── artifacts/
    └── {APP_ID}/
        └── users/
            └── {uid}/
                └── profile_data/
                    └── data/
                        └── current_ramos (lista)
```

---

## 📁 Colección: `users`

### Propósito
Almacenar el **perfil básico** de cada usuario registrado.

### Ruta
```
/users/{uid}
```

### Esquema de Documento

```json
{
  "name": "Juan Pérez",
  "phone": "+56912345678",
  "email": "juan.perez@usm.cl",
  "career_id": "INF",
  "career_name": "Ingeniería Civil Informática",
  "campus": "Campus San Joaquín",
  "activeCourses": [],
  "profileImageUrl": null,
  "createdAt": Timestamp(2025, 10, 19)
}
```

### Código de Creación

```dart
// signup_screen.dart - línea ~146-158
await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .set({
      'name': name,
      'phone': phone,
      'email': email,
      'career_name': careerName,
      'career_id': careerId,
      'campus': campus,
      'activeCourses': [],
      'profileImageUrl': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
```

### Código de Lectura

```dart
// profile_screen.dart - línea ~73-75
final rootDoc = await _firestore
    .collection('users')
    .doc(user.uid)
    .get();

final rootData = rootDoc.data() ?? {};
```

### Campos

| Campo           | Tipo      | Descripción                        | Requerido |
|-----------------|-----------|-------------------------------------|-----------|
| name            | string    | Nombre completo del usuario        | ✅        |
| phone           | string    | Número de teléfono                 | ✅        |
| email           | string    | Email institucional (@usm.cl)      | ✅        |
| career_id       | string    | ID corto de la carrera (INF, IND)  | ✅        |
| career_name     | string    | Nombre completo de la carrera      | ✅        |
| campus          | string    | Campus donde estudia               | ✅        |
| activeCourses   | array     | (Deprecado, usar Canvas Path)      | ⚠️        |
| profileImageUrl | string?   | URL de foto de perfil              | ❌        |
| createdAt       | Timestamp | Fecha de creación                  | ✅        |

---

## 📚 Ruta Canvas: `artifacts/{APP_ID}/users/{uid}/profile_data/data`

### Propósito
Almacenar los **ramos activos** que el usuario está cursando actualmente.

### Ruta Completa
```
/artifacts/{APP_ID}/users/{uid}/profile_data/data
```

### ¿Qué es APP_ID?
Es una variable de entorno definida en tiempo de compilación:

```dart
const appId = String.fromEnvironment(
  'APP_ID',
  defaultValue: 'default-app-id',
);
```

### Esquema de Documento

```json
{
  "current_ramos": [
    "IWI-131",
    "MAT-021",
    "FIS-100",
    "INF-134"
  ]
}
```

### Código de Escritura

```dart
// ramo_selection_screen.dart - línea ~50-60
Future<void> _updateRamosInFirestore() async {
  final docPath = _getProfileDocPath(user.uid);
  final List<String> ramosToSave = _selectedRamos.toList();

  await FirebaseFirestore.instance.doc(docPath).set({
    'current_ramos': ramosToSave,
  }, SetOptions(merge: true));
}
```

### Código de Lectura

```dart
// home_screen.dart - línea ~124-130
final ramosDocPath = _getRamosDocPath(userId);
final userRamosDoc = await FirebaseFirestore.instance
    .doc(ramosDocPath)
    .get();

final userActiveCourses = 
    (userRamosDoc.data()?['current_ramos'] as List<dynamic>?)
    ?.cast<String>()
    .toList() ?? [];
```

### ¿Por qué una Ruta Separada?

Esta estructura permite:
✅ **Separación de datos sensibles** - Diferentes reglas de seguridad
✅ **Compatibilidad con Canvas LMS** - Estructura usada por sistemas educativos
✅ **Escalabilidad** - Posibilidad de añadir más datos académicos

---

## 🏠 Colección: `study_rooms`

### Propósito
Almacenar las **salas de estudio** creadas por los usuarios.

### Ruta
```
/study_rooms/{roomId}
```

### Esquema de Documento

```json
{
  "creatorId": "abc123",
  "creatorEmail": "juan.perez@usm.cl",
  "courseCode": "IWI-131",
  "courseName": "Programación",
  "topic": "Certamen 1 - Repaso Capítulo 3",
  "campus": "Campus San Joaquín",
  "type": "Online",
  "scheduledTime": Timestamp(2025, 10, 25, 15, 30),
  "createdAt": Timestamp(2025, 10, 19, 10, 0),
  "members": ["abc123", "def456", "ghi789"],
  "status": "active"
}
```

### Código de Creación

```dart
// create_room_screen.dart - línea ~117-130
await _firestore.collection('study_rooms').add({
  'creatorId': _auth.currentUser!.uid,
  'creatorEmail': _auth.currentUser!.email,
  'courseCode': _selectedCourseCode,
  'courseName': courseName,
  'topic': _topic,
  'campus': _campus,
  'type': _type,
  'scheduledTime': Timestamp.fromDate(scheduledDateTime),
  'createdAt': FieldValue.serverTimestamp(),
  'members': [_auth.currentUser!.uid],
  'status': 'active',
});
```

### Código de Lectura (Stream en Tiempo Real)

```dart
// home_screen.dart - línea ~307-315
Query roomsQuery = FirebaseFirestore.instance
    .collection('study_rooms');

if (_selectedFilterRamo != null && _selectedFilterRamo != 'Mostrar Todos') {
  roomsQuery = roomsQuery.where('courseCode', isEqualTo: _selectedFilterRamo);
}

StreamBuilder<QuerySnapshot>(
  stream: roomsQuery.snapshots(),  // ← Escucha cambios en tiempo real
  // ...
)
```

### Campos

| Campo          | Tipo      | Descripción                           |
|----------------|-----------|---------------------------------------|
| creatorId      | string    | UID del usuario que creó la sala      |
| creatorEmail   | string    | Email del creador                     |
| courseCode     | string    | Código del ramo (ej: "IWI-131")       |
| courseName     | string    | Nombre del ramo                       |
| topic          | string    | Tema específico de estudio            |
| campus         | string    | Ubicación (presencial u online)       |
| type           | string    | "Online" o "Presencial"               |
| scheduledTime  | Timestamp | Fecha/hora programada                 |
| createdAt      | Timestamp | Fecha de creación de la sala          |
| members        | array     | Lista de UIDs de miembros             |
| status         | string    | Estado: "active", "closed"            |

---

## 💬 Subcolección: `messages`

### Propósito
Almacenar los **mensajes del chat** de cada sala.

### Ruta
```
/study_rooms/{roomId}/messages/{messageId}
```

### Esquema de Documento

```json
{
  "text": "Hola, ¿a qué hora empezamos?",
  "senderId": "abc123",
  "senderName": "Juan Pérez",
  "timestamp": Timestamp(2025, 10, 19, 15, 30)
}
```

### Código de Escritura

```dart
// chat_room_screen.dart - línea ~59-67
final roomMessagesRef = _firestore
    .collection('study_rooms')
    .doc(widget.room.id)
    .collection('messages');

await roomMessagesRef.add({
  'text': text,
  'senderId': userId,
  'senderName': _currentUserName,
  'timestamp': FieldValue.serverTimestamp(),
});
```

### Código de Lectura (Stream)

```dart
// chat_room_screen.dart - línea ~78-83
StreamBuilder<QuerySnapshot>(
  stream: _firestore
      .collection('study_rooms')
      .doc(widget.room.id)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots(),
  // ...
)
```

### Ventajas de Usar Subcolección

✅ **Escalabilidad** - Cada sala puede tener miles de mensajes sin afectar el rendimiento
✅ **Consultas eficientes** - Solo se cargan los mensajes de la sala actual
✅ **Organización** - Estructura jerárquica clara

---

## 🔄 Datos en Tiempo Real

### StreamBuilder

Firebase Firestore permite **escuchar cambios en tiempo real** usando `snapshots()`:

```dart
StreamBuilder<QuerySnapshot>(
  stream: collection.snapshots(),  // ← Escucha en tiempo real
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      // Los datos se actualizan automáticamente
      final docs = snapshot.data!.docs;
      // Construir UI con docs
    }
  },
)
```

### Casos de Uso en StudyMatch

1. **Lista de Salas (HomeScreen):**
   - Cualquier sala nueva aparece automáticamente
   - Cambios en salas existentes se reflejan al instante

2. **Chat (ChatRoomScreen):**
   - Mensajes nuevos aparecen sin refrescar
   - Usuarios ven mensajes de otros en tiempo real

3. **Conteo de Miembros:**
   - Se actualiza cuando alguien se une o sale

---

## 📏 Límites y Cuotas de Firestore

### Plan Gratuito (Spark)

| Recurso                | Límite Diario    | Límite Mensual   |
|------------------------|------------------|------------------|
| Lecturas               | 50,000           | 1,500,000        |
| Escrituras             | 20,000           | 600,000          |
| Eliminaciones          | 20,000           | 600,000          |
| Almacenamiento         | -                | 1 GB             |
| Transferencia de red   | -                | 10 GB/mes        |

### Optimizaciones Implementadas

✅ **Mallas curriculares locales** - No consumen lecturas
✅ **Queries filtrados** - Solo se cargan salas relevantes
✅ **Sin polling** - Se usa escucha en tiempo real eficiente
✅ **Merge en updates** - Solo actualiza campos modificados

### Recomendaciones para Escalar

1. **Implementar caché local** con `persistence: true`
2. **Limitar mensajes cargados** (ej: últimos 50)
3. **Implementar paginación** en la lista de salas
4. **Usar índices compuestos** para queries complejas

---

## 🔐 Reglas de Seguridad (Pendientes)

### Estado Actual
⚠️ **Las reglas deben configurarse manualmente** en Firebase Console

### Reglas Recomendadas

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Usuarios: solo pueden leer/escribir su propio documento
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Canvas Path: solo el usuario propietario
    match /artifacts/{appId}/users/{userId}/profile_data/data {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Salas: todos pueden leer, solo autenticados pueden crear
    match /study_rooms/{roomId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth != null && 
                       (request.auth.uid == resource.data.creatorId ||
                        request.auth.uid in resource.data.members);
      allow delete: if request.auth != null && 
                       request.auth.uid == resource.data.creatorId;
      
      // Mensajes: miembros de la sala pueden leer/escribir
      match /messages/{messageId} {
        allow read: if request.auth != null && 
                       request.auth.uid in get(/databases/$(database)/documents/study_rooms/$(roomId)).data.members;
        allow create: if request.auth != null && 
                         request.auth.uid in get(/databases/$(database)/documents/study_rooms/$(roomId)).data.members;
      }
    }
  }
}
```

---

## 📊 Comparación: Local vs Nube

| Aspecto              | Local (Código)               | Nube (Firestore)              |
|----------------------|------------------------------|-------------------------------|
| **Tipo de Datos**    | Mallas curriculares          | Perfiles, salas, mensajes     |
| **Acceso**           | Instantáneo, sin internet    | Requiere conexión             |
| **Actualización**    | Deploy de nueva versión      | En tiempo real automático     |
| **Costo**            | Gratis                       | Cuota gratuita limitada       |
| **Escalabilidad**    | Limitada (tamaño del APK)    | Ilimitada                     |
| **Sincronización**   | No aplica                    | Multi-dispositivo automático  |
| **Búsquedas**        | Filtros en código            | Queries optimizadas           |

---

## 🛠️ Herramientas de Desarrollo

### Firebase Console
- **URL:** https://console.firebase.google.com
- Permite ver/editar datos en tiempo real
- Configurar reglas de seguridad
- Monitorear uso y cuotas

### Firestore Emulator (Opcional)
Para desarrollo local sin consumir cuota:

```bash
firebase emulators:start --only firestore
```

```dart
// Conectar al emulator
FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
```

---

**Siguiente:** [Funciones Principales →](05_FUNCIONES_PRINCIPALES.md)
