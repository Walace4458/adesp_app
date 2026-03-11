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

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {

              final BibleBook book = books[index];

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
            },
          );
        },
      ),
    );
  }
}