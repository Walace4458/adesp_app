class ReadingPlan {
  final String id;
  final String title;
  final String day;
  final String book;
  final int chapter;
  final String? description;
  final String? comment;
  final double progress;
  final bool completed;

  ReadingPlan ({
    required this.id,
    required this.title,
    required this.day,
    required this.book,
    required this.chapter,
    this.description,
    this.comment,
    this.progress = 0.0,
    this.completed = false,
  });
}