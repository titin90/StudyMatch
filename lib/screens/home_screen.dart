import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Importaciones requeridas
import 'login_screen.dart';
import 'profile_screen.dart';
import 'create_room_screen.dart';
import 'chat_room_screen.dart';

// --- COLORES DE STUDYMATCH ---
const Color primaryColor = Color(0xFF0560FA);
const Color secondaryColor = Color(0xFFEC8000);
const Color textColor = Color(0xFF3A3A3A); // Color de texto oscuro

// --- MODELO DE DATOS DE LA SALA (ROOM) ---
class StudyRoom {
  final String id;
  final String
  courseCode; // Usamos el código del ramo como identificador principal
  final String topic;
  final String
  creatorId; // Cambiado de 'hostId' a 'creatorId' para mayor claridad
  final List<String> members;
  final bool isOnline; // Derivado del campo 'type' en Firestore
  final String campus;

  StudyRoom.fromFirestore(DocumentSnapshot doc)
    : id = doc.id,
      // ✅ CORRECCIÓN 1: courseCode es el valor principal
      courseCode = doc['courseCode'] ?? 'N/A',
      topic = doc['topic'] ?? 'General',
      // ✅ CORRECCIÓN 2: El creador se llama 'creatorId'
      creatorId = doc['creatorId'] ?? '',
      members = List<String>.from(doc['members'] ?? []),
      // ✅ CORRECCIÓN 3: isOnline se basa en el campo 'type' de Firestore
      isOnline = doc['type'] == 'Online',
      campus = doc['campus'] ?? 'Online';

  // Getter para nombre de sala (Usamos el código y el tema como nombre)
  String get name => '$courseCode: $topic';
}

// --- PANTALLA PRINCIPAL (HOMESCREEN) ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyMatch'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,

        // BOTÓN CERRAR SESIÓN (Logout)
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Cierra la sesión de Firebase Auth
              await FirebaseAuth.instance.signOut();

              // Navega de vuelta al Login, eliminando todas las rutas anteriores
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Área de Búsqueda y Creación de Sala
          _buildHeader(context),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Salas disponibles.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Icon(
                  Icons.filter_list,
                  color: textColor,
                ), // Placeholder para Filtros
              ],
            ),
          ),

          // StreamBuilder para la lista de salas en tiempo real
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // Obtener todas las salas y ordenarlas por fecha de creación
              stream: FirebaseFirestore.instance
                  .collection('study_rooms')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error al cargar las salas: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay salas de estudio disponibles. ¡Crea una!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                // Mapear los documentos de Firestore a objetos StudyRoom
                final rooms = snapshot.data!.docs
                    .map((doc) => StudyRoom.fromFirestore(doc))
                    .toList();

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    return _StudyRoomCard(room: rooms[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Navegación inferior
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // Widget para el área de Búsqueda y Creación de Sala
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Campo de búsqueda
          TextField(
            decoration: InputDecoration(
              hintText: 'Encontrar Sala (Ej: MAT-022, Calculo)',
              prefixIcon: Icon(Icons.search, color: primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
          const SizedBox(height: 16),
          // Botón Crear Sala (Estilo tarjeta)
          InkWell(
            onTap: () {
              // Navegar a la pantalla de creación dedicada
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateRoomScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Crear sala',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Busca gente para estudiar o compartir material!',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  Icon(Icons.add_circle, color: secondaryColor, size: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget de barra de navegación inferior
  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notificaciones',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
      currentIndex: 0,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 2) {
          // Navegar a la pantalla de perfil real
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
        // TODO: Agregar navegación para Notificaciones si se implementa
      },
    );
  }
}

// --- WIDGET PARA LA CARD DE SALA (INCLUYE LÓGICA DE UNIRSE) ---
class _StudyRoomCard extends StatelessWidget {
  final StudyRoom room;

  const _StudyRoomCard({required this.room});

  // Función para unirse a la sala
  void _joinRoom(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    if (room.members.contains(userId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ya eres miembro de esta sala.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('study_rooms')
          .doc(room.id)
          .update({
            'members': FieldValue.arrayUnion([userId]),
          });

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Te has unido a la sala ${room.courseCode}!')),
      );

      // TODO: Tras unirse, idealmente navegar al ChatRoomScreen
      // Navegaremos aquí tras implementar la pantalla de chat
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al unirse: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final isMember = room.members.contains(userId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        onTap: () {
          // ✅ IMPLEMENTACIÓN FINAL DE NAVEGACIÓN
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ChatRoomScreen(room: room)),
          );
        },
        leading: Icon(Icons.school, color: primaryColor, size: 30),
        title: Text(
          // Usamos el getter name (Código: Tema)
          room.name,
          style: const TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // Indicador de tipo y ubicación
              '${room.isOnline ? 'Online' : 'Presencial'} en ${room.campus}',
              style: const TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              '${room.members.length} Miembros',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: isMember
            ? const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24,
                semanticLabel: 'Miembro',
              )
            : TextButton(
                onPressed: () => _joinRoom(context),
                child: const Text(
                  'Unirse',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}
