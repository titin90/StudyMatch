# StudyMatch - Documentación del Proyecto

## 📋 Índice de Documentación

Esta carpeta contiene toda la documentación técnica del proyecto StudyMatch, una aplicación móvil para conectar estudiantes universitarios que desean formar grupos de estudio.

### Documentos Disponibles

1. **[01_OVERVIEW.md](01_OVERVIEW.md)** - Vista general del proyecto y arquitectura
2. **[02_FLUJO_APLICACION.md](02_FLUJO_APLICACION.md)** - Flujo completo de navegación y uso
3. **[03_AUTENTICACION.md](03_AUTENTICACION.md)** - Sistema de login y registro
4. **[04_ALMACENAMIENTO.md](04_ALMACENAMIENTO.md)** - Estructura de datos local y en la nube
5. **[05_FUNCIONES_PRINCIPALES.md](05_FUNCIONES_PRINCIPALES.md)** - Explicación de funciones clave
6. **[06_ESTADO_ACTUAL.md](06_ESTADO_ACTUAL.md)** - Funcionalidades implementadas y pendientes

## 🚀 Inicio Rápido

### Tecnologías Principales
- **Framework:** Flutter 3.9.2
- **Lenguaje:** Dart
- **Backend:** Firebase (Auth + Firestore)
- **Arquitectura:** Stateful Widgets con Firebase Real-time

### Estructura del Proyecto
```
studyapp/
├── lib/
│   ├── main.dart                      # Punto de entrada
│   ├── ramo_data.dart                 # Datos de mallas curriculares
│   ├── ramo_selection_screen.dart     # Selección de ramos
│   └── screens/
│       ├── login_screen.dart          # Pantalla de login
│       ├── signup_screen.dart         # Pantalla de registro
│       ├── home_screen.dart           # Pantalla principal
│       ├── profile_screen.dart        # Perfil del usuario
│       ├── create_room_screen.dart    # Crear sala de estudio
│       └── chat_room_screen.dart      # Chat de sala
└── docs/                              # Esta documentación
```

## 📱 Características Principales

### ✅ Implementado
- Autenticación con Firebase Auth (email/password)
- Gestión de perfiles de usuario
- Selección de ramos por carrera
- Creación de salas de estudio
- Chat en tiempo real
- Filtrado de salas por ramo
- Validación de acceso a salas por ramo cursado

### 🔨 En Desarrollo
- Notificaciones push
- Búsqueda avanzada de salas
- Sistema de valoraciones
- Compartir archivos en el chat

## 🔗 Enlaces Útiles

- [Flujo Completo de la App](02_FLUJO_APLICACION.md)
- [Cómo Funciona Firebase](04_ALMACENAMIENTO.md)
- [Estado Actual del Proyecto](06_ESTADO_ACTUAL.md)

---

**Última actualización:** Octubre 2025
