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

  String get name => topic;
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
    if (_selectedIndex == 1) {
      title = 'Mi Perfil';
    } else if (_selectedIndex == 0) {
      title = 'StudyMatch';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [if (_selectedIndex == 1) _buildLogoutAction(context)],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
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
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'StudyMatch'),
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> _userActiveCourses = [];
  String? _selectedFilterRamo;
  String _filterMode = 'my_courses'; // 'my_courses', 'all'
  String? _selectedUniversity; // Filtro por universidad
  String? _selectedCampus;
  String? _selectedModalidad; // 'Online', 'Presencial', null = todas
  String? _selectedCareer; // Filtro por carrera
  bool _hideFullRooms = false;
  bool _isLoading = true;
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();

  // Lista de universidades
  final List<String> _universities = [
    'Universidad Técnica Federico Santa María',
    'Pontificia Universidad Católica de Chile',
    'Universidad de Chile',
    'Universidad de Santiago de Chile',
  ];

  // Campus organizados por universidad
  final Map<String, List<String>> _campusesByUniversity = {
    'Universidad Técnica Federico Santa María': [
      'Campus Casa Central - Valparaíso',
      'Campus San Joaquín - Santiago',
      'Campus Vitacura - Santiago',
      'Campus Concepción',
    ],
    'Pontificia Universidad Católica de Chile': [
      'Campus San Joaquín',
      'Campus Casa Central',
      'Campus Oriente',
      'Campus Villarrica',
      'Campus Lo Contador',
    ],
    'Universidad de Chile': [
      'Campus Beauchef',
      'Campus Juan Gómez Millas',
      'Campus Andrés Bello',
      'Campus Norte',
      'Campus Sur',
    ],
    'Universidad de Santiago de Chile': [
      'Campus Central',
      'Campus Estación Central',
    ],
  };

  // Carreras organizadas por universidad
  final Map<String, Map<String, String>> _careersByUniversity = {
    'Universidad Técnica Federico Santa María': {
      'USM-CIV-INF': 'Ing. Civil Informática',
      'USM-CIV-IND': 'Ing. Civil Industrial',
      'USM-CIV-ELE': 'Ing. Civil Eléctrica',
      'USM-CIV-MEC': 'Ing. Civil Mecánica',
    },
    'Pontificia Universidad Católica de Chile': {
      'UC-CC': 'Ciencia de la Computación',
      'UC-CIV': 'Ing. Civil',
      'UC-MED': 'Medicina',
      'UC-DER': 'Derecho',
    },
    'Universidad de Chile': {
      'UCHILE-CIV-INF': 'Ing. Civil Informática',
      'UCHILE-CIV-IND': 'Ing. Civil Industrial',
      'UCHILE-COM': 'Ing. Comercial',
      'UCHILE-MED': 'Medicina',
    },
    'Universidad de Santiago de Chile': {
      'USACH-CIV-INF': 'Ing. Civil Informática',
      'USACH-CIV-IND': 'Ing. Civil Industrial',
      'USACH-COM': 'Ing. Comercial',
      'USACH-CIV-MIN': 'Ing. Civil En Minas',
    },
  };

  // Obtener campus según universidad seleccionada
  List<String> get _availableCampuses {
    if (_selectedUniversity == null) return [];
    return _campusesByUniversity[_selectedUniversity!] ?? [];
  }

  // Obtener carreras según universidad seleccionada
  Map<String, String> get _availableCareers {
    if (_selectedUniversity == null) return {};
    return _careersByUniversity[_selectedUniversity!] ?? {};
  }

  @override
  void initState() {
    super.initState();
    _loadActiveCourses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    } else if (_filterMode == 'my_rooms') {
      // Mostrar solo salas en las que el usuario está inscrito
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        roomsQuery = roomsQuery.where('members', arrayContains: userId);
      } else {
        // Usuario no autenticado: no devolver resultados
        roomsQuery = roomsQuery.where('members', arrayContains: '__no_user__');
      }
    }
    // Si el modo es 'all', no aplicamos filtro (muestra todas las salas)

    // Aplicar filtro de modalidad
    if (_selectedModalidad != null) {
      roomsQuery = roomsQuery.where('type', isEqualTo: _selectedModalidad);
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildFilterDrawer(),
      body: Column(
        children: [
          // Header con título y botón de filtros
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Salas disponibles',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                IconButton(
                  icon: Stack(
                    children: [
                      const Icon(
                        Icons.filter_list,
                        color: primaryColor,
                        size: 28,
                      ),
                      if (_hasActiveFilters())
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: secondaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${_getActiveFiltersCount()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  tooltip: 'Filtros',
                ),
              ],
            ),
          ),

          // Buscador de texto
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por título o descripción...',
                prefixIcon: const Icon(Icons.search, color: primaryColor),
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchText = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: primaryColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value.toLowerCase();
                });
              },
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

                // Obtener todas las salas
                var rooms = snapshot.hasData
                    ? snapshot.data!.docs
                          .map((doc) => StudyRoom.fromFirestore(doc))
                          .toList()
                    : <StudyRoom>[];

                // Aplicar filtros del lado del cliente
                rooms = _applyClientSideFilters(rooms);

                if (rooms.isEmpty) {
                  String mensaje;

                  if (_filterMode == 'all') {
                    mensaje =
                        'No hay salas disponibles en este momento.\n¡Sé el primero en crear una!';
                  } else if (_filterMode == 'my_rooms' &&
                      _auth.currentUser == null) {
                    mensaje = 'Debes iniciar sesión para ver tus salas.';
                  } else if (_filterMode == 'my_rooms') {
                    mensaje =
                        'No estás en ninguna sala.\nCrea una o únete a una.';
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
    );
  }

  // Aplicar filtros del lado del cliente
  List<StudyRoom> _applyClientSideFilters(List<StudyRoom> rooms) {
    var filteredRooms = rooms;

    // Filtro por campus
    if (_selectedCampus != null) {
      filteredRooms = filteredRooms.where((room) {
        final campus = room.campus;
        final selected = _selectedCampus!;
        return campus == selected || campus.contains(selected);
      }).toList();
    }

    // Filtro por universidad: usamos los códigos de carrera conocidos para esa universidad
    if (_selectedUniversity != null) {
      final careerKeys =
          _careersByUniversity[_selectedUniversity!]?.keys.toList() ?? [];
      if (careerKeys.isNotEmpty) {
        filteredRooms = filteredRooms.where((room) {
          final code = room.courseCode;
          for (final key in careerKeys) {
            if (code.startsWith(key)) return true;
          }
          // fallback: intentar comparar por campus o por nombre de universidad en campos disponibles
          final campusLower = room.campus.toLowerCase();
          if (campusLower.contains(_selectedUniversity!.toLowerCase()))
            return true;
          final rawName = (room.rawData['university'] ?? '')
              .toString()
              .toLowerCase();
          if (rawName.isNotEmpty &&
              rawName.contains(_selectedUniversity!.toLowerCase()))
            return true;
          return false;
        }).toList();
      } else {
        // Si no hay códigos de carrera registrados, filtrar por campo campus/metadata
        filteredRooms = filteredRooms.where((room) {
          final campusLower = room.campus.toLowerCase();
          return campusLower.contains(_selectedUniversity!.toLowerCase()) ||
              (room.rawData['university'] ?? '')
                  .toString()
                  .toLowerCase()
                  .contains(_selectedUniversity!.toLowerCase());
        }).toList();
      }
    }
    // Filtro por carrera (busca en el courseCode)
    if (_selectedCareer != null) {
      filteredRooms = filteredRooms.where((room) {
        // El courseCode tiene formato: UNIVERSIDAD-CARRERA-CODIGO
        // Ej: USM-CIV-INF-ICI-101
        return room.courseCode.startsWith(_selectedCareer!);
      }).toList();
    }

    // Filtro para ocultar salas llenas
    if (_hideFullRooms) {
      filteredRooms = filteredRooms.where((room) {
        if (room.capacity == null) return true;
        return room.members.length < room.capacity!;
      }).toList();
    }

    // Filtro por búsqueda de texto
    if (_searchText.isNotEmpty) {
      filteredRooms = filteredRooms.where((room) {
        final titleMatch = room.name.toLowerCase().contains(_searchText);
        final topicMatch = room.topic.toLowerCase().contains(_searchText);
        final descriptionMatch =
            room.description != null &&
            room.description!.toLowerCase().contains(_searchText);
        return titleMatch || topicMatch || descriptionMatch;
      }).toList();
    }

    return filteredRooms;
  }

  // Verificar si hay filtros activos
  bool _hasActiveFilters() {
    return _filterMode == 'my_courses' ||
        _filterMode == 'my_rooms' ||
        _selectedFilterRamo != null && _selectedFilterRamo != 'Mostrar Todos' ||
        _selectedUniversity != null ||
        _selectedCampus != null ||
        _selectedModalidad != null ||
        _selectedCareer != null ||
        _hideFullRooms ||
        _searchText.isNotEmpty;
  }

  // Contar filtros activos
  int _getActiveFiltersCount() {
    int count = 0;
    if (_filterMode == 'my_courses') count++;
    if (_filterMode == 'my_rooms') count++;
    if (_selectedFilterRamo != null && _selectedFilterRamo != 'Mostrar Todos')
      count++;
    if (_selectedUniversity != null) count++;
    if (_selectedCampus != null) count++;
    if (_selectedModalidad != null) count++;
    if (_selectedCareer != null) count++;
    if (_hideFullRooms) count++;
    if (_searchText.isNotEmpty) count++;
    return count;
  }

  // Drawer de filtros
  Widget _buildFilterDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header del drawer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: primaryColor),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.filter_list, color: Colors.white, size: 32),
                  SizedBox(height: 8),
                  Text(
                    'Filtros',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Personaliza tu búsqueda',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Filtro por tipo de salas
                  const Text(
                    'Tipo de salas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RadioListTile<String>(
                    title: const Text('Todas las salas'),
                    value: 'all',
                    groupValue: _filterMode,
                    onChanged: (value) {
                      setState(() {
                        _filterMode = value!;
                        _selectedFilterRamo = null;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'Mis ramos (${_userActiveCourses.where((r) => r != 'Mostrar Todos').length})',
                    ),
                    value: 'my_courses',
                    groupValue: _filterMode,
                    onChanged: _userActiveCourses.isEmpty
                        ? null
                        : (value) {
                            setState(() {
                              _filterMode = value!;
                              _selectedFilterRamo = 'Mostrar Todos';
                            });
                          },
                    activeColor: primaryColor,
                  ),
                  RadioListTile<String>(
                    title: const Text('Mis salas'),
                    value: 'my_rooms',
                    groupValue: _filterMode,
                    onChanged: _auth.currentUser == null
                        ? null
                        : (value) {
                            setState(() {
                              _filterMode = value!;
                              _selectedFilterRamo = null;
                            });
                          },
                    activeColor: primaryColor,
                  ),

                  const Divider(height: 32),

                  // Filtro por ramo específico (solo si está en modo mis ramos)
                  if (_filterMode == 'my_courses' &&
                      _userActiveCourses.isNotEmpty) ...[
                    const Text(
                      'Ramo específico',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedFilterRamo,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: primaryColor,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedFilterRamo = newValue;
                            });
                          },
                          items: _userActiveCourses
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value == 'Mostrar Todos'
                                        ? 'Todos mis ramos'
                                        : _getRamoDisplayName(value),
                                    style: TextStyle(
                                      fontWeight: value == 'Mostrar Todos'
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                    ),
                    const Divider(height: 32),
                  ],

                  // Filtro por universidad
                  const Text(
                    'Universidad',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String?>(
                        value: _selectedUniversity,
                        hint: const Text('Todas las universidades'),
                        isExpanded: true,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: primaryColor,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedUniversity = newValue;
                            // Limpiar campus y carrera al cambiar universidad
                            _selectedCampus = null;
                            _selectedCareer = null;
                          });
                        },
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text(
                              'Todas las universidades',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ..._universities.map((university) {
                            return DropdownMenuItem<String?>(
                              value: university,
                              child: Text(
                                university,
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 32),

                  // Filtro por modalidad
                  const Text(
                    'Modalidad',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RadioListTile<String?>(
                    title: const Text('Todas'),
                    value: null,
                    groupValue: _selectedModalidad,
                    onChanged: (value) {
                      setState(() {
                        _selectedModalidad = value;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  RadioListTile<String?>(
                    title: const Text('Online'),
                    value: 'Online',
                    groupValue: _selectedModalidad,
                    onChanged: (value) {
                      setState(() {
                        _selectedModalidad = value;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  RadioListTile<String?>(
                    title: const Text('Presencial'),
                    value: 'Presencial',
                    groupValue: _selectedModalidad,
                    onChanged: (value) {
                      setState(() {
                        _selectedModalidad = value;
                      });
                    },
                    activeColor: primaryColor,
                  ),

                  const Divider(height: 32),

                  // Filtro por campus (solo si hay universidad seleccionada)
                  Text(
                    'Campus',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedUniversity != null
                          ? primaryColor
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedUniversity != null
                            ? Colors.grey[300]!
                            : Colors.grey[200]!,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: _selectedUniversity == null
                          ? Colors.grey[100]
                          : null,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String?>(
                        value: _selectedCampus,
                        hint: Text(
                          _selectedUniversity == null
                              ? 'Selecciona una universidad primero'
                              : 'Todos los campus',
                          style: TextStyle(
                            color: _selectedUniversity == null
                                ? Colors.grey
                                : null,
                          ),
                        ),
                        isExpanded: true,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: _selectedUniversity != null
                              ? primaryColor
                              : Colors.grey,
                        ),
                        onChanged: _selectedUniversity == null
                            ? null
                            : (String? newValue) {
                                setState(() {
                                  _selectedCampus = newValue;
                                });
                              },
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text(
                              'Todos los campus',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ..._availableCampuses.map((campus) {
                            return DropdownMenuItem<String?>(
                              value: campus,
                              child: Text(campus),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 32),

                  // Filtro por carrera (solo si hay universidad seleccionada)
                  Text(
                    'Carrera',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedUniversity != null
                          ? primaryColor
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedUniversity != null
                            ? Colors.grey[300]!
                            : Colors.grey[200]!,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: _selectedUniversity == null
                          ? Colors.grey[100]
                          : null,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String?>(
                        value: _selectedCareer,
                        hint: Text(
                          _selectedUniversity == null
                              ? 'Selecciona una universidad primero'
                              : 'Todas las carreras',
                          style: TextStyle(
                            color: _selectedUniversity == null
                                ? Colors.grey
                                : null,
                          ),
                        ),
                        isExpanded: true,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: _selectedUniversity != null
                              ? primaryColor
                              : Colors.grey,
                        ),
                        onChanged: _selectedUniversity == null
                            ? null
                            : (String? newValue) {
                                setState(() {
                                  _selectedCareer = newValue;
                                });
                              },
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text(
                              'Todas las carreras',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ..._availableCareers.entries.map((entry) {
                            return DropdownMenuItem<String?>(
                              value: entry.key,
                              child: Text(
                                entry.value,
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 32),

                  // Otras opciones
                  const Text(
                    'Otras opciones',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Ocultar salas llenas'),
                    subtitle: const Text(
                      'Solo mostrar salas con cupos disponibles',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: _hideFullRooms,
                    onChanged: (bool value) {
                      setState(() {
                        _hideFullRooms = value;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                ],
              ),
            ),

            // Botones de acción
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _filterMode = 'all';
                          _selectedFilterRamo = null;
                          _selectedUniversity = null;
                          _selectedCampus = null;
                          _selectedModalidad = null;
                          _selectedCareer = null;
                          _hideFullRooms = false;
                          _searchController.clear();
                          _searchText = '';
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: const BorderSide(color: primaryColor),
                      ),
                      child: const Text('Limpiar filtros'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Aplicar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
        ? (room.description!.length > 100
              ? '${room.description!.substring(0, 100)}...'
              : room.description!)
        : room.topic;

    // Determinar el lugar según modalidad
    final String lugar = room.isOnline ? 'Online' : room.campus;

    final Function()? cardOnTap = () {
      _handleRoomAction(context, isMember);
    };

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: primaryColor,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: cardOnTap,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                room.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            // Código de carrera (arriba a la derecha)
            if (room.courseCode != 'N/A' && room.courseCode.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  room.courseCode,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            // Descripción
            Text(
              displaySubtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Capacidad | Lugar
            Row(
              children: [
                const Icon(Icons.people_alt, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${room.members.length}${room.capacity != null ? '/${room.capacity}' : ''}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '|',
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
                const SizedBox(width: 8),
                Icon(
                  room.isOnline ? Icons.wifi : Icons.location_on,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    lugar,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: isMember ? const Color(0xFF4CAF50) : Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
