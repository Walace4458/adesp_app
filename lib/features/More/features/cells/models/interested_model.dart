enum InterestedStatus { novo, visitou, membro }

class InterestedModel {
  final String id;
  final String name;
  final InterestedStatus status;

  InterestedModel({
    required this.id,
    required this.name,
    required this.status,
  });
}