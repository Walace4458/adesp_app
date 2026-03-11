import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/bible_book.dart';

class BibleBooksService {
  Future<List<BibleBook>> loadBooks() async {
    final jsonString = await rootBundle.loadString(
      'lib/assets/bible/bible.json',
    );

    final data = json.decode(jsonString);
    final books = data["books"] as List;

    List<BibleBook> result = [];

    for (int i = 0; i < books.length; i++ ) {
      final book = books[i];

      result.add(
        BibleBook(
          name: book["name"], 
          chapters: book["chapters"].length, 
          index: i,
        )
      );
    }
    return result;
  }
}