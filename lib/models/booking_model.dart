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
    return {
      'userId': userID,
      'lapangan': lapangan,
      'tanggal': tanggal,
      'waktu': waktu,
      'status': status,
      'harga': harga,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: _asInt(map['id']),
      userID: _asInt(map['userId']) ?? 0,
      lapangan: map['lapangan']?.toString() ?? '',
      tanggal: map['tanggal']?.toString() ?? '',
      waktu: map['waktu']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      harga: map['harga']?.toString() ?? '',
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
