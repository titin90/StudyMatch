# Sistema de Autenticación - StudyMatch

## 🔐 Descripción General

StudyMatch utiliza **Firebase Authentication** para gestionar el registro e inicio de sesión de usuarios. El sistema está diseñado específicamente para instituciones educativas con validación de dominio.

---

## 📝 Registro de Usuarios

### Pantalla: `signup_screen.dart`

### Proceso Completo

```
┌─────────────────────────────────────────┐
│  1. Usuario completa formulario         │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│  2. Validaciones locales                │
│     • Campos requeridos completos       │
│     • Email termina en @usm.cl          │
│     • Contraseña ≥ 6 caracteres         │
│     • Términos aceptados                │
│     • Campus y Carrera seleccionados    │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│  3. Firebase Authentication             │
│     createUserWithEmailAndPassword()    │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│  4. Crear documento en Firestore        │
│     /users/{uid}                        │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│  5. Redireccionar a HomeScreen          │
└─────────────────────────────────────────┘
```

### Código Clave - Validación de Dominio

```dart
// signup_screen.dart - línea ~130
static const String universityDomain = '@usm.cl';

if (!email.toLowerCase().endsWith(universityDomain)) {
  setState(() {
    _errorMessage = 'Solo se permiten correos del dominio $universityDomain.';
  });
  return;
}
```

### Código Clave - Creación de Usuario

```dart
// signup_screen.dart - línea ~138-160
try {
  // 1. Crear usuario en Firebase Auth
  final userCredential = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

  final user = userCredential.user;

  if (user != null) {
    // 2. Guardar perfil en Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
          'name': name,
          'phone': phone,
          'email': email,
          'career_name': careerName,      // "Ingeniería Civil Informática"
          'career_id': careerId,          // "INF"
          'campus': campus,
          'activeCourses': [],            // Lista vacía inicialmente
          'profileImageUrl': null,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }
} on FirebaseAuthException catch (e) {
  // Manejar errores...
}
```

### Campos del Formulario

| Campo                | Tipo       | Validación                    | Requerido |
|----------------------|------------|-------------------------------|-----------|
| Nombre Completo      | TextField  | No vacío                      | ✅        |
| Teléfono             | TextField  | No vacío                      | ✅        |
| Email Institucional  | TextField  | Termina en @usm.cl            | ✅        |
| Contraseña           | TextField  | ≥ 6 caracteres                | ✅        |
| Carrera              | Dropdown   | Selección obligatoria         | ✅        |
| Campus               | Dropdown   | Selección obligatoria         | ✅        |
| Términos             | Checkbox   | Debe estar marcado            | ✅        |

### Carreras Disponibles

```dart
// signup_screen.dart - línea ~61-68
final List<String> _careers = [
  'Ingeniería Civil Informática',
  'Ingeniería Civil Industrial',
  'Ingeniería Comercial',
  'Arquitectura',
  'Técnico Universitario',
  'Otra / No Especificada',
];
```

### Mapeo de IDs de Carrera

```dart
// signup_screen.dart - línea ~71-78
static const Map<String, String> _careerIdMap = {
  'Ingeniería Civil Informática': 'INF',
  'Ingeniería Civil Industrial': 'IND',
  'Ingeniería Comercial': 'COM',
  'Arquitectura': 'ARQ',
  'Técnico Universitario': 'TEC',
  'Otra / No Especificada': 'OTR',
};
```

### Manejo de Errores

```dart
on FirebaseAuthException catch (e) {
  String message;
  if (e.code == 'weak-password') {
    message = 'La contraseña es demasiado débil (mínimo 6 caracteres).';
  } else if (e.code == 'email-already-in-use') {
    message = 'Ya existe una cuenta con este correo.';
  } else {
    message = 'Error al registrar: ${e.message}';
  }
  setState(() {
    _errorMessage = message;
  });
}
```

---

## 🔑 Inicio de Sesión

### Pantalla: `login_screen.dart`

### Proceso de Login

```
┌─────────────────────────────────────────┐
│  1. Usuario ingresa credenciales        │
│     • Email (@usm.cl)                   │
│     • Contraseña                        │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│  2. Validación de dominio @usm.cl       │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│  3. Firebase Auth                       │
│     signInWithEmailAndPassword()        │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│  4. Redirección a HomeScreen            │
│     (Limpia stack de navegación)        │
└─────────────────────────────────────────┘
```

### Código Completo de Login

```dart
// login_screen.dart - línea ~20-67
Future<void> _signIn() async {
  setState(() {
    _errorMessage = null;
  });

  if (_formKey.currentState!.validate()) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validar dominio institucional
    if (!email.toLowerCase().endsWith(universityDomain)) {
      setState(() {
        _errorMessage = 'Solo se permiten correos del dominio $universityDomain.';
      });
      return;
    }

    try {
      // Intentar iniciar sesión
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Redirección exitosa (limpia toda la pila de navegación)
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = 'Correo o contraseña incorrectos.';
      } else if (e.code == 'invalid-email') {
        message = 'El formato del correo es inválido.';
      } else {
        message = 'Ocurrió un error. Inténtalo de nuevo.';
      }
      setState(() {
        _errorMessage = message;
      });
    }
  }
}
```

### Errores Comunes

| Código Error         | Mensaje al Usuario                    | Causa                           |
|----------------------|---------------------------------------|---------------------------------|
| `user-not-found`     | Correo o contraseña incorrectos      | Email no registrado             |
| `wrong-password`     | Correo o contraseña incorrectos      | Contraseña incorrecta           |
| `invalid-email`      | El formato del correo es inválido    | Email mal formado               |
| `too-many-requests`  | Demasiados intentos fallidos         | Límite de intentos excedido     |

---

## 🔄 Persistencia de Sesión

### Automático con Firebase

Firebase Auth **mantiene la sesión automáticamente** entre reinicios de la app:

```dart
// main.dart - línea 26-44
home: StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    // Mientras carga
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Si hay usuario logueado
    if (snapshot.hasData) {
      return const HomeScreen();
    }

    // Si no hay usuario
    return const LoginScreen();
  },
)
```

### Beneficios

✅ **No requiere código adicional** para guardar tokens
✅ **Automático** al reiniciar la app
✅ **Seguro** - tokens manejados por Firebase
✅ **Cross-platform** - funciona en Android, iOS, Web

---

## 🚪 Cerrar Sesión

### Código de Logout

```dart
// home_screen.dart - línea ~190
Widget _buildLogoutAction(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.logout),
    onPressed: () async {
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    },
  );
}
```

### Flujo de Logout

```
Usuario presiona botón [🚪]
    ↓
FirebaseAuth.instance.signOut()
    ↓
authStateChanges() detecta cambio
    ↓
StreamBuilder reconstruye
    ↓
Muestra LoginScreen
```

---

## 🔒 Seguridad Implementada

### 1. Validación de Dominio Institucional

**¿Por qué?** Restringir acceso solo a estudiantes de la UTFSM

```dart
static const String universityDomain = '@usm.cl';

if (!email.toLowerCase().endsWith(universityDomain)) {
  return; // Rechaza el registro/login
}
```

### 2. Validación de Contraseña

**Requisitos mínimos:**
- Longitud mínima: 6 caracteres (Firebase)
- Se recomienda: letras, números y símbolos

```dart
validator: (value) => value!.length < 6
    ? 'La contraseña debe tener al menos 6 caracteres.'
    : null,
```

### 3. Protección de Rutas

Todas las pantallas requieren autenticación (excepto Login/Signup):

```dart
// Ejemplo: HomeScreen
final user = FirebaseAuth.instance.currentUser;
if (user == null) {
  // Redirigir a login o mostrar error
}
```

### 4. Estado de Autenticación Reactivo

El `StreamBuilder` reacciona instantáneamente a cambios:
- Usuario se loguea → Muestra HomeScreen
- Usuario cierra sesión → Muestra LoginScreen
- Token expira → Redirige automáticamente

---

## 📊 Flujo de Datos de Autenticación

```
┌──────────────────────────────────────────────┐
│            FIREBASE AUTHENTICATION           │
│  ┌────────────────────────────────────────┐  │
│  │  User Collection (Authentication)      │  │
│  │  {                                     │  │
│  │    uid: "abc123",                      │  │
│  │    email: "juan@usm.cl",               │  │
│  │    emailVerified: false,               │  │
│  │    createdAt: Timestamp                │  │
│  │  }                                     │  │
│  └────────────────────────────────────────┘  │
└──────────────────────────────────────────────┘
                      ↓
┌──────────────────────────────────────────────┐
│            CLOUD FIRESTORE                   │
│  ┌────────────────────────────────────────┐  │
│  │  users/{uid}                           │  │
│  │  {                                     │  │
│  │    name: "Juan Pérez",                 │  │
│  │    phone: "+56912345678",              │  │
│  │    email: "juan@usm.cl",               │  │
│  │    career_id: "INF",                   │  │
│  │    career_name: "Ing. Civil Inf.",     │  │
│  │    campus: "San Joaquín",              │  │
│  │    activeCourses: [],                  │  │
│  │    profileImageUrl: null,              │  │
│  │    createdAt: Timestamp                │  │
│  │  }                                     │  │
│  └────────────────────────────────────────┘  │
└──────────────────────────────────────────────┘
                      ↓
┌──────────────────────────────────────────────┐
│  artifacts/{APP_ID}/users/{uid}/            │
│    profile_data/data                         │
│  {                                           │
│    current_ramos: ["IWI-131", "MAT-021"]    │
│  }                                           │
└──────────────────────────────────────────────┘
```

### Explicación

1. **Firebase Authentication:** Guarda credenciales (email/password hasheado)
2. **users/{uid}:** Perfil básico del usuario
3. **artifacts/.../profile_data/data:** Ramos que está cursando (Canvas Path)

---

## ⚠️ Limitaciones Actuales

### 1. Verificación de Email
❌ **No implementado** - Los usuarios pueden registrarse sin verificar su email
📝 **Recomendación:** Añadir `user.sendEmailVerification()` después del registro

### 2. Recuperación de Contraseña
❌ **No implementado** - No hay opción "¿Olvidaste tu contraseña?"
📝 **Recomendación:** Añadir botón que llame a `FirebaseAuth.instance.sendPasswordResetEmail()`

### 3. Autenticación de 2 Factores
❌ **No implementado**
📝 **Recomendación:** Considerar para versiones futuras

### 4. Reglas de Firestore
⚠️ **Deben configurarse manualmente** en Firebase Console
📝 **Recomendación:** Ver sección de reglas de seguridad en [Almacenamiento](04_ALMACENAMIENTO.md)

---

## 🔧 Configuración Requerida

### Archivo de Configuración Firebase

**Android:** `android/app/google-services.json`
**iOS:** `ios/Runner/GoogleService-Info.plist`

### Inicialización en el Código

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // ← Crucial
  runApp(const StudyMatchApp());
}
```

---

**Siguiente:** [Almacenamiento de Datos →](04_ALMACENAMIENTO.md)
