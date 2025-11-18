import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar avatares con foto de perfil
/// Si el usuario tiene foto, la muestra; si no, muestra iniciales
class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String displayName;
  final double radius;
  final Color backgroundColor;
  final Color textColor;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    required this.displayName,
    this.radius = 20,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
  });

  String _getInitials(String name) {
    final parts = name
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
          ? NetworkImage(imageUrl!)
          : null,
      child: imageUrl == null || imageUrl!.isEmpty
          ? Text(
              _getInitials(displayName),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: radius * 0.6,
              ),
            )
          : null,
    );
  }
}

/// Widget para avatar con indicador de edición
class EditableProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String displayName;
  final double radius;
  final Color backgroundColor;
  final VoidCallback onTap;

  const EditableProfileAvatar({
    super.key,
    this.imageUrl,
    required this.displayName,
    required this.onTap,
    this.radius = 60,
    this.backgroundColor = Colors.blue,
  });

  String _getInitials(String name) {
    final parts = name
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: backgroundColor,
          backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
              ? NetworkImage(imageUrl!)
              : null,
          child: imageUrl == null || imageUrl!.isEmpty
              ? Text(
                  _getInitials(displayName),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: radius * 0.5,
                  ),
                )
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.camera_alt,
                size: radius * 0.3,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
