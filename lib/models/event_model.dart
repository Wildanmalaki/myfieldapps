import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  int? id;
  String title;
  String sport;
  String date;
  String time;
  String location;
  int players;
  String imageBase64;
  String creatorName;
  int? creatorId;
  List<EventParticipant> participants;
  DateTime? createdAt;
  DateTime? expireAt;

  EventModel({
    this.id,
    required this.title,
    required this.sport,
    required this.date,
    required this.time,
    required this.location,
    required this.players,
    this.imageBase64 = '',
    this.creatorName = '',
    this.creatorId,
    this.participants = const [],
    this.createdAt,
    this.expireAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'sport': sport,
      'date': date,
      'time': time,
      'location': location,
      'players': players,
      'imageBase64': imageBase64,
      'creatorName': creatorName,
      'creatorId': creatorId,
      'participants':
          participants.map((participant) => participant.toMap()).toList(),
      'createdAt': createdAt,
      'expireAt': expireAt,
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
      imageBase64: map['imageBase64']?.toString() ?? '',
      creatorName: map['creatorName']?.toString() ?? '',
      creatorId: _asInt(map['creatorId']),
      participants: _participantsFromMap(map['participants']),
      createdAt: _asDateTime(map['createdAt']),
      expireAt: _asDateTime(map['expireAt']),
    );
  }

  EventModel copyWith({
    int? id,
    String? title,
    String? sport,
    String? date,
    String? time,
    String? location,
    int? players,
    String? imageBase64,
    String? creatorName,
    int? creatorId,
    List<EventParticipant>? participants,
    DateTime? createdAt,
    DateTime? expireAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      sport: sport ?? this.sport,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      players: players ?? this.players,
      imageBase64: imageBase64 ?? this.imageBase64,
      creatorName: creatorName ?? this.creatorName,
      creatorId: creatorId ?? this.creatorId,
      participants: participants ?? this.participants,
      createdAt: createdAt ?? this.createdAt,
      expireAt: expireAt ?? this.expireAt,
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

  static List<EventParticipant> _participantsFromMap(dynamic value) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map(
          (item) => EventParticipant.fromMap(
            item.map((key, val) => MapEntry(key.toString(), val)),
          ),
        )
        .toList();
  }

  static DateTime? _asDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}

class EventParticipant {
  final int? userId;
  final String name;
  final String email;
  final String phone;
  final String note;
  final String joinedAt;

  const EventParticipant({
    this.userId,
    required this.name,
    required this.email,
    this.phone = '',
    this.note = '',
    this.joinedAt = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'note': note,
      'joinedAt': joinedAt,
    };
  }

  factory EventParticipant.fromMap(Map<String, dynamic> map) {
    return EventParticipant(
      userId: EventModel._asInt(map['userId']),
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      note: map['note']?.toString() ?? '',
      joinedAt: map['joinedAt']?.toString() ?? '',
    );
  }
}
