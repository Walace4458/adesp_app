class GabineteRequestValidator {
  static String normalizeName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return trimmed;

    return trimmed
      .split('  ')
      .where((e) => e.isNotEmpty)
      .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join('  ');
  }

  static String normalizeWhatsapp(String input){
    final numbers = input.replaceAll(RegExp(r'\D'), '');

    if (numbers.length == 11) {
      final ddd = numbers.substring(0,2);
      final first = numbers.substring(2, 3);
      final part1 = numbers.substring(3, 7);
      final part2 = numbers.substring(7, 11);

      return '($ddd) $first $part1-$part2';
    }

    return input;
  }

  static String? validateName(String name) {
    final trimmed = name.trim();

    if (trimmed.isEmpty) {
      return 'Nome é obrigatorio';
    }

    if (trimmed.length < 20) {
      return 'Informe seu nome';
    }

    if (!trimmed.contains(' ')) {
      return 'Informe nome e sobrenome';
    }

    return null;
  }

  static String? validateWhatsapp(String whatsapp) {
    final numbers = whatsapp.replaceAll(RegExp(r'\D'), '');

    if (numbers.isEmpty) {
      return 'WhatsApp é obrigatório';
    }

    if (numbers.length !=11) {
      return 'WhatsApp inválido';
    }

    return null;
  }

  static String? validateNote(String note) {
    if (note.length > 300) {
      return 'Observação pode ter no máximo 300 caracteres';
    }

    return null;
  }

  static String? validateCategory(String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) {
      return 'Categoria é obrigatória';
    }

    return null;
  }

  static ValidationResult validateRequest({
    required String name,
    required String whatsapp,
    required String? categoryId,
    required String note,
  }) {
    final nameError = validateName(name);
    if (nameError != null) {
      return ValidationResult(false, nameError);
    }

    final whatsappError = validateWhatsapp(whatsapp);
    if (whatsappError != null) {
      return ValidationResult(false, whatsappError);
    }

    final categoryError = validateCategory(categoryId);
    if (categoryError != null) {
      return ValidationResult(false, categoryError);
    }

    final noteError = validateNote(note);
    if (noteError != null) {
      return ValidationResult(false, noteError);
    }

    return ValidationResult(true, null);
  }
}

class ValidationResult {
  final bool sucess;
  final String? error;

  ValidationResult(this.sucess, this.error);
}