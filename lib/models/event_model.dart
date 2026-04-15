class EventModel {
  int? id;
  String title;
  String sport;
  String date;
  String time;
  String location;
  int players;

  EventModel({
    this.id,
    required this.title,
    required this.sport,
    required this.date,
    required this.time,
    required this.location,
    required this.players,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'sport': sport,
      'date': date,
      'time': time,
      'location': location,
      'players': players,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: _asInt(map['id']),
      title: map['title']?.toString() ?? '',
      sport: map['sport']?.toString() ?? '',
      date: map['date']?.toString() ?? '',
      time: map['time']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      players: _asInt(map['players']) ?? 0,
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}
