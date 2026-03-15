class Event {
  int? id;
  String title;
  String sport;
  String date;
  String time;
  String location;
  int players;

  Event({
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
      'id': id,
      'title': title,
      'sport': sport,
      'date': date,
      'time': time,
      'location': location,
      'players': players,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      sport: map['sport'],
      date: map['date'],
      time: map['time'],
      location: map['location'],
      players: map['players'],
    );
  }
}