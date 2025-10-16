import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Importaciones requeridas
import 'login_screen.dart';
import 'profile_screen.dart';
import 'create_room_screen.dart';
import 'chat_room_screen.dart'; // Asegúrate de que esta importación sea correcta

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
      courseCode = doc['courseCode'] ?? 'N/A',
      topic = doc['topic'] ?? 'General',
      creatorId = doc['creatorId'] ?? '',
      members = List<String>.from(doc['members'] ?? []),
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
                    color: primaryColor,
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
                      style: TextStyle(color: primaryColor),
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
              prefixIcon: const Icon(Icons.search, color: primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
                color: secondaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
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
                  ),
                  Icon(Icons.add_circle, color: Colors.white, size: 30),
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

// --- WIDGET PARA LA CARD DE SALA (LÓGICA UNIFICADA DE ACCESO) ---
class _StudyRoomCard extends StatelessWidget {
  final StudyRoom room;

  const _StudyRoomCard({required this.room});

  // 💡 NUEVA FUNCIÓN: Unirse y Navegar al mismo tiempo
  void _handleRoomAction(BuildContext context, bool isMember) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // Si NO es miembro, primero intentamos unirnos
    if (!isMember) {
      try {
        await FirebaseFirestore.instance
            .collection('study_rooms')
            .doc(room.id)
            .update({
              'members': FieldValue.arrayUnion([userId]),
            });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('¡Te has unido a la sala ${room.courseCode}!'),
            ),
          );
        }
      } catch (e) {
        // Manejar el error de permiso o de conexión
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al unirse. Verifica tus reglas de seguridad: $e',
            ),
          ),
        );
        return; // Detener la navegación si la unión falla
      }
    }

    // Navegar a la sala de chat (Esto ocurre si ya era miembro o si se unió exitosamente)
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ChatRoomScreen(room: room)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final isMember = room.members.contains(userId);

    // Determina el comportamiento al tocar la tarjeta:
    // 1. Si NO es miembro, el onTap de la tarjeta no hace nada.
    // 2. Si ES miembro, el onTap navega directamente.
    final Function()? cardOnTap = isMember
        ? () => _handleRoomAction(context, true)
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: primaryColor,
      child: ListTile(
        onTap: cardOnTap, // Navegación solo si ya es miembro
        leading: const Icon(Icons.school, color: Colors.white, size: 30),
        title: Text(
          room.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${room.isOnline ? 'Online' : 'Presencial'} en ${room.campus}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              '${room.members.length} Miembros',
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
        // 💡 LÓGICA DEL BOTÓN DERECHO
        trailing: isMember
            ? const Icon(
                Icons.check_circle,
                color: Colors.green, // Icono de éxito para miembros
                size: 24,
                semanticLabel: 'Miembro',
              )
            : TextButton(
                // Si NO es miembro, el botón llama a la acción completa (Unirse + Navegar)
                onPressed: () => _handleRoomAction(context, false),
                child: const Text(
                  'Unirse',
                  style: TextStyle(
                    color: secondaryColor, // Color secundario para el botón
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}
