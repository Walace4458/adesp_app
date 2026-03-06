import 'package:flutter/material.dart';

import '../More/models/more_option.dart';
import '../More/ui/pages/widgets/more_option_tile.dart';

import '../More/ui/pages/profile_page.dart';
import '../More/ui/pages/bible_page.dart';
import '../More/ui/pages/prayer_requests_page.dart';
import '../More/ui/pages/testimonies_page.dart';
import '../More/ui/pages/contact_page.dart';
import '../more/ui/pages/contribuation_page.dart';

class MaisPage extends StatelessWidget{
  const MaisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      MoreOption(
        title: "Perfil",
        icon: Icons.person_rounded,
        page: const ProfilePage(),
      ),

      MoreOption(
        title: "Contribuição",
        icon: Icons.account_balance_rounded, 
        page: const ContribuationPage(), 
      ),

      MoreOption(
        title: "Bíblia",
        icon: Icons.menu_book_rounded,
        page: const BiblePage(),
      ),

      MoreOption(
        title: "Pedidos de oração",
        icon: Icons.volunteer_activism_rounded,
        page: const PrayerRequestsPage(),
      ),

      MoreOption(
        title: "Testemunhos",
        icon: Icons.record_voice_over_rounded,
        page: const TestimoniesPage(),
      ),

      MoreOption(
        title: "Contato",
        icon: Icons.contact_phone_rounded,
        page: const ContactPage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mais Opções"),
      ),
      body: ListView.separated(
          separatorBuilder: (_, __) => const Divider(), 
          itemCount: options.length,
           itemBuilder: (context, index) {
            return MoreOptionTile(option: options[index]);
          }, 
        ),
    );
  }
}