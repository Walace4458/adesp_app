import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../widgets/contact_card.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Não foi possível abrir $url';
    }
  }

  void _shareApp() {
    Share.share(
      "Baixe nosso app: https://linktr.ee/seuapp",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contato")),
      backgroundColor: const Color(0xFF121212),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // 🔥 INSTAGRAM
          ContactCard(
            title: "Instagram",
            description: "Siga nossa igreja",
            icon: Icons.camera_alt,
            gradient: const [
              Color(0xFFF58529),
              Color(0xFFDD2A7B),
              Color(0xFF8134AF),
            ],
            onTap: () => _openUrl("https://instagram.com/suaigreja"),
          ),

          // 🔥 YOUTUBE
          ContactCard(
            title: "YouTube",
            description: "Assista nossos cultos",
            icon: Icons.play_arrow,
            gradient: const [
              Color(0xFFFF0000),
              Color(0xFFCC0000),
            ],
            onTap: () => _openUrl("https://youtube.com/suaigreja"),
          ),

          // 🔥 WHATSAPP
          ContactCard(
            title: "WhatsApp",
            description: "Fale com a secretaria",
            icon: Icons.chat,
            gradient: const [
              Color(0xFF25D366),
              Color(0xFF128C7E),
            ],
            onTap: () => _openUrl("https://wa.me/5599999999999"),
          ),

          const SizedBox(height: 20),

          // 🔥 SHARE APP
          ContactCard(
            title: "Compartilhar App",
            description: "Convide outras pessoas",
            icon: Icons.share,
            gradient: const [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
            onTap: _shareApp,
          ),
        ],
      ),
    );
  }
}