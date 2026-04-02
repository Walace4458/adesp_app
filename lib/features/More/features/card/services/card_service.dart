import '../models/card_model.dart';

class CardService {
  static final List<CardModel> _cards = [
    CardModel(
      id: '1',
      name: 'Cartão Principal',
      number: '4111111111111111', // 🔥 começa com 4 → VISA
      brand: CardBrand.visa,
    ),
    CardModel(
      id: '2',
      name: 'Walaceee',
      number: '5111111111111111', // 🔥 começa com 5 → MASTERCARD
      brand: CardBrand.mastercard,
    ),
  ];

  static List<CardModel> getAll() => _cards;

  static void add(CardModel card) {
    _cards.insert(0, card);
  }

  static void remove(String id) {
    _cards.removeWhere((c) => c.id == id);
  }

  // 🔥 OPCIONAL (BÔNUS - útil depois)
  static CardModel? getById(String id) {
    try {
      return _cards.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}