import '../models/event_model.dart';

class EventService {
  static final List<EventModel> _events = [
    EventModel(
      id: '1', 
      groupId: '1', 
      title: 'Reunião de Diáconos', 
      description: 'Organização do culto de domingo', 
      date: DateTime.now().add(const Duration(days: 2)),
    ),
    EventModel(
      id: '2', 
      groupId: '2', 
      title: 'Aula Kids', 
      description: 'Ensino bíblico para crianças', 
      date: DateTime.now().add(const Duration(days: 1)),
    ),
  ];
  static List<EventModel> getByGroup(String groupId) {
    return _events.where((e) => e.groupId == groupId).toList();
  }
}