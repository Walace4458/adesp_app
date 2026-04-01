import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class IdCardPage extends StatelessWidget {
  const IdCardPage({super.key});

  // 🔥 MOCK FIXO (futuro: backend)
  final Map<String, String> user = const {
    "id": "ID-84729",
    "name": "Victor Assis",
    "church": "ADESP Igreja",
    "role": "Líder de Célula",
    "since": "2024",
    "status": "Ativo",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text("Carteirinha"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(),
            const SizedBox(height: 20),
            _buildInfo(),
            const SizedBox(height: 20),
            _buildQr(context),
            const SizedBox(height: 20),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  // =========================
  // 🎴 CARD PRINCIPAL
  // =========================
  Widget _buildCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF5F2C82),
            Color(0xFF49A09D),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 30),
          ),

          const SizedBox(width: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user["name"]!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user["church"]!,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Text(
                user["role"]!,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================
  // 📄 INFO
  // =========================
  Widget _buildInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _infoRow("ID do membro", user["id"]!),
          const SizedBox(height: 10),
          _infoRow("Membro desde", user["since"]!),
          const SizedBox(height: 10),
          _infoRow("Status", user["status"]!),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // =========================
  // 🔲 QR CODE REAL
  // =========================
  Widget _buildQr(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: QrImageView(
            data: user["id"]!,
            size: 120,
          ),
        ),

        const SizedBox(height: 10),

        TextButton(
          onPressed: () {
            _showFullQr(context);
          },
          child: const Text(
            "Expandir QR",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  // =========================
  // 🔍 FULL QR
  // =========================
  void _showFullQr(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: QrImageView(
              data: user["id"]!,
              size: 200,
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // 🚀 AÇÕES
  // =========================
  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Share.share(
                "Carteirinha: ${user["name"]} - ${user["id"]}",
              );
            },
            icon: const Icon(Icons.share),
            label: const Text("Compartilhar"),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Salvar imagem (em breve)"),
                ),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text("Salvar"),
          ),
        ),
      ],
    );
  }
}