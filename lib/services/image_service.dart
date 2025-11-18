import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Servicio para gestionar la subida, compresión y eliminación de imágenes de perfil
/// VERSIÓN LOCAL: Las imágenes se guardan en el almacenamiento local del dispositivo
/// hasta que Firebase Storage esté disponible
class ImageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  /// Obtiene el directorio donde se guardarán las fotos de perfil
  Future<Directory> _getProfileImagesDirectory() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final Directory profileImagesDir = Directory('${appDocDir.path}/profile_images');
    
    // Crear directorio si no existe
    if (!await profileImagesDir.exists()) {
      await profileImagesDir.create(recursive: true);
    }
    
    return profileImagesDir;
  }

  /// Obtiene la ruta local de la imagen de perfil de un usuario
  Future<String> _getLocalImagePath(String userId) async {
    final Directory dir = await _getProfileImagesDirectory();
    return '${dir.path}/$userId.jpg';
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

  /// Sube la imagen de perfil al almacenamiento LOCAL y actualiza Firestore
  /// Retorna la ruta local de la imagen o null si hay error
  Future<String?> uploadProfileImage(File imageFile, String userId) async {
    try {
      // Obtener la ruta local donde guardar la imagen
      final String localPath = await _getLocalImagePath(userId);
      
      // Copiar el archivo a la ubicación local
      await imageFile.copy(localPath);
      
      // Guardar la ruta local en Firestore
      await _firestore.collection('users').doc(userId).update({
        'profileImageUrl': localPath, // Guardamos la ruta local
        'profileImageUpdatedAt': FieldValue.serverTimestamp(),
        'isLocalImage': true, // Flag para saber que es local
      });

      debugPrint('✅ Imagen guardada localmente en: $localPath');
      return localPath;
    } catch (e) {
      debugPrint('❌ Error al guardar imagen localmente: $e');
      return null;
    }
  }

  /// Elimina la imagen de perfil LOCAL del usuario
  Future<bool> deleteProfileImage(String userId) async {
    try {
      // Eliminar archivo local
      final String localPath = await _getLocalImagePath(userId);
      final File imageFile = File(localPath);
      
      if (await imageFile.exists()) {
        await imageFile.delete();
        debugPrint('✅ Imagen local eliminada: $localPath');
      }

      // Actualizar Firestore
      await _firestore.collection('users').doc(userId).update({
        'profileImageUrl': null,
        'profileImageUpdatedAt': FieldValue.serverTimestamp(),
        'isLocalImage': null,
      });

      return true;
    } catch (e) {
      debugPrint('❌ Error al eliminar imagen: $e');
      // Intentar actualizar Firestore aunque falle la eliminación local
      try {
        await _firestore.collection('users').doc(userId).update({
          'profileImageUrl': null,
          'profileImageUpdatedAt': FieldValue.serverTimestamp(),
          'isLocalImage': null,
        });
        return true;
      } catch (firestoreError) {
        debugPrint('❌ Error al actualizar Firestore: $firestoreError');
        return false;
      }
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
