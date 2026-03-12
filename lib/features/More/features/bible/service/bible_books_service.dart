import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/bible_book.dart';
import '../data/bible_book_names.dart';

class BibleBooksService {

  Future<List<BibleBook>> loadBooks() async {

    final jsonString = await rootBundle.loadString(
      'assets/bible/bible.json',
    );
    final List books = json.decode(jsonString);
    List<BibleBook> result = [];

    for (int i = 0; i < books.length; i++) {

      final book = books[i];

      result.add(
        BibleBook(
          name: bibleBookNames[book["abbrev"]] ?? book["abbrev"], // aqui mudou
          chapters: book["chapters"].length,
          index: i,
        ),
      );
    }

    return result;
  }
}