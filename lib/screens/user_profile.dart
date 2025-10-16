import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String fullName;
  final String email;
  final String carrera;
  final String campus;
  final List<String> activeCourses;
  final List<String> interests;

  UserProfile({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.carrera,
    required this.campus,
    required this.activeCourses,
    required this.interests,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      fullName: data['fullName'] ?? 'Nombre no disponible',
      email: data['email'] ?? 'correo@usm.cl',
      carrera: data['carrera'] ?? 'No especificada',
      campus: data['campus'] ?? 'No especificado',
      activeCourses: List<String>.from(data['activeCourses'] ?? []),
      interests: List<String>.from(data['interests'] ?? []),
    );
  }
}
