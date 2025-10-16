import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  // Dominio de correo de la universidad
  static const String universityDomain = '@usm.cl';

  Future<void> _signIn() async {
    setState(() {
      _errorMessage = null; // Limpiar mensaje de error anterior
    });

    // 1. Validar el formulario y el dominio del correo
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // **Validación USM.cl**
      if (!email.toLowerCase().endsWith(universityDomain)) {
        setState(() {
          _errorMessage =
              'Solo se permiten correos del dominio $universityDomain.';
        });
        return;
      }

      // 2. Intentar iniciar sesión con Firebase
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // 💡 SOLUCIÓN: Verificar si el widget sigue montado antes de usar 'context'
        if (!mounted) return;

        // Si tiene éxito, navega a la siguiente pantalla (e.g., HomeScreen)
        // Reemplaza esto con la navegación real de tu app
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                const PlaceholderScreen(title: "Bienvenido a StudyMatch"),
          ),
        );
      } on FirebaseAuthException catch (e) {
        // 3. Manejar errores de Firebase
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
      } catch (e) {
        setState(() {
          _errorMessage = 'Error desconocido: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bienvenido a StudyMatch',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Usa tu correo institucional $universityDomain',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 48),

                // Campo de Correo
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico (USM)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu correo.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de Contraseña
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu contraseña.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Mensaje de Error
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Botón de Login
                ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                      double.infinity,
                      50,
                    ), // Botón de ancho completo
                  ),
                  child: const Text('Iniciar Sesión'),
                ),

                const SizedBox(height: 16),

                // Opción para registro
                TextButton(
                  onPressed: () {
                    // 💡 CORRECCIÓN: Navegación real a SignupScreen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text('¿No tienes cuenta? Regístrate aquí'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Pantalla temporal para demostrar el éxito
class PlaceholderScreen extends StatefulWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  State<PlaceholderScreen> createState() => _PlaceholderScreenState();

  // 💡 Función auxiliar de navegación
  static void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
// ...

class _PlaceholderScreenState extends State<PlaceholderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
      body: Center(
        child: Column(
          // ...
          children: [
            // ...
            ElevatedButton(
              onPressed: () async {
                // 1. Cierra la sesión
                await FirebaseAuth.instance.signOut();

                // 2. Verifica si el State sigue montado
                if (!mounted) return;

                // 3. Llama a la función auxiliar para navegación
                // Esto satisface al analizador porque la función navigateToLogin
                // no tiene un 'await' interno.
                PlaceholderScreen.navigateToLogin(context);
              },
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
