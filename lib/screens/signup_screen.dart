import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'home_screen.dart'; // Usaremos HomeScreen como destino final

// -----------------------------------------------------------------------------
// PANTALLA TEMPORAL DE PLACEHOLDER (Redirección post-registro)
// -----------------------------------------------------------------------------
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required final this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "¡Registro Exitoso! 🎉",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Redirigir al usuario al flujo principal de la app (Home/Wrapper)
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text('Ir al Inicio de la App'),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// PANTALLA PRINCIPAL DE REGISTRO (SIGNUP)
// -----------------------------------------------------------------------------
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controladores de campos de texto
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;
  bool _agreedToTerms = false;

  // 🎯 MAPEO Y LISTAS PARA CARRERA Y CAMPUS
  String? _selectedCampus;
  String? _selectedCareer;

  final List<String> _campuses = [
    'Campus Casa Central',
    'Campus San Joaquín',
    'Campus Vitacura',
    'Online',
    'No Definido', // Opción por defecto
  ];

  final List<String> _careers = [
    'Ingeniería Civil Informática',
    'Ingeniería Civil Industrial',
    'Ingeniería Comercial',
    'Arquitectura',
    'Técnico Universitario',
    'Otra / No Especificada', // Opción por defecto
  ];

  // 💡 NUEVO: Mapa para obtener el ID corto de la carrera
  static const Map<String, String> _careerIdMap = {
    'Ingeniería Civil Informática': 'INF',
    'Ingeniería Civil Industrial': 'IND',
    'Ingeniería Comercial': 'COM',
    'Arquitectura': 'ARQ',
    'Técnico Universitario': 'TEC',
    'Otra / No Especificada': 'OTR',
  };
  // -------------------------------------------------

  static const String universityDomain = '@usm.cl';

  // Colores de la app
  static const Color primaryColor = Color(0xFF0560FA);
  static const Color secondaryColor = Color(0xFFEC8000);

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Lógica de registro
  Future<void> _signUp() async {
    setState(() {
      _errorMessage = null;
    });

    if (_formKey.currentState!.validate()) {
      // 🎯 1. VALIDACIÓN DE DROPDOWNS: Deben estar seleccionados
      if (_selectedCampus == null || _selectedCareer == null) {
        setState(() {
          _errorMessage = 'Por favor, selecciona tu Campus y Carrera.';
        });
        return;
      }

      if (!_agreedToTerms) {
        setState(() {
          _errorMessage = 'Debes aceptar los términos y condiciones.';
        });
        return;
      }
      // -------------------------------------------------------

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final name = _fullNameController.text.trim();
      final phone = _phoneController.text.trim();

      // 🎯 Se usan los valores seleccionados del dropdown
      final campus = _selectedCampus!;
      final careerName = _selectedCareer!;

      // 💡 NUEVO: Obtener el ID de la carrera usando el mapa
      final careerId = _careerIdMap[careerName] ?? 'OTR';

      // **Validación USM.cl**
      if (!email.toLowerCase().endsWith(universityDomain)) {
        setState(() {
          _errorMessage =
              'Solo se permiten correos del dominio $universityDomain.';
        });
        return;
      }

      // 2. Intentar crear el usuario con Firebase AUTH
      try {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        final user = userCredential.user;

        // 3. Guardar los datos iniciales en Firestore (Perfil)
        if (user != null) {
          // 💡 OPTIMIZACIÓN: Se inicializa activeCourses como lista vacía (como se sugirió antes)
          List<String> initialCourses = [];

          // 💡 CORRECCIÓN DE CAMPOS: Usamos career_name y career_id
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
                'name': name,
                'phone': phone,
                'email': email,
                'career_name': careerName, // 🎯 Nombre de la carrera
                'career_id': careerId, // 🎯 ID de la carrera (INF, IND, etc.)
                'campus': campus,
                // Inicializamos los ramos activos como lista vacía.
                'activeCourses': initialCourses,
                'profileImageUrl': null,
                'createdAt': FieldValue.serverTimestamp(),
              });

          // 💡 OPTIMIZACIÓN: Se ELIMINA el código de borrado del marcador 'TEMP_INIT'
          // ya que activeCourses se inicializa vacío arriba.
        }

        // 4. Navegar: Ir a la pantalla de éxito
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                const PlaceholderScreen(title: "Registro Exitoso"),
          ),
        );
      } on FirebaseAuthException catch (e) {
        // Manejo de errores de Firebase Auth
        String message;
        if (e.code == 'weak-password') {
          message = 'La contraseña es demasiado débil (mínimo 6 caracteres).';
        } else if (e.code == 'email-already-in-use') {
          message = 'Ya existe una cuenta con este correo.';
        } else {
          message = 'Error al registrar: ${e.message ?? 'Inténtalo de nuevo.'}';
        }
        setState(() {
          _errorMessage = message;
        });
      } catch (e) {
        // Manejo de errores generales
        print('Error al guardar datos en Firestore: $e');
        setState(() {
          _errorMessage = 'Ocurrió un error inesperado al guardar el perfil.';
        });
      }
    }
  }

  // 🎯 WIDGET HELPER para crear el DropdownButtonFormField de forma limpia
  Widget _buildDropdownField({
    required String labelText,
    required String? value,
    required List<String> items,
    required String hintText,
    required void Function(String?) onChanged,
    required IconData icon,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
      hint: Text(hintText),
      value: value,
      isExpanded: true,
      // Validación: el valor no puede ser nulo
      validator: (val) => val == null ? 'Selección obligatoria' : null,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
    );
  }
  // -------------------------------------------------------

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
                    prefixIcon: Icon(Icons.person),
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
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? 'Ingresa tu teléfono' : null,
                ),
                const SizedBox(height: 16),

                // 3. Institutional Email Address (@usm.cl)
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Institutional Email Address (@usm.cl)',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
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
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) => value!.length < 6
                      ? 'La contraseña debe tener al menos 6 caracteres.'
                      : null,
                ),
                const SizedBox(height: 16),

                // 🎯 5. CAMPO CARRERA
                _buildDropdownField(
                  labelText: 'Carrera',
                  value: _selectedCareer,
                  items: _careers,
                  hintText: 'Selecciona tu Carrera',
                  icon: Icons.school,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCareer = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // 🎯 6. CAMPO CAMPUS
                _buildDropdownField(
                  labelText: 'Campus',
                  value: _selectedCampus,
                  items: _campuses,
                  hintText: 'Selecciona tu Campus',
                  icon: Icons.location_city,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCampus = newValue;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Checkbox de Términos y Condiciones
                Row(
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _agreedToTerms = newValue ?? false;
                        });
                      },
                      activeColor: primaryColor,
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
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Mensaje de Error (si existe)
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                        style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
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
