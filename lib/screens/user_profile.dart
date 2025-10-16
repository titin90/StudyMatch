// lib/screens/user_profile.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  // Asegúrate de incluir todos los campos que guardas en Firestore
  final String uid;
  final String name;
  final String email;
  final String
  phone; // Incluido en el registro pero faltaba en el modelo del chat
  final String career;
  final String campus;
  final List<String> activeCourses;
  final String? profileImageUrl;
  // Añadir más campos si los tienes (ej: interests, createdAt)

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.career,
    required this.campus,
    required this.activeCourses,
    this.profileImageUrl,
  });

  // Constructor para crear el objeto desde un DocumentSnapshot de Firestore
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    // Se asume que el documento siempre tendrá estos campos gracias al SignupScreen
    return UserProfile(
      uid: doc.id,
      name: data?['name'] ?? 'Usuario sin Nombre',
      email: data?['email'] ?? 'correo@usm.cl',
      phone: data?['phone'] ?? 'N/A',
      career: data?['career'] ?? 'No Definido',
      campus: data?['campus'] ?? 'No Definido',
      // Es crucial manejar la lista como List<String>
      activeCourses: List<String>.from(data?['activeCourses'] ?? []),
      profileImageUrl: data?['profileImageUrl'] as String?,
    );
  }
}
