# Overview - StudyMatch

## 🎯 Objetivo del Proyecto

**StudyMatch** es una aplicación móvil diseñada para conectar estudiantes de la Universidad Técnica Federico Santa María (UTFSM) que desean formar grupos de estudio. La app permite a los estudiantes:

- Crear salas de estudio para ramos específicos
- Unirse a salas de otros estudiantes
- Chatear en tiempo real con los miembros de la sala
- Organizar sesiones de estudio presenciales u online

## 🏗️ Arquitectura General

### Stack Tecnológico

```
┌─────────────────────────────────────┐
│         FRONTEND (Flutter)          │
│  - UI/UX con Material Design        │
│  - Gestión de estado con StatefulW. │
│  - Navegación entre pantallas       │
└─────────────────┬───────────────────┘
                  │
                  ↓
┌─────────────────────────────────────┐
│      SERVICIOS FIREBASE             │
│  ┌─────────────────────────────┐   │
│  │  Firebase Authentication    │   │
│  │  - Email/Password           │   │
│  │  - Validación @usm.cl       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Cloud Firestore            │   │
│  │  - Perfiles usuarios        │   │
│  │  - Salas de estudio         │   │
│  │  - Mensajes de chat         │   │
│  │  - Tiempo real              │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

### Patrón de Arquitectura

La aplicación sigue un patrón **MVC simplificado** adaptado para Flutter:

- **Model:** Clases de datos (`Ramo`, `UserProfile`, `StudyRoom`, `ChatMessage`)
- **View:** Widgets de Flutter (Screens)
- **Controller:** Lógica de negocio dentro de los StatefulWidgets + Firebase

## 📦 Estructura de Paquetes

```dart
lib/
│
├── main.dart                    // Punto de entrada, inicialización Firebase
│
├── ramo_data.dart              // Modelo de datos + Mallas curriculares
│
├── ramo_selection_screen.dart  // Pantalla de selección de ramos
│
└── screens/
    ├── login_screen.dart       // Autenticación: Login
    ├── signup_screen.dart      // Autenticación: Registro
    ├── home_screen.dart        // Hub principal (salas disponibles)
    ├── profile_screen.dart     // Perfil y configuración del usuario
    ├── create_room_screen.dart // Formulario para crear salas
    ├── chat_room_screen.dart   // Chat en tiempo real de una sala
    └── user_profile.dart       // Modelo de datos del perfil
```

## 🎨 Paleta de Colores

```dart
primaryColor    = #0560FA  (Azul principal)
secondaryColor  = #EC8000  (Naranja de acento)
textColor       = #3A3A3A  (Gris oscuro para texto)
grayColor       = #A7A7A7  (Gris para info secundaria)
```

## 🔑 Conceptos Clave

### 1. **Autenticación Institucional**
- Solo se permiten correos con dominio `@usm.cl`
- Sistema de autenticación basado en Firebase Auth
- Sesión persistente automática

### 2. **Ramos Curriculares**
- Datos estáticos definidos en `ramo_data.dart`
- Organizados por carrera (INF, IND, COM, ARQ, etc.)
- Agrupados por año y semestre

### 3. **Salas de Estudio**
- Cualquier usuario puede crear una sala
- Las salas están asociadas a un ramo específico
- Solo estudiantes que cursan ese ramo pueden unirse
- Incluyen chat en tiempo real

### 4. **Validación de Acceso**
- El sistema verifica que el usuario esté cursando el ramo antes de permitir el acceso a la sala
- Se evita el acceso no autorizado o irrelevante

## 📊 Flujo de Datos

```
Usuario → Firebase Auth → Sesión Activa
                            ↓
                    Home Screen (Carga salas)
                            ↓
            Firestore consulta 'study_rooms'
                            ↓
                    Muestra salas filtradas
                            ↓
        Usuario selecciona sala → Valida ramo
                            ↓
                Si está cursando → Acceso Chat
                Si no está cursando → Mensaje error
```

## 🔐 Seguridad

### Nivel de Aplicación
- Validación de dominio de correo institucional
- Verificación de ramos antes de unirse a salas
- Sesiones manejadas por Firebase

### Nivel de Firebase
- Reglas de seguridad en Firestore (deben configurarse)
- Autenticación requerida para todas las operaciones
- Solo usuarios autenticados pueden leer/escribir

## 📱 Plataformas Soportadas

Actualmente el proyecto está configurado para:
- ✅ Android
- ✅ iOS
- ⚠️ Web (requiere configuración adicional de Firebase)
- ❌ Desktop (no configurado)

## 🚀 Inicialización

### Proceso de Inicio
1. `main()` inicializa Flutter bindings
2. Se inicializa Firebase con `Firebase.initializeApp()`
3. Se ejecuta `StudyMatchApp` (widget raíz)
4. `StreamBuilder` escucha cambios de autenticación
5. Si hay usuario → `HomeScreen`
6. Si no hay usuario → `LoginScreen`

---

**Siguiente:** [Flujo de la Aplicación →](02_FLUJO_APLICACION.md)
