import '../models/bible_book.dart';

class BibleBooks{

static final List<BibleBook> all = [
  BibleBook(
    name: "Gênises", 
    apiName: "gn", 
    chapters: 50,
  ),
  BibleBook(
    name: "Salmos", 
    apiName: "sl", 
    chapters: 150,
  ),
  BibleBook(
    name: "joão", 
    apiName: "jn", 
    chapters: 21,
  ),
  BibleBook(
    name: "Mateus", 
    apiName: "mt", 
    chapters: 4,
  ),
];
}
