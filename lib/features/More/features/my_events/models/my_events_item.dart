import '../../events/models/event_model.dart';

enum MyEventStatus {
  interested,
  confirmed,
}

class MyEventsItem {
  final EventModel event;
  MyEventStatus status;

  MyEventsItem({
    required this.event,
    required this.status,
  });
}