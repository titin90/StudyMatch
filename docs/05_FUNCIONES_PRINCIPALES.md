# Funciones Principales - StudyMatch

## 🎯 Índice de Funciones Clave

1. [Autenticación](#-autenticación)
2. [Gestión de Salas](#-gestión-de-salas)
3. [Chat en Tiempo Real](#-chat-en-tiempo-real)
4. [Selección de Ramos](#-selección-de-ramos)
5. [Validaciones](#-validaciones)
6. [Navegación](#-navegación)

---

## 🔐 Autenticación

### `_signIn()` - Login de Usuario

**Archivo:** `lib/screens/login_screen.dart` (líneas ~97-133)

#### Propósito
Autenticar al usuario con email institucional y contraseña.

#### Flujo de Ejecución

```
┌─────────────────────────────────────┐
│ 1. Usuario ingresa credenciales    │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│ 2. Validar email termina en @usm.cl│
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│ 3. Llamar FirebaseAuth              │
│    signInWithEmailAndPassword()     │
└────────────┬────────────────────────┘
             │
             ├─ Éxito ────────────────┐
             │                        │
             │                        ▼
             │            ┌─────────────────────┐
             │            │ Navegar a HomeScreen│
             │            └─────────────────────┘
             │
             └─ Error ────────────────┐
                                      │
                                      ▼
                         ┌──────────────────────┐
                         │ Mostrar mensaje error│
                         └──────────────────────┘
```

#### Código Comentado

```dart
Future<void> _signIn() async {
  // 1. Validar que los campos no estén vacíos
  if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
    _showMessage('Por favor, completa todos los campos');
    return;
  }

  // 2. Validar dominio institucional
  if (!_emailController.text.endsWith('@usm.cl') &&
      !_emailController.text.endsWith('@sansano.usm.cl')) {
    _showMessage(
        'Debes usar tu correo institucional (@usm.cl o @sansano.usm.cl)');
    return;
  }

  // 3. Cambiar estado de carga
  setState(() {
    _isLoading = true;
  });

  try {
    // 4. Intentar autenticar con Firebase
    await _auth.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    // 5. Si llega aquí, el login fue exitoso
    // El StreamBuilder en main.dart detectará el cambio y navegará automáticamente

  } on FirebaseAuthException catch (e) {
    // 6. Manejar errores específicos de Firebase
    String message = 'Error al iniciar sesión';
    
    switch (e.code) {
      case 'user-not-found':
        message = 'No existe una cuenta con este correo';
        break;
      case 'wrong-password':
        message = 'Contraseña incorrecta';
        break;
      case 'invalid-email':
        message = 'El correo electrónico no es válido';
        break;
      case 'user-disabled':
        message = 'Esta cuenta ha sido deshabilitada';
        break;
      case 'too-many-requests':
        message = 'Demasiados intentos. Intenta más tarde';
        break;
      default:
        message = 'Error: ${e.message}';
    }
    
    _showMessage(message);
  } catch (e) {
    // 7. Manejar otros errores no esperados
    _showMessage('Error inesperado: $e');
  } finally {
    // 8. Desactivar indicador de carga
    setState(() {
      _isLoading = false;
    });
  }
}
```

#### Casos de Prueba

| Input                          | Output Esperado                           |
|--------------------------------|-------------------------------------------|
| Email vacío                    | "Por favor, completa todos los campos"    |
| `juan@gmail.com`               | "Debes usar tu correo institucional..."   |
| `juan.perez@usm.cl` + password | Login exitoso → HomeScreen                |
| Email correcto + pass incorrecta| "Contraseña incorrecta"                   |
| Email no registrado            | "No existe una cuenta con este correo"    |

---

### `_signUp()` - Registro de Usuario

**Archivo:** `lib/screens/signup_screen.dart` (líneas ~135-187)

#### Propósito
Crear una nueva cuenta de usuario con perfil completo en Firestore.

#### Flujo de Ejecución

```
┌────────────────────────────────────┐
│ 1. Validar todos los campos        │
└─────────────┬──────────────────────┘
              │
              ▼
┌────────────────────────────────────┐
│ 2. Crear usuario en Firebase Auth  │
└─────────────┬──────────────────────┘
              │
              ▼
┌────────────────────────────────────┐
│ 3. Crear documento en /users/{uid} │
└─────────────┬──────────────────────┘
              │
              ▼
┌────────────────────────────────────┐
│ 4. Navegar a RamoSelectionScreen   │
└────────────────────────────────────┘
```

#### Código Comentado

```dart
Future<void> _signUp() async {
  // 1. Validar campos requeridos
  if (name.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty ||
      campus == 'Selecciona Campus' || careerName == 'Selecciona Carrera') {
    _showMessage('Por favor, completa todos los campos');
    return;
  }

  // 2. Validar dominio institucional
  if (!email.endsWith('@usm.cl') && !email.endsWith('@sansano.usm.cl')) {
    _showMessage('Debes usar tu correo institucional (@usm.cl o @sansano.usm.cl)');
    return;
  }

  // 3. Validar confirmación de contraseña
  if (password != confirmPassword) {
    _showMessage('Las contraseñas no coinciden');
    return;
  }

  setState(() => _isLoading = true);

  try {
    // 4. PASO 1: Crear usuario en Firebase Authentication
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null) {
      // 5. PASO 2: Crear perfil en Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)  // Usar el UID generado por Auth
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

      // 6. PASO 3: Navegar a selección de ramos
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RamoSelectionScreen(user: user),
          ),
        );
      }
    }
  } on FirebaseAuthException catch (e) {
    // 7. Manejar errores de Firebase
    String message = 'Error al registrar cuenta';
    
    switch (e.code) {
      case 'weak-password':
        message = 'La contraseña es muy débil';
        break;
      case 'email-already-in-use':
        message = 'Ya existe una cuenta con este correo';
        break;
      case 'invalid-email':
        message = 'El correo electrónico no es válido';
        break;
      default:
        message = 'Error: ${e.message}';
    }
    
    _showMessage(message);
  } catch (e) {
    _showMessage('Error inesperado: $e');
  } finally {
    setState(() => _isLoading = false);
  }
}
```

#### Importante: Transacción No Atómica

⚠️ **Punto de mejora:** Si falla el paso de crear el documento en Firestore, el usuario quedará creado en Auth pero sin perfil.

**Solución recomendada:**
```dart
// Usar Cloud Functions para garantizar consistencia
exports.createUserProfile = functions.auth.user().onCreate((user) => {
  return admin.firestore().collection('users').doc(user.uid).set({
    email: user.email,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    // ... otros campos con valores por defecto
  });
});
```

---

## 🏠 Gestión de Salas

### `_checkAndJoinRoom()` - Validar y Unirse a Sala

**Archivo:** `lib/screens/home_screen.dart` (líneas ~120-189)

#### Propósito
Verificar que el usuario esté inscrito en el ramo antes de permitirle unirse a una sala.

#### Flujo de Ejecución

```
┌─────────────────────────────────────┐
│ Usuario hace clic en sala           │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ Obtener courseCode de la sala       │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ Leer ramos activos del usuario      │
│ desde artifacts/.../current_ramos   │
└──────────────┬──────────────────────┘
               │
               ├─ Ramo en lista ─────────┐
               │                         │
               │                         ▼
               │              ┌──────────────────────┐
               │              │ Agregar UID a members│
               │              │ Navegar al chat      │
               │              └──────────────────────┘
               │
               └─ Ramo NO en lista ─────┐
                                        │
                                        ▼
                         ┌──────────────────────────┐
                         │ Mostrar diálogo de error │
                         │ "No estás inscrito..."   │
                         └──────────────────────────┘
```

#### Código Comentado

```dart
Future<void> _checkAndJoinRoom(QueryDocumentSnapshot room) async {
  final currentUser = _auth.currentUser;
  if (currentUser == null) {
    _showMessage('Debes iniciar sesión primero');
    return;
  }

  // 1. Obtener el código del ramo de la sala
  final String courseCode = room['courseCode'];
  final String userId = currentUser.uid;

  try {
    // 2. Construir la ruta al documento de ramos activos
    final ramosDocPath = _getRamosDocPath(userId);
    
    // 3. Leer el documento de Firestore
    final userRamosDoc = await FirebaseFirestore.instance
        .doc(ramosDocPath)
        .get();

    // 4. Extraer la lista de ramos
    final userActiveCourses = 
        (userRamosDoc.data()?['current_ramos'] as List<dynamic>?)
        ?.cast<String>()
        .toList() ?? [];

    // 5. VALIDACIÓN PRINCIPAL: ¿Está inscrito en el ramo?
    if (userActiveCourses.contains(courseCode)) {
      
      // ✅ AUTORIZADO - Agregar a la lista de miembros
      final members = (room['members'] as List<dynamic>?) ?? [];
      
      if (!members.contains(userId)) {
        // Solo actualizar si no está ya en la lista
        await FirebaseFirestore.instance
            .collection('study_rooms')
            .doc(room.id)
            .update({
          'members': FieldValue.arrayUnion([userId]),
        });
      }

      // Navegar al chat
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomScreen(room: room),
          ),
        );
      }
      
    } else {
      // ❌ NO AUTORIZADO - Mostrar mensaje
      _showNotEnrolledDialog(courseCode);
    }
    
  } catch (e) {
    debugPrint('Error al verificar ramos: $e');
    _showMessage('Error al unirse a la sala: $e');
  }
}
```

#### Caso de Uso Real

```
Usuario: Juan Pérez
Ramos activos: ["IWI-131", "MAT-021", "FIS-100"]

Sala A: courseCode = "IWI-131" → ✅ Puede unirse
Sala B: courseCode = "INF-239" → ❌ No puede unirse (no está inscrito)
```

#### Función Auxiliar: Construcción de Ruta

```dart
String _getRamosDocPath(String userId) {
  const appId = String.fromEnvironment(
    'APP_ID',
    defaultValue: 'default-app-id',
  );
  return 'artifacts/$appId/users/$userId/profile_data/data';
}
```

---

### `_createStudyRoom()` - Crear Nueva Sala

**Archivo:** `lib/screens/create_room_screen.dart` (líneas ~71-145)

#### Propósito
Crear una sala de estudio para un ramo específico.

#### Validaciones Pre-Creación

```dart
Future<void> _createStudyRoom() async {
  // 1. Validación: Campos completos
  if (_selectedCourseCode == null ||
      _topic.isEmpty ||
      _campus == 'Selecciona Campus' ||
      _type == 'Selecciona Tipo' ||
      _selectedDate == null ||
      _selectedTime == null) {
    _showMessage('Por favor, completa todos los campos');
    return;
  }

  // 2. Validación: Usuario autenticado
  if (_auth.currentUser == null) {
    _showMessage('Debes iniciar sesión');
    return;
  }

  // 3. Obtener ramos activos del usuario
  final userId = _auth.currentUser!.uid;
  final userRamosDoc = await _firestore
      .doc(_getRamosDocPath(userId))
      .get();

  final userActiveCourses = 
      (userRamosDoc.data()?['current_ramos'] as List<dynamic>?)
      ?.cast<String>()
      .toList() ?? [];

  // 4. Validación: Solo crear salas de ramos propios
  if (!userActiveCourses.contains(_selectedCourseCode)) {
    _showMessage('Solo puedes crear salas de tus ramos activos');
    return;
  }

  // 5. Obtener nombre completo del ramo
  final matchingRamo = allRamos.firstWhere(
    (r) => r.code == _selectedCourseCode,
    orElse: () => const Ramo(
      code: 'UNKNOWN',
      name: 'Ramo Desconocido',
      careerId: 'OTR',
      year: '0',
      semester: 'I',
    ),
  );
  final courseName = matchingRamo.name;

  // 6. Combinar fecha y hora
  final scheduledDateTime = DateTime(
    _selectedDate!.year,
    _selectedDate!.month,
    _selectedDate!.day,
    _selectedTime!.hour,
    _selectedTime!.minute,
  );

  // 7. Validación: No crear salas en el pasado
  if (scheduledDateTime.isBefore(DateTime.now())) {
    _showMessage('La fecha y hora deben ser futuras');
    return;
  }

  setState(() => _isLoading = true);

  try {
    // 8. Crear documento en Firestore
    await _firestore.collection('study_rooms').add({
      'creatorId': userId,
      'creatorEmail': _auth.currentUser!.email,
      'courseCode': _selectedCourseCode,
      'courseName': courseName,
      'topic': _topic,
      'campus': _campus,
      'type': _type,
      'scheduledTime': Timestamp.fromDate(scheduledDateTime),
      'createdAt': FieldValue.serverTimestamp(),
      'members': [userId],  // Creador es el primer miembro
      'status': 'active',
    });

    _showMessage('¡Sala creada exitosamente!');

    // 9. Volver a HomeScreen
    if (mounted) {
      Navigator.pop(context);
    }
    
  } catch (e) {
    _showMessage('Error al crear sala: $e');
  } finally {
    setState(() => _isLoading = false);
  }
}
```

#### Validaciones Implementadas

| Validación                | Tipo      | Mensaje de Error                          |
|---------------------------|-----------|-------------------------------------------|
| Campos vacíos             | Cliente   | "Por favor, completa todos los campos"    |
| Usuario no autenticado    | Cliente   | "Debes iniciar sesión"                    |
| Ramo no en lista activa   | Negocio   | "Solo puedes crear salas de tus ramos..." |
| Fecha/hora en pasado      | Negocio   | "La fecha y hora deben ser futuras"       |

---

## 💬 Chat en Tiempo Real

### `_sendMessage()` - Enviar Mensaje

**Archivo:** `lib/screens/chat_room_screen.dart` (líneas ~53-77)

#### Propósito
Agregar un mensaje a la subcolección de la sala.

#### Código Comentado

```dart
Future<void> _sendMessage() async {
  // 1. Obtener texto del input
  final text = _messageController.text.trim();
  
  // 2. Validar que no esté vacío
  if (text.isEmpty) return;

  // 3. Obtener ID del usuario actual
  final userId = _auth.currentUser?.uid;
  if (userId == null) return;

  try {
    // 4. Construir referencia a la subcolección
    final roomMessagesRef = _firestore
        .collection('study_rooms')
        .doc(widget.room.id)           // ID de la sala
        .collection('messages');        // Subcolección

    // 5. Agregar documento nuevo
    await roomMessagesRef.add({
      'text': text,
      'senderId': userId,
      'senderName': _currentUserName,
      'timestamp': FieldValue.serverTimestamp(),  // Hora del servidor
    });

    // 6. Limpiar campo de texto
    _messageController.clear();
    
  } catch (e) {
    debugPrint('Error al enviar mensaje: $e');
  }
}
```

#### Estructura del Documento Creado

```json
{
  "text": "Hola, ¿a qué hora empezamos?",
  "senderId": "abc123def456",
  "senderName": "Juan Pérez",
  "timestamp": Timestamp(2025, 10, 19, 15, 30, 45)
}
```

#### ¿Por qué `serverTimestamp()`?

✅ **Ventajas:**
- Evita problemas con relojes desincronizados
- Garantiza orden consistente de mensajes
- No depende del dispositivo del usuario

❌ **Alternativa NO recomendada:**
```dart
'timestamp': Timestamp.now()  // ← Usa la hora del dispositivo
```

---

### StreamBuilder para Mensajes

**Archivo:** `lib/screens/chat_room_screen.dart` (líneas ~78-150)

#### Código Completo

```dart
StreamBuilder<QuerySnapshot>(
  // 1. Configurar stream
  stream: _firestore
      .collection('study_rooms')
      .doc(widget.room.id)
      .collection('messages')
      .orderBy('timestamp', descending: true)  // Más recientes primero
      .snapshots(),  // ← Escucha en tiempo real
  
  builder: (context, snapshot) {
    // 2. Manejar estado de carga
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    // 3. Manejar errores
    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }

    // 4. Manejar sin mensajes
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Center(child: Text('No hay mensajes aún'));
    }

    // 5. Extraer lista de documentos
    final messages = snapshot.data!.docs;

    // 6. Construir lista de mensajes
    return ListView.builder(
      reverse: true,  // Scroll empieza abajo
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final data = message.data() as Map<String, dynamic>;

        final text = data['text'] as String;
        final senderId = data['senderId'] as String;
        final senderName = data['senderName'] as String? ?? 'Usuario';
        final timestamp = data['timestamp'] as Timestamp?;

        // Determinar si el mensaje es del usuario actual
        final isMe = senderId == _auth.currentUser?.uid;

        return _buildMessageBubble(
          text: text,
          senderName: senderName,
          timestamp: timestamp,
          isMe: isMe,
        );
      },
    );
  },
)
```

#### Casos de Estado

```
ConnectionState.waiting
    ↓
┌─────────────────────┐
│ CircularProgressBar │
└─────────────────────┘

snapshot.hasError
    ↓
┌─────────────────────┐
│ "Error: ..."        │
└─────────────────────┘

snapshot.data.docs.isEmpty
    ↓
┌─────────────────────┐
│ "No hay mensajes"   │
└─────────────────────┘

snapshot.hasData
    ↓
┌─────────────────────┐
│ ListView de mensajes│
└─────────────────────┘
```

---

## 📚 Selección de Ramos

### `_toggleRamoSelection()` - Seleccionar/Deseleccionar Ramo

**Archivo:** `lib/screens/ramo_selection_screen.dart` (líneas ~40-48)

#### Propósito
Agregar o quitar un ramo de la lista de activos, con guardado automático.

#### Código Comentado

```dart
void _toggleRamoSelection(String ramoCode) {
  setState(() {
    // 1. Verificar si ya está seleccionado
    if (_selectedRamos.contains(ramoCode)) {
      // Ya está → Quitar
      _selectedRamos.remove(ramoCode);
    } else {
      // No está → Agregar
      _selectedRamos.add(ramoCode);
    }
  });

  // 2. Guardar cambios automáticamente en Firestore
  _updateRamosInFirestore();
}
```

#### `_updateRamosInFirestore()` - Guardar en Firestore

```dart
Future<void> _updateRamosInFirestore() async {
  final user = widget.user;

  // 1. Construir ruta al documento
  final docPath = _getProfileDocPath(user.uid);

  // 2. Convertir Set a List
  final List<String> ramosToSave = _selectedRamos.toList();

  try {
    // 3. Actualizar documento con merge
    await FirebaseFirestore.instance.doc(docPath).set({
      'current_ramos': ramosToSave,
    }, SetOptions(merge: true));  // ← merge: true preserva otros campos

    debugPrint('Ramos actualizados en Firestore: $ramosToSave');
    
  } catch (e) {
    debugPrint('Error al actualizar ramos: $e');
  }
}
```

#### ¿Por qué `Set<String>`?

```dart
final Set<String> _selectedRamos = {};  // ← No permite duplicados
```

✅ **Ventajas:**
- Garantiza que cada ramo esté solo una vez
- Operaciones `contains()` y `remove()` son O(1)
- Automáticamente elimina duplicados

---

### `_groupRamosByYear()` - Agrupar Ramos por Año

**Archivo:** `lib/screens/ramo_selection_screen.dart` (líneas ~73-92)

#### Propósito
Organizar los ramos en secciones por año para mejor UI.

#### Código Comentado

```dart
Map<String, List<Ramo>> _groupRamosByYear(List<Ramo> ramos) {
  // 1. Crear mapa vacío
  final Map<String, List<Ramo>> grouped = {};

  // 2. Iterar por cada ramo
  for (final ramo in ramos) {
    final year = ramo.year;  // "1", "2", "3", etc.

    // 3. Si el año no existe en el mapa, crear lista vacía
    if (!grouped.containsKey(year)) {
      grouped[year] = [];
    }

    // 4. Agregar ramo a su lista correspondiente
    grouped[year]!.add(ramo);
  }

  // 5. Ordenar las listas por código de ramo
  grouped.forEach((key, value) {
    value.sort((a, b) => a.code.compareTo(b.code));
  });

  return grouped;
}
```

#### Ejemplo de Salida

```dart
Input:
[
  Ramo("IWI-131", "Programación", year: "1"),
  Ramo("MAT-021", "Cálculo 1", year: "1"),
  Ramo("FIS-100", "Física 1", year: "2"),
]

Output:
{
  "1": [
    Ramo("IWI-131", ...),
    Ramo("MAT-021", ...),
  ],
  "2": [
    Ramo("FIS-100", ...),
  ]
}
```

#### Uso en la UI

```dart
ListView(
  children: grouped.entries.map((entry) {
    final year = entry.key;
    final ramos = entry.value;
    
    return Column(
      children: [
        // Encabezado de año
        Text('Año $year'),
        
        // Lista de ramos
        ...ramos.map((ramo) => CheckboxListTile(...)),
      ],
    );
  }).toList(),
)
```

---

## ✅ Validaciones

### Validación de Email Institucional

**Usado en:** `login_screen.dart`, `signup_screen.dart`

```dart
bool _isValidInstitutionalEmail(String email) {
  return email.endsWith('@usm.cl') || 
         email.endsWith('@sansano.usm.cl');
}
```

#### Casos de Prueba

| Email                       | ¿Válido? |
|-----------------------------|----------|
| `juan.perez@usm.cl`         | ✅       |
| `maria.gonzalez@sansano.usm.cl` | ✅   |
| `juan@gmail.com`            | ❌       |
| `juan@usm.com`              | ❌       |
| `juan@usm.cl.fake.com`      | ❌       |

---

### Validación de Fecha Futura

**Usado en:** `create_room_screen.dart`

```dart
bool _isFutureDateTime(DateTime scheduledTime) {
  return scheduledTime.isAfter(DateTime.now());
}
```

---

## 🧭 Navegación

### Patrón de Navegación Principal

```
main.dart (StreamBuilder)
    │
    ├─ Usuario NO autenticado ──→ LoginScreen
    │                                  │
    │                                  ├─ Registro exitoso ──→ SignupScreen ──→ RamoSelectionScreen ──→ HomeScreen
    │                                  └─ Login exitoso ────→ HomeScreen
    │
    └─ Usuario autenticado ──────────→ HomeScreen
                                          │
                                          ├─ Ver perfil ──────→ ProfileScreen
                                          ├─ Seleccionar ramos ─→ RamoSelectionScreen
                                          ├─ Crear sala ─────→ CreateRoomScreen
                                          └─ Unirse a sala ──→ ChatRoomScreen
```

### Código de Navegación en `main.dart`

```dart
StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      User? user = snapshot.data;
      
      if (user == null) {
        // No autenticado → Login
        return const LoginScreen();
      } else {
        // Autenticado → Home
        return const HomeScreen();
      }
    }
    
    // Cargando
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  },
)
```

### Navegación con Reemplazo

```dart
// Usado en signup exitoso
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => RamoSelectionScreen(user: user)),
);
```

**Diferencias:**

| Método            | Stack después de navegar | Botón "Atrás" |
|-------------------|--------------------------|---------------|
| `push()`          | [A, B]                   | Vuelve a A    |
| `pushReplacement()`| [B]                     | Sale de la app|

---

## 🔄 Funciones Auxiliares

### Formateo de Fecha/Hora

```dart
String _formatTime(Timestamp? timestamp) {
  if (timestamp == null) return '';
  
  final date = timestamp.toDate();
  return DateFormat('HH:mm').format(date);  // "15:30"
}

String _formatDate(Timestamp? timestamp) {
  if (timestamp == null) return 'Sin fecha';
  
  final date = timestamp.toDate();
  return DateFormat('dd/MM/yyyy').format(date);  // "19/10/2025"
}
```

### Mostrar Mensajes al Usuario

```dart
void _showMessage(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
    ),
  );
}
```

### Diálogos Personalizados

```dart
void _showNotEnrolledDialog(String courseCode) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('No inscrito en el ramo'),
      content: Text(
        'Debes estar inscrito en $courseCode para unirte a esta sala.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Entendido'),
        ),
      ],
    ),
  );
}
```

---

## 📊 Resumen de Complejidad

| Función                  | Complejidad Temporal | Operaciones Firebase |
|--------------------------|----------------------|----------------------|
| `_signIn()`              | O(1)                 | 1 read (Auth)        |
| `_signUp()`              | O(1)                 | 1 write (Auth + Firestore) |
| `_checkAndJoinRoom()`    | O(1)                 | 2 reads + 1 write    |
| `_createStudyRoom()`     | O(1)                 | 1 read + 1 write     |
| `_sendMessage()`         | O(1)                 | 1 write              |
| `_toggleRamoSelection()` | O(1)                 | 1 write              |
| `_groupRamosByYear()`    | O(n log n)           | 0 (local)            |

---

**Siguiente:** [Estado Actual del Proyecto →](06_ESTADO_ACTUAL.md)
