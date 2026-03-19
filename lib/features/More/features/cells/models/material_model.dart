enum CellMaterialType { pdf, link, text }

class MaterialModel {
  final String id;
  final String title;
  final CellMaterialType type;
  final String content;

  MaterialModel({
    required this.id,
    required this.title,
    required this.type,
    required this.content,
  });
}