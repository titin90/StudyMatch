import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/colors.dart';
import '../ramo_data.dart';

class ExploreRamosScreen extends StatefulWidget {
  final String? userCareerId;
  final String? userCareerName;
  
  const ExploreRamosScreen({
    super.key,
    this.userCareerId,
    this.userCareerName,
  });

  @override
  State<ExploreRamosScreen> createState() => _ExploreRamosScreenState();
}

class _ExploreRamosScreenState extends State<ExploreRamosScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  
  String? _selectedUniversity;
  String? _selectedCareer;
  List<String> _addedRamosCodes = [];
  bool _isLoading = true;

  final Map<String, String> _universityNames = {
    'USM': 'Universidad Técnica Federico Santa María',
    'UC': 'Pontificia Universidad Católica',
    'UCHILE': 'Universidad de Chile',
    'USACH': 'Universidad de Santiago',
  };

  final Map<String, List<String>> _universityCareers = {
    'USM': [
      'USM-CIV-INF',
      'USM-CIV-IND',
      'USM-CIV-ELE',
      'USM-CIV-MEC',
    ],
    'UC': [
      'UC-CC',
      'UC-DER',
      'UC-CIV',
      'UC-MED',
    ],
    'UCHILE': [
      'UCHILE-CIV-INF',
      'UCHILE-CIV-IND',
      'UCHILE-COM',
      'UCHILE-MED',
    ],
    'USACH': [
      'USACH-CIV-INF',
      'USACH-CIV-IND',
      'USACH-COM',
      'USACH-CIV-MIN',
    ],
  };

  final Map<String, String> _careerNames = {
    'USM-CIV-INF': 'Ing. Civil Informática',
    'USM-CIV-IND': 'Ing. Civil Industrial',
    'USM-CIV-ELE': 'Ing. Civil Eléctrica',
    'USM-CIV-MEC': 'Ing. Civil Mecánica',
    'UC-CC': 'Ciencia de la Computación',
    'UC-DER': 'Derecho',
    'UC-CIV': 'Ing. Civil',
    'UC-MED': 'Medicina',
    'UCHILE-CIV-INF': 'Ing. Civil Informática',
    'UCHILE-CIV-IND': 'Ing. Civil Industrial',
    'UCHILE-COM': 'Ing. Comercial',
    'UCHILE-MED': 'Medicina',
    'USACH-CIV-INF': 'Ing. Civil Informática',
    'USACH-CIV-IND': 'Ing. Civil Industrial',
    'USACH-COM': 'Ing. Comercial',
    'USACH-CIV-MIN': 'Ing. Civil en Minas',
  };

  String _getRamosDocPath(String uid) {
    const appId = String.fromEnvironment(
      'APP_ID',
      defaultValue: 'default-app-id',
    );
    return 'artifacts/$appId/users/$uid/profile_data/data';
  }

  @override
  void initState() {
    super.initState();
    _initializeWithUserCareer();
    _loadCurrentRamos();
  }

  void _initializeWithUserCareer() {
    if (widget.userCareerId != null) {
      // Extraer universidad del careerId (formato: USM-CIV-INF)
      final parts = widget.userCareerId!.split('-');
      if (parts.isNotEmpty) {
        final university = parts[0];
        setState(() {
          _selectedUniversity = university;
          _selectedCareer = widget.userCareerId;
        });
      }
    }
  }

  Future<void> _loadCurrentRamos() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      final ramosDocPath = _getRamosDocPath(userId);
      final ramosDoc = await _firestore.doc(ramosDocPath).get();
      final ramosData = ramosDoc.data();

      if (mounted) {
        setState(() {
          _addedRamosCodes = (ramosData?['current_ramos'] as List<dynamic>?)
                  ?.cast<String>()
                  .toList() ??
              [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar ramos: $e')),
        );
      }
    }
  }

  Future<void> _toggleRamo(String ramoCode) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      final ramosDocPath = _getRamosDocPath(userId);
      
      // Recargar lista actual para evitar duplicados
      final ramosDoc = await _firestore.doc(ramosDocPath).get();
      final ramosData = ramosDoc.data();
      final currentList = (ramosData?['current_ramos'] as List<dynamic>?)
              ?.cast<String>()
              .toList() ??
          [];
      
      final newList = List<String>.from(currentList);

      if (newList.contains(ramoCode)) {
        newList.remove(ramoCode);
      } else {
        // Verificar nuevamente antes de agregar
        if (!newList.contains(ramoCode)) {
          newList.add(ramoCode);
        }
      }

      await _firestore.doc(ramosDocPath).set({
        'current_ramos': newList,
      }, SetOptions(merge: true));

      setState(() {
        _addedRamosCodes = newList;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newList.contains(ramoCode) ? 'Ramo agregado' : 'Ramo eliminado',
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  List<Ramo> _getFilteredRamos() {
    if (_selectedCareer == null) return [];
    final ramos = getRamosForCareer(_selectedCareer!);
    // Ordenar por año y luego por semestre
    ramos.sort((a, b) {
      if (a.year != b.year) {
        return a.year.compareTo(b.year);
      }
      return a.semester.compareTo(b.semester);
    });
    return ramos;
  }

  Map<String, Map<String, List<Ramo>>> _groupRamosByYearAndSemester() {
    final ramos = _getFilteredRamos();
    final Map<String, Map<String, List<Ramo>>> grouped = {};

    for (var ramo in ramos) {
      final yearKey = 'Año ${ramo.year}';
      final semesterKey = 'Semestre ${ramo.semester}';

      if (!grouped.containsKey(yearKey)) {
        grouped[yearKey] = {};
      }
      if (!grouped[yearKey]!.containsKey(semesterKey)) {
        grouped[yearKey]![semesterKey] = [];
      }
      grouped[yearKey]![semesterKey]!.add(ramo);
    }

    return grouped;
  }

  List<Widget> _buildGroupedRamosList() {
    final grouped = _groupRamosByYearAndSemester();
    final List<Widget> widgets = [];

    grouped.forEach((year, semesters) {
      // Calcular total de ramos en el año
      int totalRamosYear = 0;
      semesters.forEach((_, ramosList) {
        totalRamosYear += ramosList.length;
      });

      widgets.add(
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ExpansionTile(
            initiallyExpanded: false, // Todo cerrado inicialmente
            leading: const Icon(
              Icons.calendar_today,
              color: primaryColor,
            ),
            title: Text(
              year,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            subtitle: Text('$totalRamosYear ramos disponibles'),
            children: semesters.entries.map((semesterEntry) {
              final semester = semesterEntry.key;
              final ramosList = semesterEntry.value;

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
                    initiallyExpanded: false, // Todo cerrado inicialmente
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Icon(
                      Icons.book_outlined,
                      color: secondaryColor,
                      size: 20,
                    ),
                    title: Text(
                      semester,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      '${ramosList.length} ramos',
                      style: const TextStyle(fontSize: 12),
                    ),
                    children: ramosList.map((ramo) {
                      final isAdded = _addedRamosCodes.contains(ramo.code);
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
                          '${ramo.code} • ${ramo.credits} créditos',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isAdded ? Icons.remove_circle : Icons.add_circle,
                            color: isAdded ? Colors.red : primaryColor,
                          ),
                          onPressed: () => _toggleRamo(ramo.code),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userCareerName != null 
            ? 'Explorar Ramos'
            : 'Explorar Ramos'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : Column(
              children: [
                // Filtros
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userCareerId != null 
                            ? 'Gestiona tus ramos o explora otras carreras'
                            : 'Explorar ramos de otras carreras',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Universidad
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Universidad',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.school),
                        ),
                        isExpanded: true,
                        value: _selectedUniversity,
                        items: _universityCareers.keys.map((uni) {
                          return DropdownMenuItem(
                            value: uni,
                            child: Text(
                              _universityNames[uni] ?? uni,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedUniversity = value;
                            _selectedCareer = null;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      // Carrera
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Carrera',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.engineering),
                        ),
                        value: _selectedCareer,
                        items: _selectedUniversity == null
                            ? []
                            : _universityCareers[_selectedUniversity]!
                                .map((careerId) {
                                return DropdownMenuItem(
                                  value: careerId,
                                  child: Text(_careerNames[careerId] ?? careerId),
                                );
                              }).toList(),
                        onChanged: _selectedUniversity == null
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedCareer = value;
                                });
                              },
                      ),
                    ],
                  ),
                ),

                // Lista de ramos
                Expanded(
                  child: _selectedCareer == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Selecciona una universidad y carrera',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : _getFilteredRamos().isEmpty
                          ? Center(
                              child: Text(
                                'No hay ramos disponibles',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            )
                          : ListView(
                              padding: const EdgeInsets.all(16),
                              children: _buildGroupedRamosList(),
                            ),
                ),
              ],
            ),
    );
  }
}
