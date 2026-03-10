import 'package:flutter/material.dart';

import '../models/bible_book.dart';
import 'bible_reader_page.dart';

class BibleChaptersPage extends StatelessWidget{
  final BibleBook book;

const BibleChaptersPage({
  super.key,
  required this.book,
});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.name),
      ),

      body: ListView.builder(
        itemCount: book.chapters,
        itemBuilder: (context, index) {
          final chapter = index + 1;

          return ListTile(
            title: Text("Capítulo $chapter"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BibleReaderPage(
                    book: book,
                    chapter: chapter,
                  )
                ) 
              );
            },
          );
        },
      ),
    );
  }
}