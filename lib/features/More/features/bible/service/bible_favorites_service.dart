import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BibleFavoritesService {
  static const _key = "favorite_verses";

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> toggleFavorite(String verse) async {
    final prefs = await SharedPreferences.getInstance();

    final favorites = prefs.getStringList(_key) ?? [];

    if(favorites.contains(verse)){
      favorites.remove(verse);
    } else {
      favorites.add(verse);
    }
    await prefs.setStringList(_key, favorites);
  }

  Future<bool> isFavorite(String verse) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];

    return favorites.contains(verse);
  }
}