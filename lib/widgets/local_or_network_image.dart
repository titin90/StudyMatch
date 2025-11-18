import 'dart:io';
import 'package:flutter/material.dart';

/// Widget para mostrar imágenes que pueden ser locales (File) o de red (URL)
class LocalOrNetworkImage extends StatelessWidget {
  final String? imagePath;
  final double radius;
  final Widget? placeholder;
  final Color backgroundColor;

  const LocalOrNetworkImage({
    super.key,
    this.imagePath,
    this.radius = 60,
    this.placeholder,
    this.backgroundColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay imagen, mostrar placeholder
    if (imagePath == null || imagePath!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        child: placeholder,
      );
    }

    // Verificar si es una ruta local (archivo del sistema)
    final bool isLocalFile = !imagePath!.startsWith('http') && !imagePath!.startsWith('https');

    if (isLocalFile) {
      // Imagen local - usar FileImage
      final File imageFile = File(imagePath!);
      
      return FutureBuilder<bool>(
        future: imageFile.exists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircleAvatar(
              radius: radius,
              backgroundColor: backgroundColor,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            );
          }

          if (snapshot.data == true) {
            return CircleAvatar(
              radius: radius,
              backgroundColor: backgroundColor,
              backgroundImage: FileImage(imageFile),
            );
          }

          // Si el archivo no existe, mostrar placeholder
          return CircleAvatar(
            radius: radius,
            backgroundColor: backgroundColor,
            child: placeholder,
          );
        },
      );
    } else {
      // Imagen de red - usar NetworkImage
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        backgroundImage: NetworkImage(imagePath!),
        onBackgroundImageError: (exception, stackTrace) {
          debugPrint('Error al cargar imagen de red: $exception');
        },
        child: null,
      );
    }
  }
}
