import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Necesario para formatear la hora

// Importamos el modelo StudyRoom que está en home_screen.dart
import 'home_screen.dart';

// --- COLORES DE STUDYMATCH ---
const Color primaryColor = Color(0xFF0560FA);
const Color secondaryColor = Color(0xFFEC8000);
const Color textColor = Color(0xFF3A3A3A);

// --- MODELO DE MENSAJE (Adaptación simplificada) ---
class ChatMessage {
  final String senderId;
  final String senderName;
  final String text;
  final Timestamp timestamp;

  ChatMessage.fromFirestore(DocumentSnapshot doc)
    : senderId = doc['senderId'] ?? '',
      senderName = doc['senderName'] ?? 'Anónimo',
      text = doc['text'] ?? '',
      timestamp = doc['timestamp'] ?? Timestamp.now();
}

// --- PANTALLA DE CHAT ---
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

  // Nombre del usuario actual para mostrar en el mensaje
  String _currentUserName = 'Usuario';

  @override
  void initState() {
    super.initState();
    // Carga el nombre del usuario desde Firestore
    _loadCurrentUserName();
  }

  // Función para cargar el nombre del usuario loggeado
  void _loadCurrentUserName() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        setState(() {
          // Asume que el nombre del usuario está en el campo 'name'
          _currentUserName = doc['name'] ?? 'Usuario';
        });
      }
    }
  }

  // Función para enviar el mensaje
  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    // Obtener la referencia a la colección de mensajes de la sala
    final roomMessagesRef = _firestore
        .collection('study_rooms')
        .doc(widget.room.id)
        .collection('messages');

    // Crea el objeto del mensaje
    await roomMessagesRef.add({
      'text': text,
      'senderId': userId,
      'senderName': _currentUserName,
      'timestamp':
          FieldValue.serverTimestamp(), // Usa el timestamp del servidor
    });

    // Limpia el campo de texto
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título de la sala: Código del Ramo y Tema
        title: Text(widget.room.name),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          // Área de mensajes (StreamBuilder para tiempo real)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('study_rooms')
                  .doc(widget.room.id)
                  .collection('messages')
                  // Ordenar por timestamp para mostrar el más reciente abajo
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

                // Si no hay mensajes
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Sé el primero en iniciar la conversación!'),
                  );
                }

                // Mapear documentos a objetos ChatMessage
                final messages = snapshot.data!.docs
                    .map((doc) => ChatMessage.fromFirestore(doc))
                    .toList();

                return ListView.builder(
                  reverse: true, // Muestra los mensajes de abajo hacia arriba
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

          // Campo de entrada de mensaje
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Widget para el campo de entrada de mensaje
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
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
}

// --- WIDGET PARA LA BURBUJA DE MENSAJE ---
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const _MessageBubble({required this.message, required this.isMe});

  // Formatea el Timestamp a una hora legible (Ej: 1:08 AM)
  String _formatTime(Timestamp timestamp) {
    // Maneja el caso en que el timestamp sea nulo (e.g., mensaje recién enviado sin serverTimestamp)
    if (timestamp == null) return '';
    final DateTime date = timestamp.toDate();
    return DateFormat('h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          // Nombre del remitente (solo si no es el usuario actual)
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

          // La burbuja de texto
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
              child: Text(
                message.text,
                style: TextStyle(
                  color: isMe ? Colors.white : textColor,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),

          // Hora del mensaje
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
