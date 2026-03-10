import 'package:flutter/material.dart';

import '../models/bible_book.dart';
import '../service/bible_api_service.dart';

class BibleReaderPage extends StatefulWidget{
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
  final service = BibleApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.book.name} ${widget.chapter}"),
      ),

      body: FutureBuilder(
        future: service.getChapter(widget.book, widget.chapter),

        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final verses = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: verses.length,
            itemBuilder: (context, index) {
              final verse = verses[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text("${verse.verse}. ${verse.text}", style: TextTheme.of(context).titleMedium,),
              );
            },
          );
        },
      ),
    );
  }
}