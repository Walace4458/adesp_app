enum CardBrand {
  visa,
  mastercard,
  unknown,
}

class CardModel {
  final String id;
  final String name;
  final String number;
  final CardBrand brand;

  CardModel({
    required this.id,
    required this.name,
    required this.number,
    required this.brand,
  });

  String get maskedNumber {
    final clean = number.replaceAll(' ', '');
    if (clean.length < 4) return clean;

    return "**** **** **** ${clean.substring(clean.length - 4)}";
  }
}