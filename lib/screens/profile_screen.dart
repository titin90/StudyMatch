import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Importaciones requeridas
import '../ramo_selection_screen.dart';
import '../ramo_data.dart'; // Lista consolidada de ramos
import 'login_screen.dart'; // Para redirigir al cerrar sesión

// Colores definidos para consistencia
const Color primaryColor = Color(0xFF0560FA);
const Color secondaryColor = Color(0xFFEC8000);
// Usamos un gris más suave para la información secundaria
const Color grayColor = Color(0xFFA7A7A7);
const Color textColor = Color(0xFF3A3A3A);

// Modelo de datos para el perfil del usuario (sin cambios lógicos)
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
      // Leemos de /users/{uid} o usamos fallback
      careerId: data['career_id'] ?? 'INF',
      careerName: data['career_name'] ?? 'Ingeniería Civil Informática',
      campus: data['campus'] ?? 'No Definido',
      // Leemos de la ruta Canvas Path para los ramos
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
    // Busca en la lista CONSOLIDADA de todos los ramos
    return allRamos.where((ramo) => codes.contains(ramo.code)).toList();
  }

  // 💡 FUNCIÓN COMBINADA para obtener el perfil completo (lo que antes era FutureBuilder)
  Future<UserProfile> _fetchUserProfile() async {
    final user = _auth.currentUser!;

    // 1. Obtener datos del documento raíz (/users/{uid})
    final rootDoc = await _firestore.collection('users').doc(user.uid).get();
    final rootData = rootDoc.data() ?? {};

    // 2. Obtener datos de ramos del documento anidado (Canvas Path)
    final ramosDocPath = _getRamosDocPath(user.uid);
    final ramosDoc = await _firestore.doc(ramosDocPath).get();
    final ramosData = ramosDoc.data() ?? {};

    // Mapeo de datos (combinando la información)
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

    // 💡 IMPORTANTE: Usamos FutureBuilder para el cuerpo, eliminando el Scaffold original
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
              // 💡 Header simplificado
              _buildHeader(userProfile.email),
              const SizedBox(height: 25),

              // 💡 SOLO CARDS DE INFORMACIÓN CLAVE (Carrera y Campus)
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

              // Botón para editar los ramos
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RamoSelectionScreen(
                          careerId: userProfile.careerId,
                          careerName: userProfile.careerName,
                          initialRamos: userProfile.currentRamos,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 20),
                  label: const Text(
                    'Editar Ramos Actuales',
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

              // 💡 Lista de Ramos (Diseño Simplificado)
              Text(
                'Ramos Cursando (${userProfile.currentRamos.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
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

              // 💡 Nuevo diseño para la lista de ramos
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
                            child: Text(
                              '${ramo.code} - ${ramo.name}',
                              style: const TextStyle(
                                fontSize: 15,
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
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

  // 💡 WIDGET AUXILIAR: Encabezado simplificado
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
                  'Mi Perfil Académico', // Título principal para el contenido
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

  // 💡 WIDGET AUXILIAR: Card de información
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
          dense: true, // Hace la tarjeta más compacta
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
