# Flujo de la Aplicación - StudyMatch

## 📱 Recorrido Completo del Usuario

Este documento describe el flujo completo desde que un usuario abre la app hasta que participa en una sala de estudio.

---

## 1️⃣ Inicio de la Aplicación

### Flujo de Autenticación Automática

```
main.dart (inicialización)
    ↓
Firebase.initializeApp()
    ↓
StreamBuilder<User?> escucha authStateChanges()
    ↓
┌─────────────────────┐
│ ¿Usuario logueado?  │
└─────────────────────┘
    │           │
    NO          SÍ
    ↓           ↓
LoginScreen   HomeScreen
```

### Código Relevante
```dart
// main.dart línea 26-44
home: StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return const HomeScreen();  // Ya tiene sesión
    }
    return const LoginScreen();   // Debe iniciar sesión
  },
)
```

---

## 2️⃣ Primer Uso - Registro

### Pantalla: `signup_screen.dart`

**Flujo del Registro:**

```
1. Usuario completa formulario
   ├── Nombre completo
   ├── Teléfono
   ├── Email institucional (@usm.cl)
   ├── Contraseña
   ├── Selección de Carrera
   └── Selección de Campus

2. Validaciones
   ├── Todos los campos completos
   ├── Email termina en @usm.cl
   ├── Contraseña ≥ 6 caracteres
   └── Términos aceptados

3. Firebase Authentication
   └── createUserWithEmailAndPassword()

4. Guardar perfil en Firestore
   └── collection('users').doc(uid).set({
       name, phone, email,
       career_id, career_name,
       campus, activeCourses: []
   })

5. Redirección
   └── PlaceholderScreen → HomeScreen
```

### Estructura de Datos Creada
```json
{
  "users/{uid}": {
    "name": "Juan Pérez",
    "phone": "+56912345678",
    "email": "juan.perez@usm.cl",
    "career_id": "INF",
    "career_name": "Ingeniería Civil Informática",
    "campus": "Campus San Joaquín",
    "activeCourses": [],
    "profileImageUrl": null,
    "createdAt": Timestamp
  }
}
```

---

## 3️⃣ Inicio de Sesión

### Pantalla: `login_screen.dart`

**Flujo del Login:**

```
1. Usuario ingresa credenciales
   ├── Email (@usm.cl)
   └── Contraseña

2. Validación de dominio
   └── email.endsWith('@usm.cl')

3. Firebase Auth
   └── signInWithEmailAndPassword()

4. Navegación
   └── Navigator.pushAndRemoveUntil(HomeScreen)
      (Limpia el stack de navegación)
```

### Errores Comunes Manejados
- `user-not-found` → "Correo o contraseña incorrectos"
- `wrong-password` → "Correo o contraseña incorrectos"
- `invalid-email` → "El formato del correo es inválido"

---

## 4️⃣ Pantalla Principal (Home)

### Pantalla: `home_screen.dart`

**Estructura Visual:**

```
┌──────────────────────────────────┐
│ AppBar: "Home"            [🚪]   │
├──────────────────────────────────┤
│ [Dropdown: Filtrar por Ramo  ▼] │
│                                  │
│ ┌─────────────────────────────┐ │
│ │  Crear sala                 │ │
│ │  Busca gente para estudiar! │ │
│ └─────────────────────────────┘ │
│                                  │
│ Salas disponibles:               │
│ ┌─────────────────────────────┐ │
│ │ IWI-131: Programación       │ │
│ │ Certamen 1                  │ │
│ │ 👥 3 | Online San Joaquín   │ │
│ └─────────────────────────────┘ │
│                                  │
│ ┌─────────────────────────────┐ │
│ │ MAT-021: Matemáticas I      │ │
│ │ Ejercicios Cap. 3           │ │
│ │ 👥 2 | Presencial Vitacura  │ │
│ └─────────────────────────────┘ │
└──────────────────────────────────┘
│   [🏠]  [🔔]  [👤]              │
└──────────────────────────────────┘
```

**Funcionalidades:**

1. **Filtrado de Salas:**
   - Dropdown muestra ramos que el usuario está cursando
   - Opción "Mostrar Todos" para ver todas las salas
   - Query a Firestore con filtro opcional `where('courseCode', isEqualTo: ramoSeleccionado)`

2. **Botón "Crear Sala":**
   - Navega a `CreateRoomScreen`

3. **Lista de Salas:**
   - StreamBuilder escucha cambios en `study_rooms` collection
   - Actualización en tiempo real
   - Al hacer tap → verifica acceso → abre ChatRoomScreen

### Código de Verificación de Acceso

```dart
// home_screen.dart - _checkAndJoinRoom()
Future<void> _checkAndJoinRoom(...) async {
  // 1. Obtener ramos activos del usuario
  final userRamosDoc = await Firestore
    .doc('artifacts/.../profile_data/data')
    .get();
  
  final userActiveCourses = userRamosDoc['current_ramos'];
  
  // 2. Verificar si el usuario cursa el ramo de la sala
  if (userActiveCourses.contains(roomCourseCode)) {
    // ✅ Puede unirse
    _performJoin();
  } else {
    // ❌ No puede unirse
    showSnackBar("Debes cursar este ramo");
  }
}
```

---

## 5️⃣ Perfil del Usuario

### Pantalla: `profile_screen.dart`

**Flujo de Gestión del Perfil:**

```
1. Carga de datos
   ├── FutureBuilder ejecuta _fetchUserProfile()
   ├── Lee /users/{uid} (carrera, campus)
   └── Lee /artifacts/.../profile_data/data (ramos)

2. Visualización
   ├── Header con email
   ├── Card: Carrera
   ├── Card: Campus
   ├── Botón: "Editar Ramos Actuales"
   └── Lista de ramos cursando

3. Edición de ramos
   └── Navega a RamoSelectionScreen
       └── Filtra ramos por careerId
       └── Usuario selecciona/deselecciona
       └── Guarda automáticamente en Firestore
```

### Ruta de Almacenamiento de Ramos
```
artifacts/{APP_ID}/users/{uid}/profile_data/data
└── current_ramos: ["IWI-131", "MAT-021", "FIS-100"]
```

---

## 6️⃣ Selección de Ramos

### Pantalla: `ramo_selection_screen.dart`

**Interfaz:**

```
┌──────────────────────────────────┐
│ Ramos de Ing. Civil Informática  │
├──────────────────────────────────┤
│ ▼ Año 1                          │
│   □ IWI-131 - Programación       │
│   ☑ MAT-021 - Matemáticas I      │
│   □ FIS-100 - Intro Física       │
│                                  │
│ ▼ Año 2                          │
│   ☑ INF-134 - Estructuras Datos  │
│   □ INF-239 - Bases de Datos     │
└──────────────────────────────────┘
```

**Funcionalidad:**

1. **Agrupación Automática:**
   ```dart
   Map<String, List<Ramo>> _groupRamosByYear(List<Ramo> allRamos) {
     // Agrupa por año y ordena numéricamente
   }
   ```

2. **Toggle de Selección:**
   ```dart
   void _toggleRamoSelection(Ramo ramo) {
     setState(() {
       if (_selectedRamos.contains(ramo.code)) {
         _selectedRamos.remove(ramo.code);  // Deseleccionar
       } else {
         _selectedRamos.add(ramo.code);     // Seleccionar
       }
     });
     _updateRamosInFirestore();  // Guarda inmediatamente
   }
   ```

3. **Guardado Automático:**
   - Cada cambio se guarda instantáneamente en Firestore
   - SnackBar muestra "Guardado automáticamente"
   - Sin botón "Guardar" (UX más fluida)

---

## 7️⃣ Crear Sala de Estudio

### Pantalla: `create_room_screen.dart`

**Formulario:**

```
┌──────────────────────────────────┐
│ Crear Nueva Sala de Estudio      │
├──────────────────────────────────┤
│ Ramo a Estudiar:                 │
│ [Dropdown: IWI-131          ▼]   │
│                                  │
│ Tema Específico:                 │
│ [TextField multiline]            │
│                                  │
│ Campus/Ubicación:                │
│ [Dropdown: San Joaquín      ▼]   │
│                                  │
│ Tipo de Estudio:                 │
│ [Dropdown: Online           ▼]   │
│                                  │
│ Fecha y Hora Programada:         │
│ [📅 19/10/2025]  [🕐 15:30]     │
│                                  │
│      [Crear Sala]                │
└──────────────────────────────────┘
```

**Validaciones:**

1. **Pre-requisito:** Usuario debe tener al menos 1 ramo activo
   - Si no tiene → Pantalla de bloqueo con mensaje

2. **Validación de formulario:**
   - Ramo seleccionado (requerido)
   - Tema (requerido)
   - Campus y Tipo (valores por defecto)

**Creación en Firestore:**

```dart
await _firestore.collection('study_rooms').add({
  'creatorId': user.uid,
  'creatorEmail': user.email,
  'courseCode': _selectedCourseCode,    // "IWI-131"
  'courseName': courseName,              // "Programación"
  'topic': _topic,
  'campus': _campus,
  'type': _type,                         // "Online" o "Presencial"
  'scheduledTime': Timestamp.fromDate(scheduledDateTime),
  'createdAt': FieldValue.serverTimestamp(),
  'members': [user.uid],                 // Creador es primer miembro
  'status': 'active',
});
```

---

## 8️⃣ Chat en Sala de Estudio

### Pantalla: `chat_room_screen.dart`

**Interfaz del Chat:**

```
┌──────────────────────────────────┐
│ IWI-131: Programación             │
├──────────────────────────────────┤
│                                  │
│  ┌─────────────────────┐         │
│  │ María: Hola! ✓      │ 10:30  │
│  └─────────────────────┘         │
│                                  │
│         ┌─────────────────────┐  │
│  10:31  │ Yo: ¿Empezamos?  ✓ │  │
│         └─────────────────────┘  │
│                                  │
│  ┌─────────────────────┐         │
│  │ Juan: Sí! ✓         │ 10:32  │
│  └─────────────────────┘         │
│                                  │
├──────────────────────────────────┤
│ [Escribe tu mensaje...     ] [▶] │
└──────────────────────────────────┘
```

**Funcionamiento del Chat:**

1. **Carga de Mensajes:**
   ```dart
   StreamBuilder<QuerySnapshot>(
     stream: _firestore
       .collection('study_rooms')
       .doc(widget.room.id)
       .collection('messages')
       .orderBy('timestamp', descending: true)
       .snapshots(),
   )
   ```

2. **Envío de Mensaje:**
   ```dart
   await roomMessagesRef.add({
     'text': text,
     'senderId': userId,
     'senderName': _currentUserName,
     'timestamp': FieldValue.serverTimestamp(),
   });
   ```

3. **Estructura de Mensaje:**
   ```json
   {
     "messages/{messageId}": {
       "text": "Hola a todos!",
       "senderId": "abc123",
       "senderName": "María González",
       "timestamp": Timestamp
     }
   }
   ```

4. **Actualización en Tiempo Real:**
   - StreamBuilder reacciona a cada nuevo mensaje
   - ListView con `reverse: true` (mensajes nuevos abajo)
   - Burbujas de diferente color (yo vs otros)

---

## 🔄 Navegación entre Pantallas

### Mapa de Navegación

```
LoginScreen
    │
    ├──[Registrarse]──→ SignupScreen ──[Éxito]──→ HomeScreen
    │
    └──[Login]────────────────────────────────────→ HomeScreen
                                                        │
                ┌───────────────────────────────────────┤
                │                                       │
                ↓                                       ↓
        ProfileScreen                          CreateRoomScreen
                │                                       │
                ├──[Editar Ramos]──→ RamoSelectionScreen
                │                           │
                │                           └──[Guardar]──→ ProfileScreen
                │
                └──[Ver Sala]──→ ChatRoomScreen
```

### Tipos de Navegación Utilizados

1. **Push Simple:**
   ```dart
   Navigator.of(context).push(
     MaterialPageRoute(builder: (context) => NuevaPantalla())
   );
   ```

2. **Push Replace (Login/Signup):**
   ```dart
   Navigator.of(context).pushReplacement(
     MaterialPageRoute(builder: (context) => HomeScreen())
   );
   ```

3. **Push Remove Until (Limpiar stack):**
   ```dart
   Navigator.of(context).pushAndRemoveUntil(
     MaterialPageRoute(builder: (context) => HomeScreen()),
     (Route<dynamic> route) => false,  // Elimina todas las rutas
   );
   ```

---

## 📊 Resumen del Flujo Completo

```
1. Abrir App
   └→ ¿Autenticado? NO → Login/Signup → Crear perfil
                   SÍ ↓

2. Home Screen
   └→ Ver salas filtradas por mis ramos
       │
       ├→ [Crear Sala] → Formulario → Sala creada
       │
       └→ [Unirse a sala] → Verifica ramo → Chat

3. Perfil
   └→ Ver mis datos
       └→ [Editar Ramos] → Selección → Guardado automático

4. Chat
   └→ Mensajes en tiempo real
       └→ Enviar/Recibir mensajes
```

---

**Siguiente:** [Autenticación en Detalle →](03_AUTENTICACION.md)
