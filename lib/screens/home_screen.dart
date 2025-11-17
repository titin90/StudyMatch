import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/colors.dart';
import '../ramo_data.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'create_room_screen.dart';
import 'chat_room_screen.dart';

// Ruta de perfil para verificar ramos
String _getRamosDocPath(String uid) {
  const appId = String.fromEnvironment(
    'APP_ID',
    defaultValue: 'default-app-id',
  );
  return 'artifacts/$appId/users/$uid/profile_data/data';
}

// Modelo de datos de la sala
class StudyRoom {
  final String id;
  final String courseCode;
  final String topic;
  final String creatorId;
  final List<String> members;
  final bool isOnline;
  final String campus;
  final int? capacity;
  final String? description;
  final Map<String, dynamic> rawData;

  StudyRoom.fromFirestore(DocumentSnapshot doc)
    : id = doc.id,
      courseCode = doc['courseCode'] ?? 'N/A',
      topic = doc['topic'] ?? 'General',
      creatorId = doc['creatorId'] ?? '',
      members = List<String>.from(doc['members'] ?? []),
      isOnline = doc['type'] == 'Online',
      campus = doc['campus'] ?? 'Online',
      // parse capacity if present
      capacity =
          doc.data() != null &&
              (doc.data() as Map<String, dynamic>)['capacity'] != null
          ? int.tryParse(
              ((doc.data() as Map<String, dynamic>)['capacity']).toString(),
            )
          : null,
      description =
          doc.data() != null &&
              (doc.data() as Map<String, dynamic>)['description'] != null
          ? ((doc.data() as Map<String, dynamic>)['description']).toString()
          : null,
      rawData = doc.data() as Map<String, dynamic>;

  String get name => '$courseCode: $topic';
}

// Ejecuta la lógica de unión a la sala
Future<void> _performJoin(
  BuildContext context,
  String userId,
  String roomId,
  Map<String, dynamic> roomData,
) async {
  if (roomData['members'] != null &&
      (roomData['members'] as List).contains(userId)) {
    if (context.mounted) {
      final room = StudyRoom.fromFirestore(
        await FirebaseFirestore.instance
            .collection('study_rooms')
            .doc(roomId)
            .get(),
      );
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ChatRoomScreen(room: room)),
      );
    }
    return;
  }
  try {
    // Re-fetch room document to get current members and capacity
    final roomDoc = await FirebaseFirestore.instance
        .collection('study_rooms')
        .doc(roomId)
        .get();
    final currentMembers = List<String>.from(roomDoc.data()?['members'] ?? []);
    final capacity = roomDoc.data()?['capacity'];
    if (capacity != null &&
        capacity is int &&
        currentMembers.length >= capacity) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La sala está llena. No puedes unirte.'),
          ),
        );
      }
      return;
    }
  } catch (e) {
    // ignore and continue to attempt join; Firestore rules may block later
  }
  try {
    await FirebaseFirestore.instance
        .collection('study_rooms')
        .doc(roomId)
        .update({
          'members': FieldValue.arrayUnion([userId]),
        });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Te uniste a la sala con éxito!')),
      );
      final room = StudyRoom.fromFirestore(
        await FirebaseFirestore.instance
            .collection('study_rooms')
            .doc(roomId)
            .get(),
      );
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ChatRoomScreen(room: room)),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al unirse a la sala: $e')));
    }
  }
}

// Verifica la membresía del ramo antes de unirse
Future<void> _checkAndJoinRoom(
  BuildContext context,
  Map<String, dynamic> roomData,
  String roomId,
) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para unirte.')),
      );
    }
    return;
  }

  final roomCourseCode = roomData['courseCode'] as String? ?? 'N/A';

  if (roomCourseCode == 'N/A' || roomCourseCode.isEmpty) {
    _performJoin(context, user.uid, roomId, roomData);
    return;
  }

  try {
    final ramosDocPath = _getRamosDocPath(user.uid);
    final userRamosDoc = await FirebaseFirestore.instance
        .doc(ramosDocPath)
        .get();
    final userActiveCourses =
        (userRamosDoc.data()?['current_ramos'] as List<dynamic>?)
            ?.cast<String>()
            .toList() ??
        [];

    if (userActiveCourses.contains(roomCourseCode)) {
      _performJoin(context, user.uid, roomId, roomData);
    } else {
      if (context.mounted) {
        final courseName = roomData['courseName'] ?? roomCourseCode;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No puedes unirte. Debes cursar "$courseName" ($roomCourseCode) para entrar a esta sala.',
            ),
            backgroundColor: secondaryColor,
          ),
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al verificar el perfil: $e')),
      );
    }
  }
}

// Pantalla principal
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions = <Widget>[
    _HomeContent(
      onCreateRoomTapped: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CreateRoomScreen()),
        );
      },
    ),
    const Center(child: Text('Pantalla de Notificaciones (Próximamente)')),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildLogoutAction(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        if (!context.mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = 'StudyMatch';
    if (_selectedIndex == 2) {
      title = 'Mi Perfil';
    } else if (_selectedIndex == 1) {
      title = 'Notificaciones';
    } else if (_selectedIndex == 0) {
      title = 'StudyMatch';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [if (_selectedIndex == 2) _buildLogoutAction(context)],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateRoomScreen(),
                  ),
                );
              },
              backgroundColor: secondaryColor,
              child: const Icon(Icons.add),
              tooltip: 'Crear sala',
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'StudyMatch'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }
}

// Widget de contenido de la pestaña Home
class _HomeContent extends StatefulWidget {
  final VoidCallback onCreateRoomTapped;

  const _HomeContent({required this.onCreateRoomTapped});

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  List<String> _userActiveCourses = [];
  String? _selectedFilterRamo;
  String _filterMode = 'my_courses'; // 'my_courses', 'recommended', 'all'
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActiveCourses();
  }

  // Obtiene el nombre del ramo desde su código
  String _getRamoDisplayName(String code) {
    if (code == 'Mostrar Todos') return code;
    final ramo = allRamos.firstWhere(
      (r) => r.code == code,
      orElse: () => Ramo(
        code: code,
        name: code,
        universityId: '',
        careerId: '',
        year: '',
        semester: '',
      ),
    );
    return '${ramo.code} - ${ramo.name}';
  }

  // Carga los ramos activos del usuario para usarlos como filtro
  Future<void> _loadActiveCourses() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      final ramosDocPath = _getRamosDocPath(userId);
      final ramosDoc = await _firestore.doc(ramosDocPath).get();
      final ramosData = ramosDoc.data();

      if (mounted) {
        setState(() {
          _userActiveCourses =
              (ramosData?['current_ramos'] as List<dynamic>?)
                  ?.cast<String>()
                  .toList() ??
              [];
          _userActiveCourses.insert(0, 'Mostrar Todos');
          _selectedFilterRamo = _userActiveCourses.first;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _userActiveCourses.insert(0, 'Mostrar Todos');
          _selectedFilterRamo = 'Mostrar Todos';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }

    // Lógica para construir el Query de Firestore
    Query roomsQuery = FirebaseFirestore.instance.collection('study_rooms');

    // Filtros según el modo seleccionado
    if (_filterMode == 'my_courses' && _userActiveCourses.isNotEmpty) {
      // Mostrar solo salas de mis ramos
      final ramosFiltrados = _userActiveCourses
          .where((r) => r != 'Mostrar Todos')
          .toList();

      if (_selectedFilterRamo != null &&
          _selectedFilterRamo != 'Mostrar Todos') {
        roomsQuery = roomsQuery.where(
          'courseCode',
          isEqualTo: _selectedFilterRamo,
        );
      } else if (ramosFiltrados.isNotEmpty) {
        roomsQuery = roomsQuery.where('courseCode', whereIn: ramosFiltrados);
      }
    }
    // Si el modo es 'all', no aplicamos filtro (muestra todas las salas)

    return Column(
      children: [
        _buildHeader(context),

        // Chips de filtro
        _buildFilterChips(),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Salas disponibles',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              Icon(Icons.filter_list, color: textColor),
            ],
          ),
        ),

        // StreamBuilder para la lista de salas filtrada
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: roomsQuery.snapshots(),
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
                String mensaje;

                if (_filterMode == 'all') {
                  mensaje =
                      'No hay salas disponibles en este momento.\n¡Sé el primero en crear una!';
                } else if (_userActiveCourses.isEmpty) {
                  mensaje =
                      'No tienes ramos inscritos.\nInscribe tus ramos en tu perfil para ver salas recomendadas.';
                } else if (_selectedFilterRamo == 'Mostrar Todos') {
                  mensaje =
                      'No hay salas disponibles para tus ramos.\n¡Crea una!';
                } else {
                  mensaje =
                      'No hay salas para el ramo "$_selectedFilterRamo".\n¡Crea una!';
                }

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          mensaje,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

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
    );
  }

  // Chips de filtro rápido
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: Text(
              'Mis Ramos${_userActiveCourses.isEmpty ? " (0)" : " (${_userActiveCourses.length})"}',
            ),
            selected: _filterMode == 'my_courses',
            onSelected: _userActiveCourses.isEmpty
                ? null
                : (selected) {
                    setState(() {
                      _filterMode = 'my_courses';
                      _selectedFilterRamo = 'Mostrar Todos';
                    });
                  },
            selectedColor: Colors.green[100],
            checkmarkColor: Colors.green,
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Todas las Salas'),
            selected: _filterMode == 'all',
            onSelected: (selected) {
              setState(() {
                _filterMode = 'all';
                _selectedFilterRamo = null;
              });
            },
            selectedColor: Colors.blue[100],
            checkmarkColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  // Dropdown de Filtro y botón de crear sala
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedFilterRamo,
                hint: const Text('Filtrar por Ramo'),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFilterRamo = newValue;
                  });
                },
                items: _userActiveCourses.map<DropdownMenuItem<String>>((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value == 'Mostrar Todos'
                          ? 'Mostrar Salas Para Mi'
                          : _getRamoDisplayName(value),
                      style: TextStyle(
                        fontWeight: value == 'Mostrar Todos'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: value == 'Mostrar Todos'
                            ? primaryColor
                            : textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 0),
        ],
      ),
    );
  }
}

// Widget para la card de sala
class _StudyRoomCard extends StatelessWidget {
  final StudyRoom room;

  const _StudyRoomCard({required this.room});

  // Unirse y navegar a la sala
  void _handleRoomAction(BuildContext context, bool isMember) async {
    final roomData = room.rawData;
    final roomId = room.id;

    await _checkAndJoinRoom(context, roomData, roomId);
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final isMember = room.members.contains(userId);

    final String displaySubtitle =
        (room.description != null && room.description!.trim().isNotEmpty)
        ? (room.description!.length > 80
              ? '${room.description!.substring(0, 80)}...'
              : room.description!)
        : room.topic;

    final Function()? cardOnTap = () {
      _handleRoomAction(context, isMember);
    };

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: primaryColor,
      child: ListTile(
        onTap: cardOnTap,
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
              // Mostrar descripción corta si existe, si no mostrar el tema
              displaySubtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                // Conteo de Miembros (Número e icono) con capacidad
                Text(
                  '${room.members.length}${room.capacity != null ? '/${room.capacity}' : ''}',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                const Icon(Icons.people_alt, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${room.isOnline ? 'Online' : 'Presencial'} en ${room.campus}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),

        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: isMember ? const Color(0xFF4CAF50) : Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
