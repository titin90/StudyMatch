import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:studyapp/services/file_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import 'home_screen.dart';
import 'room_participants_screen.dart';

// Modelo de mensaje
class ChatMessage {
  final String senderId;
  final String senderName;
  final String text;
  final Timestamp timestamp;
  final String type;
  final String? fileUrl;

  ChatMessage.fromFirestore(DocumentSnapshot doc)
      : senderId = (doc.data() as Map<String, dynamic>)['senderId'] ?? '',
        senderName = (doc.data() as Map<String, dynamic>)['senderName'] ?? 'Anónimo',
        text = (doc.data() as Map<String, dynamic>)['text'] ?? '',
        timestamp = (doc.data() as Map<String, dynamic>)['timestamp'] ?? Timestamp.now(),
        type = (doc.data() as Map<String, dynamic>)['type'] ?? 'text',
        fileUrl = (doc.data() as Map<String, dynamic>)['fileUrl'];
}

// Pantalla de chat
class ChatRoomScreen extends StatefulWidget {
  final StudyRoom room;

  const ChatRoomScreen({super.key, required this.room});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FileService _fileService = FileService();
  String _currentUserName = 'Usuario';
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserName();
  }

  // Carga el nombre del usuario
  void _loadCurrentUserName() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        setState(() {
          _currentUserName = doc['name'] ?? 'Usuario';
        });
      }
    }
  }

  // Envía un mensaje
  void _sendMessage() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    // Si hay un archivo seleccionado, súbelo y envía el mensaje de archivo
    if (_selectedFile != null) {
      final String? downloadUrl =
          await _fileService.uploadFile(_selectedFile!, widget.room.id);

      if (downloadUrl != null) {
        final roomMessagesRef = _firestore
            .collection('study_rooms')
            .doc(widget.room.id)
            .collection('messages');

        await roomMessagesRef.add({
          'text': _messageController.text.trim(),
          'senderId': userId,
          'senderName': _currentUserName,
          'timestamp': FieldValue.serverTimestamp(),
          'type': 'file',
          'fileUrl': downloadUrl,
        });

        setState(() {
          _selectedFile = null;
        });
        _messageController.clear();
      }
      return;
    }

    // Si no hay archivo, envía un mensaje de texto normal
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final roomMessagesRef = _firestore
        .collection('study_rooms')
        .doc(widget.room.id)
        .collection('messages');

    await roomMessagesRef.add({
      'text': text,
      'senderId': userId,
      'senderName': _currentUserName,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
    });

    _messageController.clear();
  }

  void _pickFile() async {
    final file = await _fileService.pickFile();
    if (file != null) {
      setState(() {
        _selectedFile = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RoomParticipantsScreen(room: widget.room)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Área de mensajes
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('study_rooms')
                  .doc(widget.room.id)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error al cargar mensajes: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Sé el primero en iniciar la conversación!'),
                  );
                }

                final messages = snapshot.data!.docs
                    .map((doc) => ChatMessage.fromFirestore(doc))
                    .toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _MessageBubble(
                      message: messages[index],
                      isMe: messages[index].senderId == _auth.currentUser?.uid,
                    );
                  },
                );
              },
            ),
          ),
          if (_selectedFile != null) _buildFilePreview(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Campo de entrada de mensaje
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: _pickFile,
            color: primaryColor,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Escribe tu mensaje...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8.0),

          // Botón de envío
          FloatingActionButton(
            onPressed: _sendMessage,
            backgroundColor: primaryColor,
            elevation: 0,
            mini: true,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePreview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Icon(Icons.insert_drive_file, color: Colors.grey[700]),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                _selectedFile!.path.split('/').last,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _selectedFile = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para la burbuja de mensaje
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const _MessageBubble({required this.message, required this.isMe});

  // Formatea el Timestamp a hora legible
  String _formatTime(Timestamp timestamp) {
    final DateTime date = timestamp.toDate();
    return DateFormat('h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isFile = message.type == 'file';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0, left: 8.0),
              child: Text(
                message.senderName,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Material(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15.0),
              topRight: const Radius.circular(15.0),
              bottomLeft: isMe
                  ? const Radius.circular(15.0)
                  : const Radius.circular(0.0),
              bottomRight: isMe
                  ? const Radius.circular(0.0)
                  : const Radius.circular(15.0),
            ),
            elevation: 1,
            color: isMe ? primaryColor : Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 15.0,
              ),
              child: isFile
                  ? InkWell(
                      onTap: () async {
                        if (message.fileUrl != null) {
                          final Uri url = Uri.parse(message.fileUrl!);
                          if (!await launchUrl(url)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No se pudo abrir el archivo'),
                              ),
                            );
                          }
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.insert_drive_file,
                                  color: isMe ? Colors.white : textColor),
                              const SizedBox(width: 8),
                              Text(
                                'Ver archivo',
                                style: TextStyle(
                                  color: isMe ? Colors.white : textColor,
                                  fontSize: 15.0,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                          if (message.text.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                message.text,
                                style: TextStyle(
                                  color: isMe ? Colors.white : textColor,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  : Text(
                      message.text,
                      style: TextStyle(
                        color: isMe ? Colors.white : textColor,
                        fontSize: 15.0,
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              _formatTime(message.timestamp),
              style: TextStyle(fontSize: 10.0, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
