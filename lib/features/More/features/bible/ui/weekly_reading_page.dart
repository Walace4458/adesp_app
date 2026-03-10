import 'package:flutter/material.dart';

import '../data/reading_plan_repository.dart';

class WeeklyReadingPage extends StatelessWidget{
  const WeeklyReadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ReadingPlanRepository();
    final readings = repository.getWeeklyPlan();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leitura da Semana"),
      ),

      body: ListView.builder(
        itemCount: readings.length,
        itemBuilder: (context, index) {
          final reading = readings[index];
          return ListTile (
            leading: const Icon(Icons.menu_book_rounded),
            title: Text("${reading.book} ${reading.chapter}"),
            subtitle: Text(reading.day), 
          );
        }
      )
    );
  }
}