enum AgendaCategory {
  culto,
  jovens,
  celula,
  evento,
  ensaio,
  outro,
}

class AgendaEvent {
  final String id;
  final String title;
  final DateTime startAt;
  final DateTime? endAt;
  final String location;
  final String description;
  final AgendaCategory category;
  final bool isFeatured;
  final String? bannerUrl;
  final String? link;

  const AgendaEvent({
    required this.id,
    required this.title,
    required this.startAt,
    this.endAt,
    required this.location,
    required this.description,
    required this.category,
    this.isFeatured = false,
    this.bannerUrl,
    this.link,
  });
}