import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// 💡 CORRECCIÓN DE DEPENDENCIA: Usamos la data existente en ramo_data.dart
import 'ramo_data.dart'; // Asegúrate de que este archivo contenga la lista 'allRamos'

// Colores definidos para consistencia
const Color primaryColor = Color(0xFF0560FA);
const Color secondaryColor = Color(0xFFEC8000);
const Color textColor = Color(0xFF3A3A3A);

// Renombramos la clase y la hacemos StateFul para manejar la selección de ramos
class RamoSelectionScreen extends StatefulWidget {
  // Parámetros originales de la pantalla, que serán pasados por la pantalla de perfil.
  final String careerId;
  final String careerName;

  // Nueva lógica para inicializar: la lista de códigos de ramos ya seleccionados.
  final List<String> initialRamos;

  // Ajuste: Ahora requerimos 'initialRamos' para inicializar el estado
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
  // 1. Estado local: Usamos un Set para almacenar los códigos de los ramos seleccionados
  late Set<String> _selectedRamos;
  bool _isSaving = false; // Estado para controlar el guardado en Firebase

  @override
  void initState() {
    super.initState();
    // Inicializamos el Set con la lista que viene por parámetro (initialRamos)
    _selectedRamos = Set<String>.from(widget.initialRamos);
  }

  // FUNCIÓN REQUERIDA POR CANVAS: Genera la ruta de 6 segmentos del documento de perfil
  String _getProfileDocPath(String uid) {
    // Definición de __app_id
    // Usamos el global __app_id si está definido, sino usamos un default.
    const appId = String.fromEnvironment(
      'APP_ID',
      defaultValue: 'default-app-id',
    );
    // 💡 IMPORTANTE: Cumplimos con la estructura de seguridad de Canvas
    return 'artifacts/$appId/users/$uid/profile_data/data';
  }

  // Función para obtener los ramos filtrados por carrera (usa la lista de ramos definida en ramo_data.dart)
  List<Ramo> getFilteredSubjects() {
    // 🚀 CORRECCIÓN CLAVE: Filtramos la lista CONSOLIDADA 'allRamos' por el ID de la carrera.
    return allRamos.where((ramo) => ramo.careerId == widget.careerId).toList();
  }

  // 2. Lógica de guardado en Firebase (se dispara en cada toggle)
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

      // 💡 CORRECCIÓN DE RUTA FIREBASE: Usamos la ruta Canvas (docPath) y el método SET con MERGE
      await FirebaseFirestore.instance.doc(docPath).set({
        // El campo en Firestore debe llamarse 'current_ramos' para coincidir con el UserProfile
        'current_ramos': ramosToSave,
      }, SetOptions(merge: true));

      if (mounted) {
        // Muestra un indicador de guardado breve
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

  // 3. Lógica para alternar la selección (local y en Firebase)
  void _toggleRamoSelection(Ramo ramo) {
    setState(() {
      if (_selectedRamos.contains(ramo.code)) {
        // Deseleccionar
        _selectedRamos.remove(ramo.code);
      } else {
        // Seleccionar
        _selectedRamos.add(ramo.code);
      }
    });

    // Guardar los cambios en Firebase inmediatamente
    _updateRamosInFirestore();
  }

  // 4. Agrupa los ramos por año para la UI (usando la propiedad 'year' del objeto Ramo)
  Map<String, List<Ramo>> _groupRamosByYear(List<Ramo> allRamos) {
    Map<String, List<Ramo>> ramosByYear = {};
    for (var ramo in allRamos) {
      if (!ramosByYear.containsKey(ramo.year)) {
        ramosByYear[ramo.year] = [];
      }
      ramosByYear[ramo.year]!.add(ramo);
    }

    // Ordenar las llaves (años) numéricamente
    return Map.fromEntries(
      ramosByYear.entries.toList()
        ..sort((a, b) => double.parse(a.key).compareTo(double.parse(b.key))),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos la lista filtrada de ramos y los agrupamos por año
    final allRamos = getFilteredSubjects();
    final ramosByYear = _groupRamosByYear(allRamos);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ramos de ${widget.careerName}'),
        backgroundColor: primaryColor, // Usamos la constante
        foregroundColor: Colors.white,
        actions: [
          // Muestra un indicador de guardado si _isSaving es true
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
              // Iteramos sobre los años agrupados (ExpansionTile)
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
                    initiallyExpanded:
                        year == '1', // Expande el año 1 por defecto
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
                    // Listamos los ramos individuales dentro del año (ListTile)
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
                          // Llama a la función de alternado y guardado automático
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
