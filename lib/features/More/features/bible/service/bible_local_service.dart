import 'dart:convert';
import 'package:flutter/services.dart';

class BibleLocalService {
  static List<dynamic>? _bibleCache;

  Future<List<dynamic>> _loadBible() async {

    if (_bibleCache !=null) {
      return _bibleCache!;
    }

    final jsonString = 
    await rootBundle.loadString('assets/bible/bible.json');

    _bibleCache = jsonDecode(jsonString);
    return _bibleCache!;
  }

  Future<List<String>> getVerses(
    int bookIndex,
    int chapterIndex,
  ) async {
    final bible = await _loadBible();

    return List<String>.from(
      bible[bookIndex]["chapters"][chapterIndex],
    );
  }
  Future<int> getTotalChapters(int bookIndex) async {
    final bible = await _loadBible();

    return bible[bookIndex]["chapters"].length;
  }
    Future<String> getVerse(
    int bookIndex,
    int chapterIndex,
    int verseIndex,
  ) async {

    final verses = await getVerses(bookIndex, chapterIndex);

    return verses[verseIndex];
  }
}