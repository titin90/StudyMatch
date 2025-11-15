// lib/screens/user_profile.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

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

// --- Screen para mostrar perfil y lógica de reportes ---
class UserProfileScreen extends StatefulWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, dynamic>? _data;
  bool _isLoading = true;
  bool _hasReported = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final doc = await _firestore.collection('users').doc(widget.userId).get();
      setState(() {
        _data = doc.exists ? (doc.data() as Map<String, dynamic>) : null;
      });
      // Check whether current user has previously reported this profile
      final currentUid = _auth.currentUser?.uid;
      if (currentUid != null) {
        try {
          final repDoc = await _firestore
              .collection('users')
              .doc(widget.userId)
              .collection('reports')
              .doc(currentUid)
              .get();
          setState(() => _hasReported = repDoc.exists);
        } catch (_) {
          setState(() => _hasReported = false);
        }
      } else {
        setState(() => _hasReported = false);
      }
    } catch (_) {
      setState(() {
        _data = null;
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de usuario'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: _data == null
                  ? const Center(child: Text('Perfil no encontrado'))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              child: Text(_getInitials(_getName())),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getName(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(_data?['email'] ?? ''),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Text('Información'),
                        const SizedBox(height: 8),
                        Text('Nombre: ${_getName()}'),
                        const SizedBox(height: 6),
                        Text('Email: ${_data?['email'] ?? 'No disponible'}'),
                        const SizedBox(height: 6),
                        Text('Campus: ${_data?['campus'] ?? 'No definido'}'),
                        const SizedBox(height: 18),
                        const Text('Reportes recibidos'),
                        const SizedBox(height: 8),
                        Text(
                          '${(_data?['reportsCount'] as int?) ?? 0} veces',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // If current user has reported this profile, show 'Quitar reporte'
                        if (_hasReported)
                          ElevatedButton(
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Quitar reporte'),
                                  content: const Text(
                                    '¿Quieres quitar tu reporte a este usuario?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(true),
                                      child: const Text(
                                        'Quitar',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm != true) return;

                              final reporterId = _auth.currentUser?.uid;
                              if (reporterId == null) {
                                if (mounted)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Debes iniciar sesión'),
                                    ),
                                  );
                                return;
                              }

                              final userDocRef = _firestore
                                  .collection('users')
                                  .doc(widget.userId);
                              final reportDocRef = userDocRef
                                  .collection('reports')
                                  .doc(reporterId);

                              try {
                                await _firestore.runTransaction((tx) async {
                                  final repSnap = await tx.get(reportDocRef);
                                  final userSnap = await tx.get(userDocRef);

                                  if (!repSnap.exists) return;

                                  final current =
                                      (userSnap.data()?['reportsCount'] ?? 0);
                                  final newCount = current is int && current > 0
                                      ? current - 1
                                      : 0;

                                  tx.delete(reportDocRef);
                                  tx.update(userDocRef, {
                                    'reportsCount': newCount,
                                  });
                                });

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Reporte eliminado'),
                                    ),
                                  );
                                  await _loadProfile();
                                }
                              } catch (e) {
                                if (mounted)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Error al quitar reporte: $e',
                                      ),
                                    ),
                                  );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                            ),
                            child: const Text('Quitar reporte'),
                          )
                        else
                          ElevatedButton(
                            onPressed: _loadProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                            ),
                            child: const Text('Refrescar'),
                          ),
                      ],
                    ),
            ),
    );
  }

  String _getName() {
    if (_data == null) return 'Usuario';
    final possible = <String?>[
      _data?['name'] as String?,
      _data?['displayName'] as String?,
      _data?['fullName'] as String?,
    ];
    for (final p in possible) {
      if (p != null && p.trim().isNotEmpty) return p.trim();
    }
    final email = _data?['email'] as String?;
    if (email != null && email.contains('@')) return email.split('@').first;
    return 'Usuario';
  }

  String _getInitials(String name) {
    final parts = name
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
