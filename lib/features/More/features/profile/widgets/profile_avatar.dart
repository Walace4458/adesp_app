import 'dart:io';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget{
  final String? imagePath;
  final String name;
  final VoidCallback onTap;

  const ProfileAvatar({
    super.key,
    required this.imagePath,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 35,
        backgroundImage: imagePath != null ? FileImage(File(imagePath!)) : null,
        child: imagePath == null
        ? Text(
          name.isEmpty ? "?" : name[0].toUpperCase(),
          style: const TextStyle(fontSize: 22),
        )
        : null,
      ),
    );
  }
}