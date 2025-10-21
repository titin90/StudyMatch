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
  String _campus = 'Campus San Joaquín';
  String _type = 'Online';
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

    final Ramo? fullRamo = allRamos.firstWhereOrNull(
      (r) => r.code == _selectedCourseCode,
    );
    final courseName = fullRamo?.name ?? 'Estudio General';

    try {
      await _firestore.collection('study_rooms').add({
        'creatorId': _auth.currentUser!.uid,
        'creatorEmail': _auth.currentUser!.email,
        'courseCode': _selectedCourseCode,
        'courseName': courseName,
        'topic': _topic,
        'campus': _campus,
        'type': _type,
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
    final List<String> availableCourses = _userActiveCourses;

    if (_userActiveCourses.isEmpty && !_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Crear Nueva Sala de Estudio'),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning, size: 50, color: secondaryColor),
                const SizedBox(height: 16),
                const Text(
                  'Aún no tienes ramos activos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ve a tu Perfil para seleccionar los ramos que estás cursando antes de crear una sala.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Volver al Inicio'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nueva Sala de Estudio'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Dropdown para seleccionar el Ramo
              _buildDropdownField(
                label: 'Ramo a Estudiar',
                value: _selectedCourseCode,
                items: availableCourses,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCourseCode = newValue;
                  });
                },
                hint: 'Selecciona el código del ramo',
              ),
              const SizedBox(height: 16),

              // Tema
              _buildTextFormField(
                label: 'Tema Específico (Ej: Árboles Binarios, Certamen 1)',
                onSave: (val) => _topic = val!,
                maxLines: 3,
              ),
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

  // 💡 HELPER MODIFICADO: DropdownButtonFormField simple y robusto
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String hint,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
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
