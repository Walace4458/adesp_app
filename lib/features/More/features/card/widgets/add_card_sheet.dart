import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/card_model.dart';
import '../services/card_service.dart';
import '../utils/card_utils.dart';

// 🔥 FORMATADOR CUSTOMIZADO: Ele limpa, limita a 16 e coloca os espaços
class CardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 1. Remove tudo que não for número
    var digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    // 2. Trava em no máximo 16 dígitos
    if (digitsOnly.length > 16) {
      digitsOnly = digitsOnly.substring(0, 16);
    }

    // 3. Adiciona os espaços a cada 4 dígitos (visual de cartão)
    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      buffer.write(digitsOnly[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != digitsOnly.length) {
        buffer.write(' '); // Adiciona um espaço
      }
    }

    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class AddCardSheet extends StatefulWidget {
  final VoidCallback onAdd;

  const AddCardSheet({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<AddCardSheet> {
  final nameController = TextEditingController();
  final numberController = TextEditingController();

  CardBrand detectedBrand = CardBrand.unknown;

  void _save() {
    final name = nameController.text.trim();
    // Aqui usamos o seu CardUtils para limpar os espaços antes de salvar no banco
    final clean = CardUtils.cleanNumber(numberController.text);

    if (name.isEmpty) return;

    if (!CardUtils.isValid(clean)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cartão inválido")),
      );
      return;
    }

    final card = CardModel(
      id: DateTime.now().toString(),
      name: name,
      number: clean,
      brand: detectedBrand,
    );

    CardService.add(card);
    widget.onAdd();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Adicionar Cartão",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // CAMPO NOME
          TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Nome do cartão",
              labelStyle: TextStyle(color: Colors.white70),
            ),
          ),

          const SizedBox(height: 10),

          // 🔥 CAMPO NÚMERO (COM A TRAVA REAL)
          TextField(
            controller: numberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CardFormatter(), // Usando o nosso formatador que trava em 16
            ],
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Número do cartão",
              hintText: "0000 0000 0000 0000",
              hintStyle: const TextStyle(color: Colors.white24),
              labelStyle: const TextStyle(color: Colors.white70),
              suffixText: _brandText(detectedBrand),
            ),
            onChanged: (value) {
              // Apenas para detectar a bandeira em tempo real
              final clean = CardUtils.cleanNumber(value);
              setState(() {
                detectedBrand = CardUtils.detectBrand(clean);
              });
            },
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  String _brandText(CardBrand brand) {
    switch (brand) {
      case CardBrand.visa:
        return "VISA";
      case CardBrand.mastercard:
        return "MASTERCARD";
      default:
        return "";
    }
  }
}