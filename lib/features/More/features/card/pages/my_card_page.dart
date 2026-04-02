import 'package:flutter/material.dart';

import '../models/card_model.dart';
import '../services/card_service.dart';
import '../widgets/card_tile.dart';
import '../utils/card_utils.dart';

class MyCardsPage extends StatefulWidget {
  const MyCardsPage({super.key});

  @override
  State<MyCardsPage> createState() => _MyCardsPageState();
}

class _MyCardsPageState extends State<MyCardsPage> {
  List<CardModel> cards = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    cards = CardService.getAll();
  }

  void _refresh() {
    setState(() {
      _load();
    });
  }

  // =========================
  // 💳 ADD CARD (COM VALIDAÇÃO)
  // =========================
  void _showAddCard() {
    final nameController = TextEditingController();
    final numberController = TextEditingController();

    CardBrand detectedBrand = CardBrand.unknown;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Adicionar Cartão",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Nome do cartão",
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Número do cartão",
                      suffixText: _brandText(detectedBrand),
                    ),
                    onChanged: (value) {
                      final formatted = CardUtils.format(value);
                      final clean = CardUtils.cleanNumber(formatted);

                      numberController.value = TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(
                          offset: formatted.length,
                        ),
                      );

                      setModalState(() {
                        detectedBrand =
                            CardUtils.detectBrand(clean);
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      final clean =
                          CardUtils.cleanNumber(numberController.text);

                      if (!CardUtils.isValid(clean)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cartão inválido"),
                          ),
                        );
                        return;
                      }

                      CardService.add(
                        CardModel(
                          id: DateTime.now().toString(),
                          name: nameController.text,
                          number: clean,
                          brand: detectedBrand,
                        ),
                      );

                      _refresh();
                      Navigator.pop(context);
                    },
                    child: const Text("Salvar"),
                  ),
                ],
              ),
            );
          },
        );
      },
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

  // =========================
  // 🗑 DELETE
  // =========================
  void _deleteCard(String id) {
    CardService.remove(id);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Cartões"),
      ),
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: cards.isEmpty
            ? const Center(
                child: Text(
                  "Nenhum cartão salvo",
                  style: TextStyle(color: Colors.white70),
                ),
              )
            : ListView(
                children: cards
                    .map((c) => CardTile(
                          card: c,
                          onDelete: () => _deleteCard(c.id),
                        ))
                    .toList(),
              ),
      ),

      // ➕ BOTÃO
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCard,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}