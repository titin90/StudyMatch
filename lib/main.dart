import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Se eliminó la importación de 'firebase_options.dart'

// 💡 Importamos las pantallas clave (ajusta las rutas si están en carpetas)
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  // Asegura que Flutter esté inicializado antes de llamar a Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa la conexión con Firebase.
  // NOTA: Para el entorno de Canvas, la inicialización simple es suficiente.
  await Firebase.initializeApp();

  // 🚀 Se eliminó la llamada a 'loadInitialSubjects()' ya que la data de ramos es estática
  // y se accede directamente desde los otros archivos (ramo_selection_screen.dart, etc.).

  runApp(const StudyMatchApp());
}

// Colores de StudyMatch
const Color primaryColor = Color(0xFF0560FA);

class StudyMatchApp extends StatelessWidget {
  const StudyMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyMatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),

      // Decide qué pantalla mostrar.
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            );
          }

          if (snapshot.hasData) {
            return const HomeScreen();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
