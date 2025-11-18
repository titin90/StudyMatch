import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/colors.dart';
import '../ramo_data.dart';
import 'explore_ramos_screen.dart';

// Modelo de datos para el perfil del usuario
class UserProfile {
  final String uid;
  final String email;
  final String careerId;
  final String careerName;
  final String campus;
  final List<String> currentRamos;

  UserProfile({
    required this.uid,
    required this.email,
    required this.careerId,
    required this.careerName,
    required this.campus,
    required this.currentRamos,
  });

  factory UserProfile.fromFirestore(
    String uid,
    String email,
    Map<String, dynamic> data,
  ) {
    return UserProfile(
      uid: uid,
      email: email,
      careerId: data['career_id'] ?? 'INF',
      careerName: data['career_name'] ?? 'Ingeniería Civil Informática',
      campus: data['campus'] ?? 'No Definido',
      currentRamos:
          (data['current_ramos'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String _getRamosDocPath(String uid) {
    const appId = String.fromEnvironment(
      'APP_ID',
      defaultValue: 'default-app-id',
    );
    return 'artifacts/$appId/users/$uid/profile_data/data';
  }

  List<Ramo> _getRamoDetails(List<String> codes) {
    return allRamos.where((ramo) => codes.contains(ramo.code)).toList();
  }

  // Obtiene el perfil completo del usuario
  Future<UserProfile> _fetchUserProfile() async {
    final user = _auth.currentUser!;

    final rootDoc = await _firestore.collection('users').doc(user.uid).get();
    final rootData = rootDoc.data() ?? {};

    final ramosDocPath = _getRamosDocPath(user.uid);
    final ramosDoc = await _firestore.doc(ramosDocPath).get();
    final ramosData = ramosDoc.data() ?? {};

    return UserProfile(
      uid: user.uid,
      email: user.email ?? 'N/A',
      careerId: rootData['career_id'] ?? 'INF',
      careerName: rootData['career_name'] ?? 'Ingeniería Civil Informática',
      campus: rootData['campus'] ?? 'No Definido',
      currentRamos:
          (ramosData['current_ramos'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text(
          'Error: No hay usuario autenticado.',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return FutureBuilder<UserProfile>(
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
              'Error al cargar perfil: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final userProfile = snapshot.data!;
        final selectedRamoDetails = _getRamoDetails(userProfile.currentRamos);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(userProfile.email),
              const SizedBox(height: 25),

              _buildInfoCard(
                'Carrera',
                userProfile.careerName,
                Icons.engineering,
                primaryColor,
              ),
              _buildInfoCard(
                'Campus',
                userProfile.campus,
                Icons.location_city,
                primaryColor,
              ),
              const SizedBox(height: 30),

              // Único botón para explorar ramos (incluye mi carrera)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ExploreRamosScreen(
                          userCareerId: userProfile.careerId,
                          userCareerName: userProfile.careerName,
                        ),
                      ),
                    );
                    setState(() {});
                  },
                  icon: const Icon(Icons.school, size: 20),
                  label: const Text(
                    'Explorar Ramos',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Encabezado de ramos con botón de editar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ramos Inscritos (${userProfile.currentRamos.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  if (userProfile.currentRamos.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        _showEditRamosDialog(context, selectedRamoDetails, userProfile.uid);
                      },
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Editar'),
                      style: TextButton.styleFrom(
                        foregroundColor: primaryColor,
                      ),
                    ),
                ],
              ),
              const Divider(color: grayColor, height: 15),

              if (selectedRamoDetails.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Aún no has seleccionado ningún ramo.',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: grayColor,
                    ),
                  ),
                ),

              ...selectedRamoDetails
                  .map(
                    (ramo) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ramo.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${ramo.code} • ${ramo.universityId}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  // Diálogo para editar y eliminar ramos inscritos
  void _showEditRamosDialog(BuildContext context, List<Ramo> ramos, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.edit, color: primaryColor),
                  const SizedBox(width: 8),
                  const Text('Editar ramos inscritos'),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ramos.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('No tienes ramos inscritos'),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: ramos.length,
                        itemBuilder: (context, index) {
                          final ramo = ramos[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: primaryColor,
                                child: Text(
                                  ramo.universityId,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                ramo.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${ramo.code} • ${ramo.universityId} • ${ramo.credits} créditos',
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  // Confirmar eliminación
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Confirmar'),
                                      content: Text('¿Eliminar "${ramo.name}"?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, false),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, true),
                                          child: const Text(
                                            'Eliminar',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    // Eliminar ramo
                                    await _deleteRamo(userId, ramo.code);
                                    // Actualizar lista
                                    ramos.removeAt(index);
                                    setDialogState(() {});
                                    // Refrescar vista principal
                                    if (mounted) setState(() {});
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteRamo(String userId, String ramoCode) async {
    try {
      final ramosDocPath = _getRamosDocPath(userId);
      final ramosDoc = await _firestore.doc(ramosDocPath).get();
      final ramosData = ramosDoc.data();
      
      final currentRamos = (ramosData?['current_ramos'] as List<dynamic>?)
              ?.cast<String>()
              .toList() ??
          [];
      
      currentRamos.remove(ramoCode);
      
      await _firestore.doc(ramosDocPath).set({
        'current_ramos': currentRamos,
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ramo eliminado'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Encabezado del perfil
  Widget _buildHeader(String email) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35, // Tamaño más pequeño
            backgroundColor: primaryColor,
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mi Perfil Académico',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  'Bienvenido, ${email}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card de información
  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        margin: EdgeInsets.zero,
        child: ListTile(
          dense: true,
          leading: Icon(icon, color: iconColor, size: 20),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          trailing: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
