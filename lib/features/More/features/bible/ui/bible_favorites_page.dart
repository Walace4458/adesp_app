import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../service/bible_favorites_service.dart';
import '../service/bible_local_service.dart';
import '../service/bible_books_service.dart';
import '../models/bible_book.dart';
import '../ui/bible_reader_page.dart';

class BibleFavoritesPage extends StatefulWidget {
  const BibleFavoritesPage({super.key});

  @override
  State<BibleFavoritesPage> createState() => _BibleFavoritesPageState();
}

class _BibleFavoritesPageState extends State<BibleFavoritesPage> {

  final favoriteService = BibleFavoritesService();
  final bibleService = BibleLocalService();
  final booksService = BibleBooksService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Versículos Favoritos"),
      ),

      body: FutureBuilder<List<String>>(
        future: favoriteService.getFavorites(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final favorites = snapshot.data!;

          if (favorites.isEmpty) {
            return const Center(
              child: Text("Nenhum versículo favoritado ainda"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,

            itemBuilder: (context, index) {

              final reference = favorites[index];

              return Card(

                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),

                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(14),

                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),

                    onTap: () async {

                      final data = await parseReference(reference);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BibleReaderPage(
                            book: data["book"],
                            chapter: data["chapter"] + 1,
                            highlightVerse: data["verse"],
                          ),
                        ),
                      );

                    },

                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18,16,18,12),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          /// REFERÊNCIA
                          Row(
                            children: [

                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),

                              const SizedBox(width: 8),

                              Text(
                                reference,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                            ],
                          ),

                          const SizedBox(height: 10),

                          /// TEXTO DO VERSÍCULO
                          FutureBuilder<String>(
                            future: getVerseText(reference),

                            builder: (context, snapshot) {

                              if (!snapshot.hasData) {
                                return const Text("Carregando...");
                              }

                              return Text(
                                snapshot.data!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 14),

                          /// BOTÕES
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,

                            children: [

                              TextButton.icon(
                                icon: const Icon(Icons.share),
                                label: const Text("Compartilhar"),

                                onPressed: () async {

                                  final verseText =
                                      await getVerseText(reference);

                                  await SharePlus.instance.share(
                                    ShareParams(
                                      text: "$reference\n\n$verseText",
                                    ),
                                  );

                                },
                              ),

                              const SizedBox(width: 6),

                              TextButton.icon(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),

                                label: const Text(
                                  "Remover",
                                  style: TextStyle(color: Colors.red),
                                ),

                                onPressed: () async {

                                  await favoriteService
                                      .toggleFavorite(reference);

                                  setState(() {});

                                },
                              ),

                            ],
                          )

                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// CONVERTE REFERÊNCIA PARA LIVRO/CAPÍTULO/VERSO
  Future<Map<String, dynamic>> parseReference(String reference) async {

    final lastSpace = reference.lastIndexOf(" ");

    final bookName = reference.substring(0, lastSpace);
    final chapterVerse = reference.substring(lastSpace + 1);

    final parts = chapterVerse.split(":");

    final chapter = int.parse(parts[0]) - 1;
    final verse = int.parse(parts[1]) - 1;

    final books = await booksService.loadBooks();

    final book = books.firstWhere(
      (b) =>
          b.name.toLowerCase().contains(bookName.toLowerCase()) ||
          bookName.toLowerCase().contains(b.name.toLowerCase()),
      orElse: () => books.first,
    );

    return {
      "book": book,
      "chapter": chapter,
      "verse": verse,
    };
  }

  /// BUSCA TEXTO DO VERSÍCULO
  Future<String> getVerseText(String reference) async {

    try {

      final lastSpace = reference.lastIndexOf(" ");

      final bookName = reference.substring(0, lastSpace);
      final chapterVerse = reference.substring(lastSpace + 1);

      final parts = chapterVerse.split(":");

      final chapter = int.parse(parts[0]) - 1;
      final verse = int.parse(parts[1]) - 1;

      final books = await booksService.loadBooks();

      final book = books.firstWhere(
        (b) =>
            b.name.toLowerCase().contains(bookName.toLowerCase()) ||
            bookName.toLowerCase().contains(b.name.toLowerCase()),
        orElse: () => books.first,
      );

      final verses = await bibleService.getVerses(book.index, chapter);

      if (verse >= verses.length) {
        return "Versículo não encontrado";
      }

      return verses[verse];

    } catch (e) {

      print("ERRO: $e");

      return "Erro ao carregar versículo";
    }
  }
}