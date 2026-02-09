import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String dateLabel;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.dateLabel,
    this.isRead = false,
  });
}