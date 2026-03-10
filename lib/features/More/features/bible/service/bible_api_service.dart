import 'dart:convert';
import 'package:flutter_application_1/features/More/features/bible/models/bible_book.dart';
import 'package:http/http.dart' as http;

import '../models/bible_verse.dart';

class BibleApiService {
  Future<List<BibleVerse>> getChapter(
    BibleBook book,
    int chapter,
  ) async {
    final url = Uri.parse(
      "https://www.abibliadigial.com.br/api/verse/nvi/${book.apiName}/$chapter"
    );

    final response = await http.get(url);
    final data = jsonDecode(response.body);
    final verses = data["verses"] as List;

    return verses .map((v) => BibleVerse.fromJson(v)).toList();
  }
}