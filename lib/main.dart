import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 💡 Importamos las dos pantallas clave.
import 'screens/login_screen.dart'; // Ajusta la ruta si están dentro de 'screens/'
import 'screens/home_screen.dart'; // Ajusta la ruta si están dentro de 'screens/'

void main() async {
  // Asegura que Flutter esté inicializado antes de llamar a Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa la conexión con Firebase sin opciones explícitas.
  // Esto funcionará si has configurado 'google-services.json' manualmente en Android.
  await Firebase.initializeApp();
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
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de debug
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),

      // 🚀 PUNTO CLAVE: Decide qué pantalla mostrar.
      home: StreamBuilder<User?>(
        // Escucha si hay algún cambio en el usuario (login, logout, registro)
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 1. Mostrar carga mientras Firebase verifica el estado inicial.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            );
          }

          // 2. Si snapshot.hasData es true, hay un usuario logueado.
          if (snapshot.hasData) {
            // ✅ SOLUCIÓN: Vamos directo a HomeScreen sin wrappers.
            return const HomeScreen();
          }

          // 3. Si no hay usuario logueado, pide iniciar sesión o registrarse.
          return const LoginScreen();
        },
      ),
    );
  }
}
