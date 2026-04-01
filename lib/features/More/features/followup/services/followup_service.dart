import '../models/followup_model.dart';

class FollowUpService {
  static final List<FollowUpModel> _list = [];

  static void add(FollowUpModel item) {
    // 🔥 evita duplicado (mesmo membro + mesmo motivo + ainda pendente)
    final exists = _list.any((f) =>
        f.memberId == item.memberId &&
        f.reason == item.reason &&
        !f.isDone);

    if (!exists) {
      _list.insert(0, item); // mais recente primeiro
    }
  }

  static List<FollowUpModel> getAll() => _list;

  static List<FollowUpModel> getPending() {
    return _list.where((f) => !f.isDone).toList();
  }

  static List<FollowUpModel> getDone() {
    return _list.where((f) => f.isDone).toList();
  }

  // 🔥 toggle status
  static void toggleDone(String id) {
    final index = _list.indexWhere((f) => f.id == id);

    if (index != -1) {
      _list[index].isDone = !_list[index].isDone;
    }
  }

  // 🔥 remover
  static void remove(String id) {
    _list.removeWhere((f) => f.id == id);
  }
}