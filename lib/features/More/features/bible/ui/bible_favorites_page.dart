import 'package:flutter/material.dart';

import '../service/bible_favorites_service.dart';
import '../service/bible_books_service.dart';
import '../models/bible_book.dart';
import 'bible_reader_page.dart';

class BibleFavoritesPage extends StatefulWidget {
  const BibleFavoritesPage({super.key});

  @override
  State<BibleFavoritesPage> createState() => _BibleFavoritesPageState();
}

class _BibleFavoritesPageState extends State<BibleFavoritesPage> {

  final favoritesService = BibleFavoritesService();
  final booksService = BibleBooksService();

  Future<List<String>> _loadFavorites() {
    return favoritesService.getFavorites();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Versículos Favoritos"),
      ),

      body: FutureBuilder<List<String>>(

        future: _loadFavorites(),

        builder: (context, favSnapshot) {

          if (!favSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final favorites = favSnapshot.data!;

          if (favorites.isEmpty) {
            return const Center(
              child: Text("Nenhum versículo favoritado ainda."),
            );
          }

          return FutureBuilder<List<BibleBook>>(

            future: booksService.loadBooks(),

            builder: (context, bookSnapshot) {

              if (!bookSnapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final books = bookSnapshot.data!;

              return ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {

                  final reference = favorites[index];

                  return ListTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: Text(reference),

                    onTap: () {

                      /// exemplo: João 3:16
                      final parts = reference.split(" ");

                      final bookName = parts.first;

                      final chapterVerse = parts.last.split(":");

                      final chapter = int.parse(chapterVerse[0]);

                      /// encontrar livro na lista carregada
                      final BibleBook book = books.firstWhere(
                        (b) => b.name.toLowerCase() == bookName.toLowerCase(),
                        orElse: () => books.first,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BibleReaderPage(
                            book: book,
                            chapter: chapter,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}