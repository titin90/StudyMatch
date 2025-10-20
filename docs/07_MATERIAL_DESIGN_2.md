#  Material Design 2 en StudyMatch


## 1. Estructura y Navegación

- **Scaffold**
  - Presente en: Todas las pantallas principales (`main.dart`, `screens/login_screen.dart`, `screens/home_screen.dart`, `screens/signup_screen.dart`, `screens/profile_screen.dart`, `screens/create_room_screen.dart`, `screens/chat_room_screen.dart`, `ramo_selection_screen.dart`)
  - Uso: Estructura base de cada pantalla, incluye AppBar, body, floatingActionButton, etc.

- **AppBar**
  - Presente en: Todas las pantallas principales mencionadas arriba.
  - Uso: Barra superior con título y acciones.

- **BottomNavigationBar**
  - Presente en: `screens/home_screen.dart`
  - Uso: Navegación entre secciones principales (Home, Perfil, etc.).

- **MaterialPageRoute**
  - Presente en: `screens/login_screen.dart`, `screens/signup_screen.dart`, `screens/home_screen.dart`, `screens/profile_screen.dart`
  - Uso: Navegación entre pantallas.

---

## 2. Interacción y Feedback

- **SnackBar**
  - Presente en: `ramo_selection_screen.dart`, `screens/home_screen.dart`, `screens/create_room_screen.dart`
  - Uso: Mensajes de notificación al usuario (éxito, error, advertencias).

- **FloatingActionButton**
  - Presente en: `screens/chat_room_screen.dart`, `screens/home_screen.dart`
  - Uso: Botón flotante para acciones principales (crear sala, enviar mensaje, etc.).

---

## 3. Formularios y Entradas

- **TextField / TextFormField**
  - Presente en: `screens/login_screen.dart`, `screens/signup_screen.dart`, `screens/chat_room_screen.dart`
  - Uso: Entrada de texto para login, registro, mensajes, etc.

- **DropdownButton / DropdownButtonFormField**
  - Presente en: `screens/signup_screen.dart`, `screens/home_screen.dart`
  - Uso: Selección de opciones (carreras, ramos, etc.).

- **Checkbox**
  - Presente en: `screens/signup_screen.dart`
  - Uso: Aceptar términos y condiciones.

---

## 4. Botones

- **ElevatedButton**
  - Presente en: `screens/login_screen.dart`, `screens/signup_screen.dart`, `screens/profile_screen.dart`
  - Uso: Botones principales para acciones (iniciar sesión, registrarse, guardar cambios, etc.).

- **TextButton**
  - Presente en: `screens/login_screen.dart`, `screens/signup_screen.dart`
  - Uso: Acciones secundarias (ir a registro, volver, etc.).

---

## 5. Listas y Tarjetas

- **Card**
  - Presente en: `ramo_selection_screen.dart`, `screens/profile_screen.dart`
  - Uso: Mostrar información agrupada (perfil, ramos, etc.).

- **ListTile**
  - Presente en: `ramo_selection_screen.dart`, `screens/profile_screen.dart`
  - Uso: Elementos de lista con íconos y texto.

- **ExpansionTile**
  - Presente en: `ramo_selection_screen.dart`
  - Uso: Mostrar información expandible (detalle de ramos, etc.).

---

## 6. Otros componentes

- **PopupMenuButton, Stepper, Chip, Dialog, BottomSheet, Drawer**
  - No se detectan en el código actual, pero son parte de MD2 y pueden agregarse si se requieren más funcionalidades.

---

