import 'gabinete_ids.dart';

/// “Cadastro” mínimo que você quer criar automaticamente se não existir.
/// Pode crescer depois (endereço, data nascimento, etc).
class GabineteMember {
  final GabineteMemberId id;

  /// userId do auth (se existir). Pode ser null em casos importados.
  final String? userId;

  final String name;
  final String whatsapp;

  /// Criado automaticamente pelo módulo gabinete.
  final DateTime createdAt;

  const GabineteMember({
    required this.id,
    required this.name,
    required this.whatsapp,
    required this.createdAt,
    this.userId,
  });

  GabineteMember copyWith({
    GabineteMemberId? id,
    String? userId,
    String? name,
    String? whatsapp,
    DateTime? createdAt,
  }) {
    return GabineteMember(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      whatsapp: whatsapp ?? this.whatsapp,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.value,
        'userId': userId,
        'name': name,
        'whatsapp': whatsapp,
        'createdAt': createdAt.toIso8601String(),
      };

  static GabineteMember fromJson(Map<String, dynamic> json) {
    return GabineteMember(
      id: GabineteMemberId(json['id'] as String),
      userId: json['userId'] as String?,
      name: json['name'] as String,
      whatsapp: json['whatsapp'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}