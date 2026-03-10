import '../models/reading_plan.dart';

class ReadingPlanRepository {
  List<ReadingPlan> getWeeklyPlan(){
    return [
      ReadingPlan(
        day: "Segunda",
        book: "João", 
        chapter: 3,
      ),

        ReadingPlan(
        day: "Terça",
        book: "Salmos", 
        chapter: 23, 
      ),

      ReadingPlan(
        day: "Quarta",
        book: "Romanos", 
        chapter: 8, 
      ),

      ReadingPlan(
        day: "Quinta",
        book: "Mateus", 
        chapter: 5, 
      ),

      ReadingPlan(
        day: "Sexta",
        book: "Efésios", 
        chapter: 6, 
      ),
    ];
  }
}