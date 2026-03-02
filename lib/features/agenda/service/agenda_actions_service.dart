import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/agenda_event.dart';

class AgendaActionsService {
  const AgendaActionsService();

  Future<void> shareEvent(BuildContext context, AgendaEvent event) async {
    final text = _buildShareText(event);

    final box = context.findRenderObject() as RenderBox?;

    await SharePlus.instance.share(
      ShareParams(
      text: text,
      sharePositionOrigin: box == null ? null : (box.localToGlobal(Offset.zero) & box.size),
    ));
  }

  Future<bool> addToCalendar(AgendaEvent event) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return false;
  }

  Future<bool> confirmPresence(AgendaEvent event) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return true;
  }

  String _buildShareText(AgendaEvent event) {
    final d = event.startAt;
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');

    final dateText = '${d.day.toString().padLeft(2, '0')}/'
    '${d.month.toString().padLeft(2, '0')}/'
    '${d.year}';
    final timeText = '$hh:$mm';

    final buffer = StringBuffer()
     ..writeln(event.title)
     ..writeln('$dateText • $timeText');

     if (event.location.isNotEmpty) {
      buffer.writeln('Local: ${event.location}');
     }

     if (event.description.isNotEmpty) {
      buffer.writeln('');
      buffer.writeln(event.description);
     }

     return buffer.toString().trim();
  }
}