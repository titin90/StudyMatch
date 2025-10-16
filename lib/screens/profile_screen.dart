// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // ✅ CAMBIO: Importar image_picker
import 'package:firebase_storage/firebase_storage.dart'; // ✅ CAMBIO: Importar firebase_storage
import 'dart:io'; // ✅ CAMBIO: Para File

// Importa la pantalla de login para la navegación
import 'login_screen.dart';

// --- COLORES DE STUDYMATCH ---
const Color primaryColor = Color(0xFF0560FA);
const Color secondaryColor = Color(0xFFEC8000);
const Color textColor = Color(0xFF3A3A3A);

// Modelo de datos para el usuario
class UserProfile {
  final String email;
  final String name;
  final String campus;
  final String career;
  final String?
  profileImageUrl; // ✅ CAMBIO: Nuevo campo para la URL de la imagen

  UserProfile({
    required this.email,
    required this.name,
    required this.campus,
    required this.career,
    this.profileImageUrl, // ✅ CAMBIO: Hacerlo opcional
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return UserProfile(
      email: data?['email'] ?? 'N/A',
      name: data?['name'] ?? 'Usuario sin Nombre',
      campus: data?['campus'] ?? 'No Definido',
      career: data?['career'] ?? 'No Definido',
      profileImageUrl: data?['profileImageUrl'], // ✅ CAMBIO: Mapear la URL
    );
  }
}

// --- PANTALLA DE PERFIL ---
class ProfileScreen extends StatefulWidget {
  // ✅ CAMBIO: Ahora es StatefulWidget
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ✅ CAMBIO: Nuevo State
  final ImagePicker _picker =
      ImagePicker(); // ✅ CAMBIO: Instancia de ImagePicker
  final FirebaseStorage _storage =
      FirebaseStorage.instance; // ✅ CAMBIO: Instancia de FirebaseStorage

  // Función para obtener los datos del usuario (Auth y Firestore)
  Future<UserProfile> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("Usuario no autenticado.");
    }

    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (docSnapshot.exists) {
      return UserProfile.fromFirestore(docSnapshot);
    } else {
      return UserProfile(
        email: user.email ?? 'Email Desconocido',
        name: user.displayName ?? 'Usuario Temporal',
        campus: 'No Definido',
        career: 'No Definido',
        profileImageUrl:
            null, // ✅ CAMBIO: Sin imagen si no hay perfil en Firestore
      );
    }
  }

  // ✅ CAMBIO: Nueva función para seleccionar y subir imagen
  Future<void> _pickAndUploadImage() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes iniciar sesión para cambiar tu foto.'),
        ),
      );
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          // Opcional: Mostrar un indicador de carga
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Subiendo imagen...')));
        });

        // 1. Subir la imagen a Firebase Storage
        File file = File(image.path);
        Reference storageRef = _storage
            .ref()
            .child('profile_pictures')
            .child('${user.uid}.jpg');
        UploadTask uploadTask = storageRef.putFile(file);

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // 2. Guardar la URL de descarga en Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'profileImageUrl': downloadUrl});

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto de perfil actualizada con éxito!'),
            ),
          );
          // 3. Reconstruir la UI para mostrar la nueva imagen
          setState(() {});
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al subir imagen: $e')));
      }
      print('Error al subir imagen: $e'); // Para depuración
    }
  }

  // Función para cerrar sesión
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil Académico'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<UserProfile>(
        future: _fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar el perfil: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No se encontraron datos de perfil.'),
            );
          }

          final userProfile = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Sección de Avatar y Nombre ---
                Center(
                  child: Column(
                    children: [
                      // ✅ CAMBIO: Widget para mostrar la foto de perfil
                      InkWell(
                        // Hace el avatar clickeable
                        onTap: _pickAndUploadImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: primaryColor,
                          backgroundImage: userProfile.profileImageUrl != null
                              ? NetworkImage(userProfile.profileImageUrl!)
                              : null, // Usa la imagen de red si existe
                          child: userProfile.profileImageUrl == null
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                )
                              : null, // Muestra el icono solo si no hay imagen
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userProfile.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        userProfile.email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                const Divider(),
                const SizedBox(height: 10),

                // --- Información Académica ---
                _buildInfoCard(
                  icon: Icons.school,
                  title: 'Carrera',
                  value: userProfile.career,
                ),
                _buildInfoCard(
                  icon: Icons.location_city,
                  title: 'Campus',
                  value: userProfile.campus,
                ),

                const SizedBox(height: 40),

                // --- Botón Cerrar Sesión ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Cerrar Sesión',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget auxiliar para mostrar la información en formato de lista
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryColor, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
