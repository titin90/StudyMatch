import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collection/collection.dart';
import '../constants/colors.dart';
import '../ramo_data.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _customCourseCodeController = TextEditingController();
  final _customCourseNameController = TextEditingController();

  String? _selectedCourseCode;
  String _topic = '';
  String _description = '';
  String _campus = 'Campus San Joaquín';
  String _type = 'Online';
  int _capacity = 8;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;
  bool _isCustomCourse = false;
  List<String> _userActiveCourses = [];
  String? _userCareerId;

  // Genera la ruta para Ramos
  String _getRamosDocPath(String uid) {
    const appId = String.fromEnvironment(
      'APP_ID',
      defaultValue: 'default-app-id',
    );
    return 'artifacts/$appId/users/$uid/profile_data/data';
  }

  final List<String> _studyTypes = ['Online', 'Presencial'];
  final List<String> _campuses = [
    'Campus San Joaquín',
    'Campus Casa Central',
    'Campus Vitacura',
    'No Definido',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  // Carga los ramos activos y el campus del usuario
  void _loadInitialData() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    setState(() => _isLoading = true);

    try {
      final rootDoc = await _firestore.collection('users').doc(userId).get();
      final rootData = rootDoc.data();

      final ramosDocPath = _getRamosDocPath(userId);
      final ramosDoc = await _firestore.doc(ramosDocPath).get();
      final ramosData = ramosDoc.data();

      if (mounted) {
        setState(() {
          _campus = rootData?['campus'] ?? 'Campus San Joaquín';
          _userCareerId = rootData?['career_id'] as String?;
          _userActiveCourses =
              (ramosData?['current_ramos'] as List<dynamic>?)
                  ?.cast<String>()
                  .toList() ??
              [];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos del perfil: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Guardar la sala en Firestore
  Future<void> _createStudyRoom() async {
    if (!_isCustomCourse && _selectedCourseCode == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecciona un ramo.')),
        );
      }
      return;
    }

    if (_isCustomCourse) {
      if (_customCourseCodeController.text.trim().isEmpty ||
          _customCourseNameController.text.trim().isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Por favor, completa el código y nombre del ramo personalizado.'),
            ),
          );
        }
        return;
      }
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    if (_auth.currentUser == null) return;

    setState(() {
      _isLoading = true;
    });

    final DateTime scheduledDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    String courseCode;
    String courseName;

    if (_isCustomCourse) {
      courseCode = _customCourseCodeController.text.trim();
      courseName = _customCourseNameController.text.trim();
    } else {
      courseCode = _selectedCourseCode!;
      final Ramo? fullRamo = allRamos.firstWhereOrNull(
        (r) => r.code == courseCode,
      );
      courseName = fullRamo?.name ?? 'Estudio General';
    }

    try {
      await _firestore.collection('study_rooms').add({
        'creatorId': _auth.currentUser!.uid,
        'creatorEmail': _auth.currentUser!.email,
        'courseCode': courseCode,
        'courseName': courseName,
        'isCustomCourse': _isCustomCourse,
        'topic': _topic,
        'description': _description,
        'campus': _campus,
        'type': _type,
        'capacity': _capacity,
        'scheduledTime': Timestamp.fromDate(scheduledDateTime),
        'createdAt': FieldValue.serverTimestamp(),
        'members': [_auth.currentUser!.uid],
        'status': 'active',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sala de estudio creada con éxito!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al crear sala: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Diálogo para seleccionar fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Diálogo para seleccionar hora
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener ramos recomendados basados en la carrera del usuario
    List<String> recommendedCourses = [];
    List<String> allAvailableCourses = [];
    
    if (_userCareerId != null) {
      recommendedCourses = getRamosForCareer(_userCareerId!)
          .map((ramo) => ramo.code)
          .toList();
    }
    
    // Todos los ramos disponibles en el sistema
    allAvailableCourses = allRamos.map((ramo) => ramo.code).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nueva Sala de Estudio'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Selector de tipo de ramo
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: primaryColor.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selecciona el tipo de sala:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Ramos que estás cursando
                          RadioListTile<String>(
                            title: const Text('Mis Ramos Actuales'),
                            subtitle: Text(
                              _userActiveCourses.isEmpty
                                  ? 'No tienes ramos registrados'
                                  : '${_userActiveCourses.length} ramo(s) disponible(s)',
                              style: const TextStyle(fontSize: 12),
                            ),
                            value: 'my_courses',
                            groupValue: _isCustomCourse
                                ? 'custom'
                                : (_selectedCourseCode != null &&
                                        !_userActiveCourses.contains(_selectedCourseCode))
                                    ? 'all_courses'
                                    : 'my_courses',
                            onChanged: _userActiveCourses.isEmpty
                                ? null
                                : (value) {
                                    setState(() {
                                      _isCustomCourse = false;
                                      _selectedCourseCode = null;
                                    });
                                  },
                          ),
                          
                          // Todos los ramos del sistema
                          RadioListTile<String>(
                            title: const Text('Buscar Otros Ramos'),
                            subtitle: const Text(
                              'Explorar ramos de cualquier carrera',
                              style: TextStyle(fontSize: 12),
                            ),
                            value: 'all_courses',
                            groupValue: _isCustomCourse
                                ? 'custom'
                                : (_selectedCourseCode != null &&
                                        !_userActiveCourses.contains(_selectedCourseCode))
                                    ? 'all_courses'
                                    : 'my_courses',
                            onChanged: (value) {
                              setState(() {
                                _isCustomCourse = false;
                                _selectedCourseCode = null;
                              });
                            },
                          ),
                          
                          // Ramo personalizado
                          RadioListTile<String>(
                            title: const Text('Crear Ramo Personalizado'),
                            subtitle: const Text(
                              'Para ramos que no están en el sistema',
                              style: TextStyle(fontSize: 12),
                            ),
                            value: 'custom',
                            groupValue: _isCustomCourse ? 'custom' : 'my_courses',
                            onChanged: (value) {
                              setState(() {
                                _isCustomCourse = true;
                                _selectedCourseCode = null;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // UI condicional según el tipo seleccionado
                    if (!_isCustomCourse) ...[
                      // Dropdown para ramos
                      _buildRamoDropdown(),
                    ] else ...[
                      // Campos para ramo personalizado
                      _buildCustomCourseFields(),
                    ],
                    
                    const SizedBox(height: 16),

                    // Tema
                    _buildTextFormField(
                label: 'Tema Específico (Ej: Árboles Binarios, Certamen 1)',
                onSave: (val) => _topic = val!,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              // Descripción breve (opcional)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Descripción breve (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onSaved: (val) => _description = val?.trim() ?? '',
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),

              // Campus
              _buildDropdownField(
                label: 'Campus/Ubicación',
                value: _campus,
                items: _campuses,
                onChanged: (String? newValue) {
                  setState(() {
                    _campus = newValue!;
                  });
                },
                hint: 'Selecciona tu campus',
              ),
              const SizedBox(height: 16),

              // Tipo de estudio
              _buildDropdownField(
                label: 'Tipo de Estudio',
                value: _type,
                items: _studyTypes,
                onChanged: (String? newValue) {
                  setState(() {
                    _type = newValue!;
                  });
                },
                hint: 'Online o Presencial',
              ),
              const SizedBox(height: 24),

              // Capacidad (moved above Fecha y Hora)
              TextFormField(
                initialValue: _capacity.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Capacidad máxima',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Ingrese capacidad';
                  final n = int.tryParse(val);
                  if (n == null || n <= 0) return 'Ingrese un número válido';
                  return null;
                },
                onSaved: (val) => _capacity = int.parse(val!),
              ),

              const SizedBox(height: 12),

              // Fecha y hora
              const Text(
                'Fecha y Hora Programada',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: _buildDateTimeSelector(
                      icon: Icons.calendar_today,
                      value:
                          "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildDateTimeSelector(
                      icon: Icons.access_time,
                      value: _selectedTime.format(context),
                      onTap: () => _selectTime(context),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Botón de Creación
              Center(
                child: ElevatedButton.icon(
                  onPressed: _createStudyRoom,
                  icon: const Icon(Icons.group_add),
                  label: const Text(
                    'Crear Sala',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper para TextField
  Widget _buildTextFormField({
    required String label,
    required void Function(String?) onSave,
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
      validator: (val) => val!.isEmpty ? 'Este campo es obligatorio' : null,
      onSaved: onSave,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  // Widget para seleccionar ramo del dropdown
  Widget _buildRamoDropdown() {
    List<String> availableCourses;
    String hint;
    
    // Determinar qué lista mostrar
    if (_selectedCourseCode != null && !_userActiveCourses.contains(_selectedCourseCode)) {
      // Modo "todos los ramos"
      availableCourses = allRamos.map((r) => r.code).toList();
      hint = 'Buscar cualquier ramo...';
    } else {
      // Modo "mis ramos"
      availableCourses = _userActiveCourses.isNotEmpty 
          ? _userActiveCourses 
          : allRamos.map((r) => r.code).toList(); // Si no tiene ramos, mostrar todos
      hint = _userActiveCourses.isEmpty
          ? 'Selecciona un ramo del sistema'
          : 'Selecciona uno de tus ramos';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Ramo',
            hintText: hint,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.book),
          ),
          value: availableCourses.contains(_selectedCourseCode)
              ? _selectedCourseCode
              : null,
          isExpanded: true,
          items: availableCourses.isEmpty 
              ? []
              : availableCourses.map((code) {
                  final ramo = allRamos.firstWhereOrNull((r) => r.code == code);
                  final displayName = ramo != null
                      ? '${ramo.code} - ${ramo.name}'
                      : code;
                  return DropdownMenuItem<String>(
                    value: code,
                    child: Text(
                      displayName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
          onChanged: availableCourses.isEmpty 
              ? null 
              : (value) {
                  setState(() {
                    _selectedCourseCode = value;
                  });
                },
          validator: (value) => value == null ? 'Selecciona un ramo' : null,
        ),
        if (_selectedCourseCode != null) ...[
          const SizedBox(height: 8),
          _buildRamoInfo(_selectedCourseCode!),
        ],
      ],
    );
  }

  // Widget para mostrar información del ramo seleccionado
  Widget _buildRamoInfo(String code) {
    final ramo = allRamos.firstWhereOrNull((r) => r.code == code);
    if (ramo == null) return const SizedBox.shrink();

    final isMyRamo = _userActiveCourses.contains(code);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMyRamo ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isMyRamo ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isMyRamo ? Icons.check_circle : Icons.info,
            color: isMyRamo ? Colors.green : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isMyRamo
                  ? 'Este es uno de tus ramos actuales'
                  : 'Ramo de ${ramo.universityId}',
              style: TextStyle(
                fontSize: 13,
                color: isMyRamo ? Colors.green[900] : Colors.orange[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Campos para crear ramo personalizado
  Widget _buildCustomCourseFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          ' Ingresa los datos del ramo',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _customCourseCodeController,
          decoration: const InputDecoration(
            labelText: 'Código del Ramo',
            hintText: 'Ej: MAT-101, FIS-200',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.tag),
          ),
          textCapitalization: TextCapitalization.characters,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Ingresa el código del ramo';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _customCourseNameController,
          decoration: const InputDecoration(
            labelText: 'Nombre del Ramo',
            hintText: 'Ej: Matemáticas I, Física General',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.book),
          ),
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Ingresa el nombre del ramo';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: primaryColor, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Esta sala estará disponible para todos los usuarios',
                  style: TextStyle(fontSize: 12, color: primaryColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 💡 HELPER MODIFICADO: DropdownButtonFormField simple y robusto
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String hint,
  }) {
    // Validar que el value esté en la lista, si no, usar null
    final validValue = (value != null && items.contains(value)) ? value : null;
    
    return DropdownButtonFormField<String>(
      value: validValue,
      decoration: InputDecoration(
        // Configuración de estilo directa
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 18,
        ),
      ),
      isExpanded: true, // Para que tome el ancho completo
      hint: Text(hint),
      onChanged: onChanged, // Usamos la función onChanged directamente
      // Validación obligatoria para todos los Dropdowns
      validator: (val) => val == null ? 'Selección obligatoria' : null,
      items: items.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
    );
  }

  // Helper para Selector de Fecha/Hora (Sin cambios)
  Widget _buildDateTimeSelector({
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryColor),
            const SizedBox(width: 8),
            Text(value, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
