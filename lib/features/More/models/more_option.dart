import 'package:flutter/material.dart';

class MoreOption {
  final String title;
  final IconData icon;
  final Widget page;

  MoreOption({
    required this.icon,
    required this.page,
    required this.title,
  });
}