class GabineteSlot {
  final DateTime start;
  final DateTime endExclusive;

  const GabineteSlot({
    required this.start,
    required this.endExclusive,
  });

  Duration get duration => endExclusive.difference(start);

  String get key => '${start.toIso8601String()}_${endExclusive.toIso8601String()}';

  Map<String, dynamic> toJson() => {
    'start': start.toIso8601String(),
    'endExclusive': endExclusive.toIso8601String(),
  };

  static GabineteSlot fromJson(Map<String, dynamic> json) {
    return GabineteSlot(
      start: DateTime.parse(json['start'] as String),
      endExclusive: DateTime.parse(json['endExclusive'] as String),
    );
  }
}
