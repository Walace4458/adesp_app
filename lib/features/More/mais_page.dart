import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/More/features/bible/models/bible_book.dart';
import 'package:flutter_application_1/features/More/features/bible/ui/bible_books_page.dart';
import 'package:flutter_application_1/features/More/features/bible/ui/bible_favorites_page.dart';
import 'package:flutter_application_1/features/More/features/bible/ui/bible_reader_page.dart';
import 'package:flutter_application_1/features/More/features/bible/ui/reading_page.dart';
import 'package:flutter_application_1/features/More/features/contact/pages/contact_page.dart';
import 'package:flutter_application_1/features/More/features/contribution/pages/contribution_page.dart';
import 'package:flutter_application_1/features/More/features/profile/pages/profile_page.dart';
import 'package:flutter_application_1/features/More/features/testimonies/ui/testimonies/testimonies_page.dart';


import '../More/models/more_option.dart';
import '../More/ui/pages/widgets/more_option_tile.dart';
import '../More/ui/pages/prayer_requests_page.dart';

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
        page: const ContributionPage(), 
      ),

      MoreOption(
        title: "Bíblia",
        icon: Icons.menu_book_rounded,
        page: BibleReaderPage(
          book: BibleBook(
            name: "Gênisis", 
            chapters: 50, 
            index: 0,
          ),
          chapter: 1,
        ),
      ),

      MoreOption(
        title: "Versículos Favoritos",
        icon: Icons.star_border_rounded,
        page: BibleFavoritesPage(),
      ),

      MoreOption(
        title: "Pedidos de oração",
        icon: Icons.volunteer_activism_rounded,
        page: const PrayerRequestsPage(),
      ),

      MoreOption(
        title: "Leitura",
        icon: Icons.menu_book_rounded,
        page: const ReadingPage(),
      ),

      MoreOption(
        title: "Testemunhos",
        icon: Icons.record_voice_over_rounded,
        page: TestimoniesPage(),
      ),

      MoreOption(
        title: "Contato",
        icon: Icons.contact_phone_rounded,
        page: const ContactPage(),
      ),
    ];

    return Scaffold(
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