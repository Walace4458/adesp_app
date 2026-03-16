import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bible_book.dart';
import '../service/bible_local_service.dart';
import '../service/bible_favorites_service.dart';
import '../service/bible_books_service.dart';

class BibleReaderPage extends StatefulWidget {
  final BibleBook book;
  final int chapter;
  final int? highlightVerse;

  const BibleReaderPage({
    super.key,
    required this.book,
    required this.chapter,
    this.highlightVerse,
  });

  @override
  State<BibleReaderPage> createState() => _BibleReaderPageState();
}

class _BibleReaderPageState extends State<BibleReaderPage> {

  final service = BibleLocalService();
  final favoriteService = BibleFavoritesService();

  double fontSize = 18;
  bool darkMode = false;

  final ScrollController controller = ScrollController();

  void loadSettings() async {
  final prefs = await SharedPreferences.getInstance();

  setState(() {
    darkMode = prefs.getBool("bible_dark_mode") ?? false;
  });
}

void saveDarkMode(bool value) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool("bible_dark_mode", value);
}

@override
void initState() {
  super.initState();
  loadSettings();

  if (widget.highlightVerse !=null) {
    Future.delayed(const Duration(milliseconds: 400), () {
      final offset = widget.highlightVerse! * 80.0;

      controller.animateTo(
        offset, 
        duration: const Duration(milliseconds: 500), 
        curve: Curves.easeInOut,
      );
    });
  }
}

  /// ABRIR LISTA DE LIVROS
  void abrirSelectorDeLivro() async {

    final booksService = BibleBooksService();
    final books = await booksService.loadBooks();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,

          child: ListView.builder(
            itemCount: books.length,

            itemBuilder: (context, index) {

              final book = books[index];

              return ListTile(
                title: Text(book.name),

                onTap: () {

                  Navigator.pop(context);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BibleReaderPage(
                        book: book,
                        chapter: 1,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  /// ABRIR GRID DE CAPÍTULOS
  void abrirSelectorCapitulo() async {

    final total = await service.getTotalChapters(widget.book.index);

    showModalBottomSheet(
      context: context,
      builder: (context) {

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,

          child: GridView.builder(

            padding: const EdgeInsets.all(20),

            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),

            itemCount: total,

            itemBuilder: (context, index) {

              final chapterNumber = index + 1;

              return InkWell(
                onTap: () {

                  Navigator.pop(context);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BibleReaderPage(
                        book: widget.book,
                        chapter: chapterNumber,
                      ),
                    ),
                  );
                },

                child: Container(
                  alignment: Alignment.center,

                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: Text(
                    chapterNumber.toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final theme = darkMode ? ThemeData.dark() : ThemeData.light();

    return Theme(
      data: theme,
      child: Scaffold(

        appBar: AppBar(
          title: const Text("Bíblia"),

          actions: [

            /// DIMINUIR FONTE
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  fontSize -= 2;
                  if (fontSize < 12) fontSize = 12;
                });
              },
            ),

            /// AUMENTAR FONTE
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  fontSize += 2;
                });
              },
            ),

            /// MODO NOTURNO
            IconButton(
              icon: Icon(
                darkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () {
                  final newValue = !darkMode;
                  setState(() {
                    darkMode = newValue;
                  });
                  saveDarkMode(newValue);
                },
            ),
          ],
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

                /// BARRA LIVRO + CAPÍTULO
                Container(
                  padding: const EdgeInsets.all(10),

                  child: Row(
                    children: [

                      /// LIVRO
                      InkWell(
                        onTap: abrirSelectorDeLivro,

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),

                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8),
                          ),

                          child: Text(widget.book.name),
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// CAPÍTULO
                      InkWell(
                        onTap: abrirSelectorCapitulo,

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),

                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8),
                          ),

                          child: Text(widget.chapter.toString()),
                        ),
                      ),

                    ],
                  ),
                ),

                /// LISTA DE VERSÍCULOS
                Expanded(
                  child: ListView.builder(

                    controller: controller,
                    padding: const EdgeInsets.all(16),
                    itemCount: verses.length,

                    itemBuilder: (context, index) {

                      final verse = verses[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// TEXTO DO VERSÍCULO
                            Expanded(
                              child: Text(
                                "${index + 1}. $verse",

                                style: TextStyle(
                                  fontSize: fontSize,
                                  height: 1.5,
                                ),
                              ),
                            ),

                            /// FAVORITO
                            FutureBuilder<bool>(
                              future: favoriteService.isFavorite(
                                "${widget.book.name} ${widget.chapter}:${index + 1}",
                              ),

                              builder: (context, snapshot) {

                                final isFav = snapshot.data ?? false;

                                return IconButton(
                                  icon: Icon(
                                    isFav
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                  ),

                                  onPressed: () async {

                                    final reference =
                                        "${widget.book.name} ${widget.chapter}:${index + 1}";

                                    await favoriteService
                                        .toggleFavorite(reference);

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

                /// NAVEGAÇÃO DE CAPÍTULO
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      /// CAPÍTULO ANTERIOR
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

                      /// PRÓXIMO CAPÍTULO
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
      ),
    );
  }
}