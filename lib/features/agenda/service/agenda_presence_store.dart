import 'package:shared_preferences/shared_preferences.dart';

class AgendaPresenceStore {
  static const _key = 'confirmed_events';

  Future<Set<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.toSet();
  }

  Future<void> save(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids.toList());
  }
}