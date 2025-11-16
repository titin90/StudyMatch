import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants/colors.dart';
import 'ramo_data.dart';

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

  // Filtra los ramos por carrera usando el helper
  List<Ramo> getFilteredSubjects() {
    return getRamosForCareer(widget.careerId);
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

  // Agrupa los ramos por año y luego por semestre
  Map<String, Map<String, List<Ramo>>> _groupRamosByYearAndSemester(List<Ramo> allRamos) {
    Map<String, Map<String, List<Ramo>>> ramosByYearAndSemester = {};
    
    for (var ramo in allRamos) {
      if (!ramosByYearAndSemester.containsKey(ramo.year)) {
        ramosByYearAndSemester[ramo.year] = {};
      }
      if (!ramosByYearAndSemester[ramo.year]!.containsKey(ramo.semester)) {
        ramosByYearAndSemester[ramo.year]![ramo.semester] = [];
      }
      ramosByYearAndSemester[ramo.year]![ramo.semester]!.add(ramo);
    }

    // Ordenar por año
    return Map.fromEntries(
      ramosByYearAndSemester.entries.toList()
        ..sort((a, b) => double.parse(a.key).compareTo(double.parse(b.key))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allRamos = getFilteredSubjects();
    final ramosByYearAndSemester = _groupRamosByYearAndSemester(allRamos);

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
              children: ramosByYearAndSemester.entries.map((yearEntry) {
                final year = yearEntry.key;
                final semesterMap = yearEntry.value;
                
                // Contar total de ramos del año
                final totalRamosInYear = semesterMap.values
                    .fold<int>(0, (sum, ramos) => sum + ramos.length);

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
                    subtitle: Text('$totalRamosInYear ramos disponibles'),
                    children: semesterMap.entries.map((semesterEntry) {
                      final semester = semesterEntry.key;
                      final ramosInSemester = semesterEntry.value;
                      
                      // Ordenar semestres numéricamente
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Card(
                          color: Colors.grey[50],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          child: ExpansionTile(
                            initiallyExpanded: semester == '1',
                            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            leading: Icon(
                              Icons.book_outlined,
                              color: secondaryColor,
                              size: 20,
                            ),
                            title: Text(
                              'Semestre $semester',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              '${ramosInSemester.length} ramos',
                              style: const TextStyle(fontSize: 12),
                            ),
                            children: ramosInSemester.map((ramo) {
                              final isSelected = _selectedRamos.contains(ramo.code);

                              return ListTile(
                                dense: true,
                                leading: Icon(
                                  Icons.class_,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                title: Text(
                                  ramo.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Text(
                                  '${ramo.code}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                trailing: isSelected
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 24,
                                      )
                                    : null,
                                onTap: () {
                                  _toggleRamoSelection(ramo);
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
