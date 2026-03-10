class BibleVerse {
  final int verse;
  final String text;

  BibleVerse ({
    required this.text,
    required this.verse,
  });

  factory BibleVerse.fromJson(Map<String, dynamic>json) {
    return BibleVerse(
      verse: json["verse"],      
      text: json["text"],
    );
  }
}