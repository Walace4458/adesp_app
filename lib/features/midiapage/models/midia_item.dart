
class MidiaItem  {
  final String id;
  final String title;
  final String subtitle;
  final String thumbnail;
  final Set<MidiaTag> tags;

  const MidiaItem({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.subtitle,
    required this.tags,
  });
}

enum MidiaTag { featured, popular, continueWatching }