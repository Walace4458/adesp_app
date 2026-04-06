import 'package:flutter/material.dart';

class GabineteRules {
  // =========================
  // CONFIG GERAL
  // =========================
  static const int maxActiveRequestsPerUser = 2;
  static const int maxDaysInFuture = 30;

  // Apenas terça e quinta
  static const Set<int> allowedWeekdays = {
    DateTime.tuesday,
    DateTime.thursday,
  };

  // =========================
  // HORÁRIOS DISPONÍVEIS
  // =========================
  static List<TimeOfDay> generateSlots() {
    final slots = <TimeOfDay>[];

    // Manhã → 09:00 até 11:00
    for (int h = 9; h < 12; h++) {
      slots.add(TimeOfDay(hour: h, minute: 0));
    }

    // Tarde → 14:00 até 17:00
    for (int h = 14; h < 18; h++) {
      slots.add(TimeOfDay(hour: h, minute: 0));
    }

    return slots;
  }

  // =========================
  // CONVERTE PRA DATETIME
  // =========================
  static DateTime toDateTime(DateTime day, TimeOfDay time) {
    return DateTime(
      day.year,
      day.month,
      day.day,
      time.hour,
      time.minute,
    );
  }

  // =========================
  // SLOT JÁ PASSOU?
  // =========================
  static bool isPast(DateTime slotDateTime) {
    return slotDateTime.isBefore(DateTime.now());
  }

  // =========================
  // DIA É PERMITIDO?
  // =========================
  static bool isAllowedDay(DateTime date) {
    return allowedWeekdays.contains(date.weekday);
  }

  // =========================
  // LIMITE FUTURO
  // =========================
  static bool isWithinAllowedRange(DateTime date) {
    final now = DateTime.now();
    final maxDate = now.add(const Duration(days: maxDaysInFuture));

    return !date.isAfter(maxDate);
  }
}