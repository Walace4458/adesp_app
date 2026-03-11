import 'package:flutter/material.dart';

import '../models/bible_book.dart';
import '../service/bible_local_service.dart';
import '../service/bible_favorites_service.dart';

class BibleReaderPage extends StatefulWidget {
  final BibleBook book;
  final int chapter;

  const BibleReaderPage({
    super.key,
    required this.book,
    required this.chapter,
  });

  @override
  State<BibleReaderPage> createState() => _BibleReaderPageState();
}

class _BibleReaderPageState extends State<BibleReaderPage> {
  final service = BibleLocalService();
  final favoritesService = BibleFavoritesService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.book.name} ${widget.chapter}"),
      ),
      body: FutureBuilder(
        future: service.getVerses(widget.book.index, widget.chapter - 1),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final verses = snapshot.data!;

          return Column(
            children: [

              /// LISTA DE VERSÍCULOS
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: verses.length,
                  itemBuilder: (context, index) {

                    final verse = verses[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Expanded(
                            child: Text(
                              "${index + 1}. $verse",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),

                          FutureBuilder<bool>(
                            future: favoritesService.isFavorite(
                              "${widget.book.name} ${widget.chapter}:${index + 1}",
                            ),
                            builder: (context, snapshot) {

                              final isFav = snapshot.data ?? false;

                              return IconButton(
                                icon: Icon(
                                  isFav ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                ),
                                onPressed: () async {

                                  final reference =
                                      "${widget.book.name} ${widget.chapter}:${index + 1}";

                                  await favoritesService.toggleFavorite(reference);

                                  setState(() {});
                                },
                              );
                            },
                          ),

                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              /// NAVEGAÇÃO ENTRE CAPÍTULOS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    if (widget.chapter > 1)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BibleReaderPage(
                                book: widget.book,
                                chapter: widget.chapter - 1,
                              ),
                            ),
                          );
                        },
                        child: const Text("Capítulo anterior"),
                      ),

                    ElevatedButton(
                      onPressed: () async {

                        final total =
                            await service.getTotalChapters(widget.book.index);

                        if (widget.chapter < total) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BibleReaderPage(
                                book: widget.book,
                                chapter: widget.chapter + 1,
                              ),
                            ),
                          );
                        }

                      },
                      child: const Text("Próximo capítulo"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

            ],
          );
        },
      ),
    );
  }
}