// lib/screens/create_room_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Colores de StudyMatch
const Color primaryColor = Color(0xFF0560FA);
const Color secondaryColor = Color(0xFFEC8000);

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Campos del formulario
  String _courseCode = '';
  String _topic = '';
  String _campus = '';
  String _type = 'Online';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;

  // Opciones predefinidas
  final List<String> _studyTypes = ['Online', 'Presencial'];

  // Lista de campus (solo para ejemplo, puedes precargarlos de Firebase o usar la del perfil)
  final List<String> _campuses = [
    'No Definido',
    'Campus San Joaquín',
    'Campus Casa Central',
    'Campus Vitacura',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserCampus();
  }

  // Intenta precargar el campus del usuario
  Future<void> _loadUserCampus() async {
    if (_auth.currentUser == null) return;

    final userDoc = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    if (userDoc.exists) {
      final data = userDoc.data();
      if (mounted) {
        setState(() {
          // Si el usuario tiene un campus en su perfil, lo usamos como valor predeterminado
          _campus = data?['campus'] ?? 'Campus San Joaquín';
        });
      }
    } else {
      // Si el usuario no tiene perfil, usamos el primer campus por defecto
      setState(() {
        _campus = 'Campus San Joaquín';
      });
    }
  }

  // Función para guardar la sala de estudio en Firestore
  Future<void> _createStudyRoom() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    if (_auth.currentUser == null) return;

    setState(() {
      _isLoading = true;
    });

    // Combina la fecha y hora seleccionadas en un único Timestamp
    final DateTime scheduledDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    try {
      await _firestore.collection('study_rooms').add({
        'creatorId': _auth.currentUser!.uid,
        'creatorEmail': _auth.currentUser!.email,
        'courseCode': _courseCode.toUpperCase(),
        'topic': _topic,
        'campus': _campus,
        'type': _type,
        'scheduledTime': Timestamp.fromDate(scheduledDateTime),
        'createdAt': FieldValue.serverTimestamp(),
        'members': [_auth.currentUser!.uid], // El creador es el primer miembro
        'status': 'active',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sala de estudio creada con éxito!')),
        );
        Navigator.of(context).pop(); // Vuelve a la pantalla de inicio
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

  // Diálogo para seleccionar la fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 0)), // Hoy
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Diálogo para seleccionar la hora
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Campo: Ramo (Course Code)
                    _buildTextFormField(
                      label: 'Código del Ramo (Ej: IWI-131)',
                      onSave: (val) => _courseCode = val!,
                    ),
                    const SizedBox(height: 16),

                    // Campo: Tema (Topic)
                    _buildTextFormField(
                      label: 'Tema a Estudiar (Ej: Árboles Binarios)',
                      onSave: (val) => _topic = val!,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Dropdown: Campus
                    _buildDropdownField(
                      label: 'Campus',
                      value: _campus,
                      items: _campuses,
                      onChanged: (String? newValue) {
                        setState(() {
                          _campus = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Dropdown: Tipo (Online/Presencial)
                    _buildDropdownField(
                      label: 'Tipo de Estudio',
                      value: _type,
                      items: _studyTypes,
                      onChanged: (String? newValue) {
                        setState(() {
                          _type = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Seleccion de Fecha y Hora
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

  // Helper para Dropdown
  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
        ),
      ),
    );
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
