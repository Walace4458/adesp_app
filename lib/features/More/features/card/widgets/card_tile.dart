import 'package:flutter/material.dart';
import '../models/card_model.dart';

class CardTile extends StatelessWidget {
  final CardModel card;
  final VoidCallback onDelete;

  const CardTile({
    super.key,
    required this.card,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF5F2C82),
            Colors.black,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 BANDEIRA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                _brandText(),
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            card.maskedNumber,
            style: const TextStyle(
              color: Colors.white,
              letterSpacing: 2,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          )
        ],
      ),
    );
  }

  String _brandText() {
    switch (card.brand) {
      case CardBrand.visa:
        return "VISA";
      case CardBrand.mastercard:
        return "MASTERCARD";
      default:
        return "DESCONHECIDO";
    }
  }
}