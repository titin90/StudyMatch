import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import 'home_screen.dart';

class RoomParticipantsScreen extends StatefulWidget {
  final StudyRoom room;

  const RoomParticipantsScreen({super.key, required this.room});

  @override
  State<RoomParticipantsScreen> createState() => _RoomParticipantsScreenState();
}

class _RoomParticipantsScreenState extends State<RoomParticipantsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, Map<String, dynamic>> _usersData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadParticipants();
  }

  // 🔥 EVITA TODOS LOS CRASHES CON scheduledTime
  DateTime _parseScheduled(dynamic value) {
    if (value == null) return DateTime.now();

    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;

    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {}
    }

    return DateTime.now();
  }

  String _formatScheduled(DateTime? d) {
    if (d == null) return 'No definida';
    return DateFormat('dd/MM/yyyy HH:mm').format(d);
  }

  Future<void> _loadParticipants() async {
    setState(() => _isLoading = true);
    try {
      final ids = widget.room.members;
      final futures = ids.map(
        (id) => _firestore.collection('users').doc(id).get(),
      );
      final snaps = await Future.wait(futures);
      final Map<String, Map<String, dynamic>> map = {};
      for (final s in snaps) {
        if (s.exists) {
          map[s.id] = s.data() as Map<String, dynamic>;
        } else {
          map[s.id] = {'name': 'Usuario', 'email': ''};
        }
      }
      setState(() {
        _usersData = map;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando participantes: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool get _isCreator => _auth.currentUser?.uid == widget.room.creatorId;

  // Delete all documents in a subcollection in batches (safe for large collections)
  Future<void> _deleteCollectionInBatches(CollectionReference collRef) async {
    const int batchSize = 500;
    while (true) {
      final snapshot = await collRef.limit(batchSize).get();
      final docs = snapshot.docs;
      if (docs.isEmpty) break;
      final batch = _firestore.batch();
      for (final d in docs) batch.delete(d.reference);
      await batch.commit();
      if (docs.length < batchSize) break;
    }
  }

  // Confirm with the user and delete the room and its messages
  Future<void> _confirmAndDeleteRoom() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar sala'),
        content: const Text(
          '¿Estás seguro? Esta acción eliminará la sala y todos sus mensajes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      // show a blocking loader
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
      }

      final roomDoc = _firestore.collection('study_rooms').doc(widget.room.id);
      final messagesCol = roomDoc.collection('messages');

      await _deleteCollectionInBatches(messagesCol);
      await roomDoc.delete();

      if (mounted) Navigator.of(context).pop(); // dismiss loader

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sala eliminada')));
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error eliminando sala: $e')));
    }
  }

  // Allow a non-creator user to leave the room (remove self from members)
  Future<void> _leaveRoom() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Salir de la sala'),
        content: const Text('¿Quieres salir de esta sala?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Salir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _firestore.collection('study_rooms').doc(widget.room.id).update({
        'members': FieldValue.arrayRemove([userId]),
      });

      setState(() {
        widget.room.members.remove(userId);
        _usersData.remove(userId);
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Has salido de la sala')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al salir de la sala: $e')),
        );
    }
  }

  String _getDisplayName(Map<String, dynamic>? user, String uid) {
    if (user == null) return uid.substring(0, 6);
    final possible = <String?>[
      user['name'] as String?,
      user['displayName'] as String?,
      user['fullName'] as String?,
      user['firstName'] != null && user['lastName'] != null
          ? '${user['firstName']} ${user['lastName']}'
          : null,
    ];
    for (final p in possible) {
      if (p != null && p.trim().isNotEmpty) return p.trim();
    }
    final email = user['email'] as String?;
    if (email != null && email.contains('@')) return email.split('@').first;
    return uid.substring(0, 6);
  }

  String _getInitials(String name) {
    final parts = name
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Future<void> _removeParticipant(String userId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar participante'),
        content: const Text(
          '¿Seguro que quieres eliminar a esta persona de la sala?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _firestore.collection('study_rooms').doc(widget.room.id).update({
        'members': FieldValue.arrayRemove([userId]),
      });
      setState(() {
        widget.room.members.remove(userId);
        _usersData.remove(userId);
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Participante eliminado')));
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
    }
  }

  Future<void> _editRoomInfo() async {
    final topicController = TextEditingController(text: widget.room.topic);
    final descriptionController = TextEditingController(
      text:
          widget.room.description ??
          (widget.room.rawData['description']?.toString() ?? ''),
    );

    String campus = widget.room.campus;
    String type = widget.room.isOnline ? 'Online' : 'Presencial';

    DateTime scheduled = _parseScheduled(widget.room.rawData['scheduledTime']);
    int capacity = (widget.room.rawData['capacity'] is int)
        ? widget.room.rawData['capacity'] as int
        : (int.tryParse(widget.room.rawData['capacity']?.toString() ?? '') ??
              8);

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setState2) {
          return AlertDialog(
            title: const Text('Editar información de la sala'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: topicController,
                    decoration: const InputDecoration(labelText: 'Tema'),
                  ),
                  const SizedBox(height: 8),
                  // Description editor (creator only)
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción breve',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: campus,
                    items: const [
                      DropdownMenuItem(
                        value: 'Campus San Joaquín',
                        child: Text('Campus San Joaquín'),
                      ),
                      DropdownMenuItem(
                        value: 'Campus Casa Central',
                        child: Text('Campus Casa Central'),
                      ),
                      DropdownMenuItem(
                        value: 'Campus Vitacura',
                        child: Text('Campus Vitacura'),
                      ),
                      DropdownMenuItem(
                        value: 'No Definido',
                        child: Text('No Definido'),
                      ),
                    ],
                    onChanged: (v) => setState2(() => campus = v ?? campus),
                    decoration: const InputDecoration(labelText: 'Campus'),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: type,
                    items: const [
                      DropdownMenuItem(value: 'Online', child: Text('Online')),
                      DropdownMenuItem(
                        value: 'Presencial',
                        child: Text('Presencial'),
                      ),
                    ],
                    onChanged: (v) => setState2(() => type = v ?? type),
                    decoration: const InputDecoration(labelText: 'Modalidad'),
                  ),
                  const SizedBox(height: 8),
                  // Capacity editor (moved to be below Modalidad)
                  TextFormField(
                    initialValue: capacity.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Capacidad máxima',
                    ),
                    onChanged: (v) {
                      final n = int.tryParse(v);
                      if (n != null && n > 0) {
                        capacity = n;
                      }
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Fecha: ${DateFormat('dd/MM/yyyy').format(scheduled)}',
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final DateTime today = DateTime.now();
                          final DateTime safeInitialDate =
                              scheduled.isBefore(today) ? today : scheduled;

                          final picked = await showDatePicker(
                            context: context,
                            initialDate: safeInitialDate,
                            firstDate: today,
                            lastDate: today.add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState2(() {
                              scheduled = DateTime(
                                picked.year,
                                picked.month,
                                picked.day,
                                scheduled.hour,
                                scheduled.minute,
                              );
                            });
                          }
                        },
                        child: const Text('Cambiar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Hora: ${DateFormat('HH:mm').format(scheduled)}',
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(scheduled),
                          );
                          if (t != null) {
                            setState2(() {
                              scheduled = DateTime(
                                scheduled.year,
                                scheduled.month,
                                scheduled.day,
                                t.hour,
                                t.minute,
                              );
                            });
                          }
                        },
                        child: const Text('Cambiar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await _firestore
                        .collection('study_rooms')
                        .doc(widget.room.id)
                        .update({
                          'topic': topicController.text.trim(),
                          'description': descriptionController.text.trim(),
                          'campus': campus,
                          'type': type,
                          'scheduledTime': Timestamp.fromDate(scheduled),
                          'capacity': capacity,
                        });

                    setState(() {
                      widget.room.rawData['topic'] = topicController.text
                          .trim();
                      widget.room.rawData['description'] = descriptionController
                          .text
                          .trim();
                      widget.room.rawData['campus'] = campus;
                      widget.room.rawData['type'] = type;
                      widget.room.rawData['scheduledTime'] = Timestamp.fromDate(
                        scheduled,
                      );
                      widget.room.rawData['capacity'] = capacity;
                    });

                    Navigator.of(ctx).pop(true);
                  } catch (e) {
                    if (mounted)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al guardar: $e')),
                      );
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      ),
    );

    if (result == true) {
      await _loadParticipants();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduledDate = _parseScheduled(widget.room.rawData['scheduledTime']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Participantes'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (_isCreator)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _editRoomInfo,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: secondaryColor,
                  onPressed: _confirmAndDeleteRoom,
                ),
              ],
            ),
          if (!_isCreator)
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              color: secondaryColor,
              onPressed: _leaveRoom,
              tooltip: 'Salir de la sala',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadParticipants,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.room.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16),
                              const SizedBox(width: 6),
                              Text('Fecha: ${_formatScheduled(scheduledDate)}'),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16),
                              const SizedBox(width: 6),
                              Text('Campus: ${widget.room.campus}'),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.wifi, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'Modalidad: ${widget.room.isOnline ? 'Online' : 'Presencial'}',
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.people, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'Participantes: ${widget.room.members.length}${widget.room.capacity != null ? '/${widget.room.capacity}' : ''}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Miembros',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...widget.room.members.map((id) {
                    final user = _usersData[id];
                    final displayName = _getDisplayName(user, id);
                    final email = user?['email'] as String? ?? '';
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(_getInitials(displayName)),
                        ),
                        title: Text(displayName),
                        subtitle: email.isNotEmpty ? Text(email) : null,
                        trailing: _isCreator && id != widget.room.creatorId
                            ? IconButton(
                                icon: const Icon(Icons.remove_circle),
                                color: secondaryColor,
                                onPressed: () => _removeParticipant(id),
                              )
                            : (id == widget.room.creatorId
                                  ? const Chip(label: Text('Creador'))
                                  : null),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
    );
  }
}
