import 'package:flutter/material.dart';

import '../models/bible_book.dart';
import '../service/bible_books_service.dart';
import 'bible_chapters_page.dart';

class BibleBooksPage extends StatelessWidget {
  const BibleBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final booksService = BibleBooksService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bíblia"),
      ),
      body: FutureBuilder<List<BibleBook>>(
        future: booksService.loadBooks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final books = snapshot.data!;

          final oldTestament = books.sublist(0, 39);
          final newTestament = books.sublist(39);

          return ListView(
            children: [

              /// VELHO TESTAMENTO
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                child: Text(
                  "Velho Testamento",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Divider(thickness: 1),

              ...oldTestament.map((book) {
                return ListTile(
                  title: Text(book.name),
                  trailing: const Icon(Icons.arrow_forward_rounded),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BibleChaptersPage(book: book),
                      ),
                    );
                  },
                );
              }),

              /// NOVO TESTAMENTO
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                child: Text(
                  "Novo Testamento",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ...newTestament.map((book) {
                return ListTile(
                  title: Text(book.name),
                  trailing: const Icon(Icons.arrow_forward_rounded),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BibleChaptersPage(book: book),
                      ),
                    );
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }
}