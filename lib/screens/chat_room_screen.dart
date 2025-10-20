import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'home_screen.dart';

const Color primaryColor = Color(0xFF0560FA);
const Color secondaryColor = Color(0xFFEC8000);
const Color textColor = Color(0xFF3A3A3A);

// Modelo de mensaje
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
  String _currentUserName = 'Usuario';

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
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final roomMessagesRef = _firestore
        .collection('study_rooms')
        .doc(widget.room.id)
        .collection('messages');

    await roomMessagesRef.add({
      'text': text,
      'senderId': userId,
      'senderName': _currentUserName,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
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

          // Burbuja de texto
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
