import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ramo_data.dart';

const Color primaryColor = Color(0xFF0560FA);
const Color secondaryColor = Color(0xFFEC8000);
const Color textColor = Color(0xFF3A3A3A);

class RamoSelectionScreen extends StatefulWidget {
  final String careerId;
  final String careerName;
  final List<String> initialRamos;

  const RamoSelectionScreen({
    super.key,
    required this.careerId,
    required this.careerName,
    required this.initialRamos,
  });

  @override
  State<RamoSelectionScreen> createState() => _RamoSelectionScreenState();
}

class _RamoSelectionScreenState extends State<RamoSelectionScreen> {
  late Set<String> _selectedRamos;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedRamos = Set<String>.from(widget.initialRamos);
  }

  // Genera la ruta del documento de perfil
  String _getProfileDocPath(String uid) {
    const appId = String.fromEnvironment(
      'APP_ID',
      defaultValue: 'default-app-id',
    );
    return 'artifacts/$appId/users/$uid/profile_data/data';
  }

  // Filtra los ramos por carrera
  List<Ramo> getFilteredSubjects() {
    return allRamos.where((ramo) => ramo.careerId == widget.careerId).toList();
  }

  // Guarda los ramos seleccionados en Firestore
  Future<void> _updateRamosInFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Usuario no autenticado para guardar.'),
          ),
        );
      }
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final docPath = _getProfileDocPath(user.uid);
      final List<String> ramosToSave = _selectedRamos.toList();

      await FirebaseFirestore.instance.doc(docPath).set({
        'current_ramos': ramosToSave,
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Guardado automáticamente.'),
            duration: Duration(milliseconds: 500),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // Alterna la selección de un ramo
  void _toggleRamoSelection(Ramo ramo) {
    setState(() {
      if (_selectedRamos.contains(ramo.code)) {
        _selectedRamos.remove(ramo.code);
      } else {
        _selectedRamos.add(ramo.code);
      }
    });

    _updateRamosInFirestore();
  }

  // Agrupa los ramos por año
  Map<String, List<Ramo>> _groupRamosByYear(List<Ramo> allRamos) {
    Map<String, List<Ramo>> ramosByYear = {};
    for (var ramo in allRamos) {
      if (!ramosByYear.containsKey(ramo.year)) {
        ramosByYear[ramo.year] = [];
      }
      ramosByYear[ramo.year]!.add(ramo);
    }

    return Map.fromEntries(
      ramosByYear.entries.toList()
        ..sort((a, b) => double.parse(a.key).compareTo(double.parse(b.key))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allRamos = getFilteredSubjects();
    final ramosByYear = _groupRamosByYear(allRamos);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ramos de ${widget.careerName}'),
        backgroundColor: primaryColor, // Usamos la constante
        foregroundColor: Colors.white,
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: allRamos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school, size: 60, color: Colors.blueGrey),
                  const SizedBox(height: 16),
                  Text(
                    'No hay ramos disponibles para ${widget.careerName}.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: ramosByYear.entries.map((entry) {
                final year = entry.key;
                final ramosInYear = entry.value;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: year == '1',
                    leading: const Icon(
                      Icons.calendar_today,
                      color: primaryColor,
                    ),
                    title: Text(
                      'Año $year',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: Text('${ramosInYear.length} ramos disponibles'),
                    children: ramosInYear.map((ramo) {
                      final isSelected = _selectedRamos.contains(ramo.code);

                      return ListTile(
                        leading: const Icon(Icons.class_, color: primaryColor),
                        title: Text(
                          ramo.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${ramo.code} - Año ${ramo.year}'),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : null,
                        onTap: () {
                          _toggleRamoSelection(ramo);
                        },
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
