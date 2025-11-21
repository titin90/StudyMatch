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

  String? _selectedCourseCode;
  String _topic = '';
  String _description = '';
  String _campus = 'Campus San Joaquín';
  String _type = 'Online';
  int _capacity = 8;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;
  List<String> _userActiveCourses = [];

  // Genera la ruta para Ramos
  String _getRamosDocPath(String uid) {
    const appId = String.fromEnvironment(
      'APP_ID',
      defaultValue: 'default-app-id',
    );
    return 'artifacts/$appId/users/$uid/profile_data/data';
  }

  final List<String> _studyTypes = ['Online', 'Presencial'];
  
  // Mapa de universidades a nombres completos y sus campus
  final Map<String, Map<String, dynamic>> _universityData = {
    'USM': {
      'name': 'Universidad Técnica Federico Santa María',
      'campuses': [
        'Campus Casa Central - Valparaíso',
        'Campus San Joaquín - Santiago',
        'Campus Vitacura - Santiago',
        'Campus Concepción',
      ],
    },
    'UC': {
      'name': 'Pontificia Universidad Católica de Chile',
      'campuses': [
        'Campus San Joaquín',
        'Campus Casa Central',
        'Campus Oriente',
        'Campus Villarrica',
        'Campus Lo Contador',
      ],
    },
    'UCHILE': {
      'name': 'Universidad de Chile',
      'campuses': [
        'Campus Beauchef',
        'Campus Juan Gómez Millas',
        'Campus Andrés Bello',
        'Campus Norte',
        'Campus Sur',
      ],
    },
    'USACH': {
      'name': 'Universidad de Santiago de Chile',
      'campuses': [
        'Campus Central',
        'Campus Estación Central',
      ],
    },
  };
  
  // Campus disponibles según el ramo seleccionado
  List<String> _availableCampuses = [];

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
          // No establecer campus aquí, se hará cuando se seleccione un ramo
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
    if (_selectedCourseCode == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecciona un ramo.')),
        );
      }
      return;
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

    final courseCode = _selectedCourseCode!;
    final Ramo? fullRamo = allRamos.firstWhereOrNull(
      (r) => r.code == courseCode,
    );
    final courseName = fullRamo?.name ?? 'Estudio General';

    try {
      await _firestore.collection('study_rooms').add({
        'creatorId': _auth.currentUser!.uid,
        'creatorEmail': _auth.currentUser!.email,
        'courseCode': courseCode,
        'courseName': courseName,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nueva Sala de Estudio'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : _userActiveCourses.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No tienes ramos registrados',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Primero debes agregar tus ramos en tu perfil para poder crear salas de estudio',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Volver'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        // Dropdown para seleccionar ramo
                        _buildRamoDropdown(),
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
                items: _availableCampuses.isEmpty ? ['No Definido'] : _availableCampuses,
                onChanged: (String? newValue) {
                  setState(() {
                    _campus = newValue!;
                  });
                },
                hint: _selectedCourseCode == null 
                    ? 'Primero selecciona un ramo' 
                    : 'Selecciona tu campus',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Ramo',
            hintText: 'Selecciona uno de tus ramos',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.book),
          ),
          value: _userActiveCourses.contains(_selectedCourseCode)
              ? _selectedCourseCode
              : null,
          isExpanded: true,
          items: _userActiveCourses.map((code) {
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
          onChanged: (value) {
            setState(() {
              _selectedCourseCode = value;
              _updateCampusOptions();
            });
          },
          validator: (value) => value == null ? 'Selecciona un ramo' : null,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String hint,
  }) {
    final validValue = (value != null && items.contains(value)) ? value : null;
    
    return DropdownButtonFormField<String>(
      value: validValue,
      decoration: InputDecoration(
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
      isExpanded: true, 
      hint: Text(hint),
      onChanged: onChanged,
      validator: (val) => val == null ? 'Selección obligatoria' : null,
      items: items.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
    );
  }

  // Actualiza las opciones de campus según el ramo seleccionado
  void _updateCampusOptions() {
    if (_selectedCourseCode == null) {
      _availableCampuses = [];
      _campus = 'Campus San Joaquín';
      return;
    }

    // Buscar el ramo en allRamos para obtener su universityId
    final selectedRamo = allRamos.firstWhereOrNull(
      (r) => r.code == _selectedCourseCode,
    );

    if (selectedRamo != null) {
      final universityId = selectedRamo.universityId;
      final universityInfo = _universityData[universityId];
      
      if (universityInfo != null) {
        _availableCampuses = List<String>.from(universityInfo['campuses']);
        // Establecer el primer campus como predeterminado si el actual no está disponible
        if (!_availableCampuses.contains(_campus) && _availableCampuses.isNotEmpty) {
          _campus = _availableCampuses.first;
        }
      } else {
        _availableCampuses = [];
        _campus = 'No Definido';
      }
    } else {
      _availableCampuses = [];
      _campus = 'No Definido';
    }
  }

  // Helper para Selector de Fecha/Hora 
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
