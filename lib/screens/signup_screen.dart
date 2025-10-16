import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart'; // Para navegar de vuelta

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;
  bool _agreedToTerms = false;

  static const String universityDomain = '@usm.cl';

  // Colores de StudyMatch
  static const Color primaryColor = Color(0xFF0560FA);
  static const Color secondaryColor = Color(0xFFEC8000);

  Future<void> _signUp() async {
    setState(() {
      _errorMessage = null;
    });

    if (_formKey.currentState!.validate()) {
      if (!_agreedToTerms) {
        setState(() {
          _errorMessage = 'Debes aceptar los términos y condiciones.';
        });
        return;
      }

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final fullName = _fullNameController.text.trim();
      final phone = _phoneController.text.trim();

      // **Validación USM.cl**
      if (!email.toLowerCase().endsWith(universityDomain)) {
        setState(() {
          _errorMessage =
              'Solo se permiten correos del dominio $universityDomain.';
        });
        return;
      }

      // 1. Intentar crear el usuario con Firebase AUTH
      try {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        final user = userCredential.user;

        // 2. Si es exitoso, GUARDAR los datos iniciales en Firestore (Perfil)
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
                'fullName': fullName,
                'phone': phone,
                'email': email,
                'carrera':
                    'No especificado', // Inicial para el perfil académico
                'campus': 'No especificado', // Inicial para el perfil académico
                'activeCourses': [], // Inicial para los ramos activos
                'profilePictureUrl': '',
                'createdAt': FieldValue.serverTimestamp(),
              });
        }

        // 3. Navegar: Ir a la pantalla de perfil (o al home)
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          // La pantalla de perfil será manejada por main.dart, pero aquí navegamos a un placeholder
          MaterialPageRoute(
            builder: (context) =>
                const PlaceholderScreen(title: "Registro Exitoso"),
          ),
        );
      } on FirebaseAuthException catch (e) {
        // 4. Manejar errores de Firebase
        String message;
        if (e.code == 'weak-password') {
          message = 'La contraseña es demasiado débil (mínimo 6 caracteres).';
        } else if (e.code == 'email-already-in-use') {
          message = 'Ya existe una cuenta con este correo.';
        } else {
          message = 'Error al registrar. Inténtalo de nuevo.';
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
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create an account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Complete the sign up process to get started',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 48),

                // 1. Full Name
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Ingresa tu nombre completo' : null,
                ),
                const SizedBox(height: 16),

                // 2. Phone Number
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? 'Ingresa tu teléfono' : null,
                ),
                const SizedBox(height: 16),

                // 3. Institutional Email Address (USM)
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Institutional Email Address (@usm.cl)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    // 💡 CORRECCIÓN: Se añaden las llaves al primer 'if'
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu correo institucional.';
                    }
                    if (!value.toLowerCase().endsWith(universityDomain)) {
                      return 'Debe ser un correo con el dominio $universityDomain.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 4. Password
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) => value!.length < 6
                      ? 'La contraseña debe tener al menos 6 caracteres.'
                      : null,
                ),
                const SizedBox(height: 16),

                // Checkbox de Términos
                Row(
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _agreedToTerms = newValue ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _agreedToTerms = !_agreedToTerms;
                          });
                        },
                        child: Text(
                          'By ticking this box, you agree to our Terms and conditions and private policy',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    ),
                  ],
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

                // Botón de Sign Up
                ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
                ),

                const SizedBox(height: 16),

                // Opción para Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        // Navega a la pantalla de Login
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: secondaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
