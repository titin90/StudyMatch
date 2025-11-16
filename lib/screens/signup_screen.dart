import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/colors.dart';
import 'login_screen.dart';
import 'home_screen.dart';

// Pantalla de redirección post-registro
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "¡Registro Exitoso!",
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

// Pantalla principal de registro
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
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _selectedUniversity;
  String? _selectedCampus;
  String? _selectedCareer;

  // Configuración de universidades con sus carreras
  final Map<String, Map<String, dynamic>> _universities = {
    'Universidad Técnica Federico Santa María': {
      'domain': '@usm.cl',
      'campuses': [
        'Campus Casa Central - Valparaíso',
        'Campus San Joaquín - Santiago',
        'Campus Vitacura - Santiago',
        'Campus Concepción',
      ],
      'careers': {
        'Ingeniería Civil Informática': 'USM-CIV-INF',
        'Ingeniería Civil Industrial': 'USM-CIV-IND',
        'Ingeniería Civil Eléctrica': 'USM-CIV-ELE',
        'Ingeniería Civil Mecánica': 'USM-CIV-MEC',
      },
    },
    'Pontificia Universidad Católica de Chile': {
      'domain': '@uc.cl',
      'campuses': [
        'Campus San Joaquín',
        'Campus Casa Central',
        'Campus Oriente',
        'Campus Villarrica',
        'Campus Lo Contador',
      ],
      'careers': {
        'Licenciatura en Ingeniería en Ciencia de la Computación': 'UC-CC',
        'Ingeniería Civil': 'UC-CIV',
        'Medicina': 'UC-MED',
        'Derecho': 'UC-DER',
      },
    },
    'Universidad de Chile': {
      'domain': '@uchile.cl',
      'campuses': [
        'Campus Beauchef',
        'Campus Juan Gómez Millas',
        'Campus Andrés Bello',
        'Campus Norte',
        'Campus Sur',
      ],
      'careers': {
        'Ingeniería Civil Informática': 'UCHILE-CIV-INF',
        'Ingeniería Civil Industrial': 'UCHILE-CIV-IND',
        'Ingeniería Comercial': 'UCHILE-COM',
        'Medicina': 'UCHILE-MED',
      },
    },
    'Universidad de Santiago de Chile': {
      'domain': '@usach.cl',
      'campuses': [
        'Campus Central',
        'Campus Estación Central',
      ],
      'careers': {
        'Ingeniería Civil Informática': 'USACH-CIV-INF',
        'Ingeniería Civil Industrial': 'USACH-CIV-IND',
        'Ingeniería Comercial': 'USACH-COM',
        'Ingeniería Civil En Minas': 'USACH-CIV-MIN',
      },
    },
  };

  List<String> get _availableCampuses {
    if (_selectedUniversity == null) return [];
    return _universities[_selectedUniversity]!['campuses'] as List<String>;
  }

  List<String> get _availableCareers {
    if (_selectedUniversity == null) return [];
    final careers = _universities[_selectedUniversity]!['careers'] as Map<String, String>;
    return careers.keys.toList();
  }

  String get _universityDomain {
    if (_selectedUniversity == null) return '@universidad.cl';
    return _universities[_selectedUniversity]!['domain'] as String;
  }

  String _getCareerIdForUniversity(String careerName) {
    if (_selectedUniversity == null) return 'OTR';
    final careers = _universities[_selectedUniversity]!['careers'] as Map<String, String>;
    return careers[careerName] ?? 'OTR';
  }

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
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      if (_selectedUniversity == null || _selectedCampus == null || _selectedCareer == null) {
        setState(() {
          _errorMessage = 'Por favor, completa todos los campos de selección.';
          _isLoading = false;
        });
        return;
      }

      if (!_agreedToTerms) {
        setState(() {
          _errorMessage = 'Debes aceptar los términos y condiciones.';
          _isLoading = false;
        });
        return;
      }

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final name = _fullNameController.text.trim();
      final phone = _phoneController.text.trim();
      final university = _selectedUniversity!;
      final campus = _selectedCampus!;
      final careerName = _selectedCareer!;
      final careerId = _getCareerIdForUniversity(careerName);
      final domain = _universityDomain;

      if (!email.toLowerCase().endsWith(domain)) {
        setState(() {
          _errorMessage =
              'El correo debe ser del dominio $domain de tu universidad.';
          _isLoading = false;
        });
        return;
      }

      try {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        final user = userCredential.user;

        if (user != null) {
          // Enviar correo de verificación
          await user.sendEmailVerification();

          List<String> initialCourses = [];

          // Guardar datos del usuario en Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
                'name': name,
                'phone': phone,
                'email': email,
                'university': university,
                'career_name': careerName,
                'career_id': careerId,
                'campus': campus,
                'activeCourses': initialCourses,
                'profileImageUrl': null,
                'emailVerified': false,
                'createdAt': FieldValue.serverTimestamp(),
              });

          // Cerrar sesión temporalmente hasta que verifique el correo
          await FirebaseAuth.instance.signOut();
        }

        if (!mounted) return;
        
        // Mostrar diálogo de confirmación
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Verifica tu correo'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.mail_outline,
                      size: 64,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Hemos enviado un correo de verificación a:\n\n$email',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Por favor, revisa:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Bandeja de entrada\n'
                      '• Carpeta de SPAM/Correo no deseado\n'
                      '• Carpeta de Promociones',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text('Ir a Iniciar Sesión'),
                ),
              ],
            );
          },
        );
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'weak-password') {
          message = 'La contraseña es demasiado débil (mínimo 6 caracteres).';
        } else if (e.code == 'email-already-in-use') {
          // Mostrar diálogo con opciones cuando el correo ya existe
          if (!mounted) return;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Correo ya registrado'),
                content: const Text(
                  'Ya existe una cuenta con este correo electrónico.\n\n¿Qué deseas hacer?'
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      // Enviar correo de recuperación
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: _emailController.text.trim(),
                        );
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Correo de recuperación enviado. Revisa tu bandeja.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error al enviar correo de recuperación.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text('Recuperar Contraseña'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    child: const Text('Iniciar Sesión'),
                  ),
                ],
              );
            },
          );
          setState(() {
            _isLoading = false;
          });
          return;
        } else {
          message = 'Error al registrar: ${e.message ?? 'Inténtalo de nuevo.'}';
        }
        setState(() {
          _errorMessage = message;
          _isLoading = false;
        });
      } catch (e) {
        print('Error al guardar datos en Firestore: $e');
        setState(() {
          _errorMessage = 'Ocurrió un error inesperado al guardar el perfil.';
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Widget helper para crear dropdowns
  Widget _buildDropdownField({
    required String labelText,
    required String? value,
    required List<String> items,
    required String hintText,
    required void Function(String?)? onChanged,
    required IconData icon,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: onChanged == null ? Colors.grey[200] : Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
      hint: Text(hintText),
      value: value,
      isExpanded: true,
      validator: (val) => val == null ? 'Selección obligatoria' : null,
      onChanged: onChanged,
      items: items.isEmpty 
          ? null
          : items.map<DropdownMenuItem<String>>((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
    );
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
                  'Información Académica',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Universidad
                _buildDropdownField(
                  labelText: 'Universidad',
                  value: _selectedUniversity,
                  items: _universities.keys.toList(),
                  hintText: 'Selecciona tu Universidad',
                  icon: Icons.school_outlined,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedUniversity = newValue;
                      _selectedCampus = null; // Reset campus when university changes
                      _selectedCareer = null; // Reset career when university changes
                      _emailController.clear(); // Clear email when university changes
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Campus
                _buildDropdownField(
                  labelText: 'Campus',
                  value: _selectedCampus,
                  items: _availableCampuses,
                  hintText: _selectedUniversity == null 
                      ? 'Primero selecciona una universidad'
                      : 'Selecciona tu Campus',
                  icon: Icons.location_city,
                  onChanged: _selectedUniversity == null 
                      ? null 
                      : (String? newValue) {
                          setState(() {
                            _selectedCampus = newValue;
                          });
                        },
                ),
                const SizedBox(height: 16),

                // Carrera
                _buildDropdownField(
                  labelText: 'Carrera',
                  value: _selectedCareer,
                  items: _availableCareers,
                  hintText: _selectedUniversity == null
                      ? 'Primero selecciona una universidad'
                      : 'Selecciona tu Carrera',
                  icon: Icons.book_outlined,
                  onChanged: _selectedUniversity == null
                      ? null
                      : (String? newValue) {
                          setState(() {
                            _selectedCareer = newValue;
                          });
                        },
                ),
                const SizedBox(height: 24),

                const Text(
                  'Información Personal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Full Name
                TextFormField(
                  controller: _fullNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Nombre Completo',
                    hintText: 'Ej: Juan Pérez González',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu nombre completo';
                    }
                    if (value.trim().split(' ').length < 2) {
                      return 'Ingresa tu nombre y apellido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Number
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    hintText: 'Ej: +56912345678',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[50],
                    helperText: 'Incluye código de país (Ej: +569)',
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu teléfono';
                    }
                    if (value.length < 9) {
                      return 'Ingresa un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Institutional Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico Institucional',
                    hintText: _selectedUniversity != null 
                        ? 'usuario$_universityDomain'
                        : 'Selecciona primero tu universidad',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[50],
                    helperText: _selectedUniversity != null
                        ? 'Tu correo debe terminar en $_universityDomain'
                        : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  enabled: _selectedUniversity != null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu correo institucional';
                    }
                    if (_selectedUniversity != null && 
                        !value.toLowerCase().endsWith(_universityDomain)) {
                      return 'Debe terminar en $_universityDomain';
                    }
                    if (!value.contains('@')) {
                      return 'Formato de correo inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    hintText: 'Mínimo 6 caracteres',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa una contraseña';
                    }
                    if (value.length < 6) {
                      return 'Mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Checkbox de términos
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
                          'Al marcar esta casilla, aceptas nuestros Términos y condiciones y la política de privacidad',
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

                // Mensaje de error
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

                // Botón Sign Up
                ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Registrarse', style: TextStyle(fontSize: 18)),
                ),

                const SizedBox(height: 16),

                // Opción para Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Ya tienes una cuenta?'),
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
                        'Iniciar Sesión',
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
