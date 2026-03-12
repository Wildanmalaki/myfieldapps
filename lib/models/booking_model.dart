class Booking {
  int? id;
  String lapangan;
  String tanggal;
  String waktu;
  String status;
  String harga;

  Booking({
    this.id,
    required this.lapangan,
    required this.tanggal,
    required this.waktu,
    required this.status,
    required this.harga,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lapangan': lapangan,
      'tanggal': tanggal,
      'waktu': waktu,
      'status': status,
      'harga': harga,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      lapangan: map['lapangan'],
      tanggal: map['tanggal'],
      waktu: map['waktu'],
      status: map['status'],
      harga: map['harga'],
    );
  }
}
