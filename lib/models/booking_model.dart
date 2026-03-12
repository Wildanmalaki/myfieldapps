// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Booking {
  int? id;
  int userID;
  String lapangan;
  String tanggal;
  String waktu;
  String status;
  String harga;

  Booking({
    this.id,
    required this.lapangan,
    required this.userID,
    required this.tanggal,
    required this.waktu,
    required this.status,
    required this.harga,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userID': userID,
      'lapangan': lapangan,
      'tanggal': tanggal,
      'waktu': waktu,
      'status': status,
      'harga': harga,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] != null ? map['id'] as int : null,
      userID: map['userID'] as int,
      lapangan: map['lapangan'] as String,
      tanggal: map['tanggal'] as String,
      waktu: map['waktu'] as String,
      status: map['status'] as String,
      harga: map['harga'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Booking.fromJson(String source) => Booking.fromMap(json.decode(source) as Map<String, dynamic>);
}
