class GabineteCategory {
  final String id;
  final String label;
  final String? description;
  final bool isActive;
  final int sortOrder;

  const GabineteCategory({
    required this.id,
    required this.label,
    this.description,
    this.isActive = true,
    this.sortOrder = 0,
  });

  GabineteCategory copyWith({
    String? id,
    String? label,
    String? description,
    bool? isActive,
    int? sortOrder,
  }) {
    return GabineteCategory(
        id: id ?? this.id, 
        label: label ?? this.label,
        description: description ?? this.description,
        isActive: isActive ?? this.isActive,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'description': description,
    'isActive': isActive,
    'sortOrder': sortOrder,
  };

  static GabineteCategory fromJson(Map<String, dynamic> json) {
    return GabineteCategory(
        id: json['id'] as String, 
        label: json['label'] as String,
        description: json['description'] as String?,
        isActive: (json['isActive'] as bool?) ?? true,
        sortOrder: (json['sortOrder'] as int?) ?? 0,
      );
  }
}