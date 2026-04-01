import '../../events/models/event_model.dart';
import '../models/my_events_item.dart';

class MyEventService {

  // 🔥 MOCK INICIAL (para UI funcionar)
  static final List<MyEventsItem> _list = [
    MyEventsItem(
      event: EventModel(
        id: '1',
        groupId: '1',
        title: 'Culto Jovem',
        description: 'Noite de louvor e palavra',
        date: DateTime.now().add(const Duration(days: 2)),
      ),
      status: MyEventStatus.confirmed,
    ),

    MyEventsItem(
      event: EventModel(
        id: '2',
        groupId: '2',
        title: 'Célula Quinta',
        description: 'Comunhão e estudo',
        date: DateTime.now().add(const Duration(days: 4)),
      ),
      status: MyEventStatus.interested,
    ),
  ];

  // =========================
  // ❤️ INTERESSE
  // =========================
  static void toggleInterest(MyEventsItem item) {
    final index = _list.indexWhere((e) => e.event.id == item.event.id);

    if (index != -1) {
      // 🔥 se já existe
      if (_list[index].status == MyEventStatus.interested) {
        // remove (descurtir)
        _list.removeAt(index);
      } else {
        // se era confirmado → vira interessado
        _list[index].status = MyEventStatus.interested;
      }
    } else {
      // 🔥 adiciona como interessado
      _list.insert(
        0,
        MyEventsItem(
          event: item.event,
          status: MyEventStatus.interested,
        ),
      );
    }
  }

  // =========================
  // ✅ CONFIRMAR PRESENÇA
  // =========================
  static void confirm(MyEventsItem item) {
    final index = _list.indexWhere((e) => e.event.id == item.event.id);

    if (index != -1) {
      // 🔥 já existe → força como confirmado
      _list[index].status = MyEventStatus.confirmed;
    } else {
      // 🔥 cria direto como confirmado
      _list.insert(
        0,
        MyEventsItem(
          event: item.event,
          status: MyEventStatus.confirmed,
        ),
      );
    }
  }

  // =========================
  // 📦 GETS
  // =========================
  static List<MyEventsItem> getAll() => List.from(_list);

  static List<MyEventsItem> getConfirmed() {
    return _list
        .where((e) => e.status == MyEventStatus.confirmed)
        .toList();
  }

  static List<MyEventsItem> getInterested() {
    return _list
        .where((e) => e.status == MyEventStatus.interested)
        .toList();
  }

  static MyEventsItem? getById(String id) {
    try {
      return _list.firstWhere((e) => e.event.id == id);
    } catch (_) {
      return null;
    }
  }
}