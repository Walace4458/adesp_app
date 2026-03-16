class Testimony {
  final String id;
  final String name;
  final String message;
  final DateTime date;
  int likes;

  Testimony({
    required this.id,
    required this.name,
    required this.message,
    required this.date,
    this.likes = 0,
  });
}