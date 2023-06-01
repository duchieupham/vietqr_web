enum EventTypes { refreshListTransaction }

class EventType {
  final dynamic data;
  final EventTypes eventType;
  EventType(this.eventType, this.data);
}
