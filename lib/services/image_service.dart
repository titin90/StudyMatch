import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Servicio para gestionar la subida, compresión y eliminación de imágenes de perfil
/// usando Firebase Storage
class ImageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// Obtiene la referencia de Firebase Storage para la imagen de perfil
  Reference _getProfileImageRef(String userId, String fileName) {
    return _storage.ref().child('profile_images/$userId/$fileName');
  }

  /// Selecciona una imagen de la galería
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85, // Compresión para reducir tamaño
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error al seleccionar imagen: $e');
      return null;
    }
  }

  /// Toma una foto con la cámara
  Future<File?> takePhoto() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error al tomar foto: $e');
      return null;
    }
  }

  /// Sube la imagen de perfil a Firebase Storage y actualiza Firestore
  /// Retorna la URL de descarga o null si hay error
  Future<String?> uploadProfileImage(File imageFile, String userId) async {
    try {
      // Obtener extensión del archivo
      final String extension = imageFile.path.split('.').last.toLowerCase();
      final String fileName = 'profile.$extension';
      
      // Obtener la referencia de Storage
      final Reference storageRef = _getProfileImageRef(userId, fileName);
      
      // Subir el archivo a Firebase Storage
      final UploadTask uploadTask = storageRef.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/$extension',
          customMetadata: {
            'userId': userId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Esperar a que se complete la subida
      final TaskSnapshot snapshot = await uploadTask;
      
      // Obtener la URL de descarga
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      // Guardar la URL en Firestore
      await _firestore.collection('users').doc(userId).update({
        'profileImageUrl': downloadUrl,
        'profileImageUpdatedAt': FieldValue.serverTimestamp(),
      });

      return downloadUrl;
    } catch (e) {
      debugPrint('❌ Error al subir imagen a Firebase Storage: $e');
      return null;
    }
  }

  /// Elimina la imagen de perfil de Firebase Storage y Firestore
  Future<bool> deleteProfileImage(String userId) async {
    try {
      // Intentar eliminar diferentes extensiones posibles
      final extensions = ['jpg', 'jpeg', 'png', 'webp'];
      
      for (final ext in extensions) {
        try {
          final Reference storageRef = _getProfileImageRef(userId, 'profile.$ext');
          await storageRef.delete();
          break;
        } catch (storageError) {
          continue;
        }
      }

      // Actualizar Firestore
      await _firestore.collection('users').doc(userId).update({
        'profileImageUrl': null,
        'profileImageUpdatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      debugPrint('❌ Error al eliminar imagen: $e');
      return false;
    }
  }

  /// Muestra un diálogo para seleccionar entre cámara o galería
  Future<File?> showImageSourceDialog(BuildContext context) async {
    return await showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona una opción'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galería'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final file = await pickImageFromGallery();
                  if (context.mounted) {
                    Navigator.of(context).pop(file);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Cámara'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final file = await takePhoto();
                  if (context.mounted) {
                    Navigator.of(context).pop(file);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  /// Proceso completo: Seleccionar imagen, subir y actualizar perfil
  Future<String?> updateUserProfileImage(BuildContext context) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return null;

    // Mostrar diálogo de selección
    final File? imageFile = await showImageSourceDialog(context);
    if (imageFile == null) return null;

    // Mostrar indicador de carga
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Subir imagen
    final String? downloadUrl = await uploadProfileImage(imageFile, userId);

    // Cerrar indicador de carga
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    return downloadUrl;
  }

  /// Obtiene la URL de la imagen de perfil de un usuario
  Future<String?> getProfileImageUrl(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data()?['profileImageUrl'] as String?;
    } catch (e) {
      debugPrint('Error al obtener URL de imagen: $e');
      return null;
    }
  }
}
