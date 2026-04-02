import '../models/card_model.dart';

class CardUtils {

  // 🔥 Remove tudo que não é número
  static String cleanNumber(String input) {
    return input.replaceAll(RegExp(r'\D'), '');
  }

  // 🔥 Formata: 1234 5678 9012 3456
  static String format(String input) {
    final cleaned = cleanNumber(input);

    final buffer = StringBuffer();

    for (int i = 0; i < cleaned.length; i++) {
      buffer.write(cleaned[i]);

      if ((i + 1) % 4 == 0 && i != cleaned.length - 1) {
        buffer.write(' ');
      }
    }

    return buffer.toString();
  }

  // 🔥 Detecta bandeira
  static CardBrand detectBrand(String number) {
    if (number.startsWith('4')) return CardBrand.visa;
    if (number.startsWith('5')) return CardBrand.mastercard;

    return CardBrand.unknown;
  }

  // 🔥 Luhn (validação real de cartão)
  static bool isValid(String number) {
    final cleaned = cleanNumber(number);

    if (cleaned.length < 13) return false;

    int sum = 0;
    bool alternate = false;

    for (int i = cleaned.length - 1; i >= 0; i--) {
      int n = int.parse(cleaned[i]);

      if (alternate) {
        n *= 2;
        if (n > 9) n -= 9;
      }

      sum += n;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }
}