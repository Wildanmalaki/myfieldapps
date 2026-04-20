class Booking {
  int? id;
  int userID;
  String lapangan;
  String tanggal;
  String waktu;
  int startHour;
  int endHour;
  int durationHours;
  String status;
  String harga;
  String invoiceNumber;
  String paymentMethod;
  String paymentStatus;
  String paymentDate;
  String paymentProofCode;
  String bookedAt;

  Booking({
    this.id,
    required this.lapangan,
    required this.userID,
    required this.tanggal,
    required this.waktu,
    required this.startHour,
    required this.endHour,
    this.durationHours = 1,
    required this.status,
    required this.harga,
    this.invoiceNumber = '',
    this.paymentMethod = '',
    this.paymentStatus = '',
    this.paymentDate = '',
    this.paymentProofCode = '',
    this.bookedAt = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userID,
      'lapangan': lapangan,
      'tanggal': tanggal,
      'waktu': waktu,
      'startHour': startHour,
      'endHour': endHour,
      'durationHours': durationHours,
      'status': status,
      'harga': harga,
      'invoiceNumber': invoiceNumber,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'paymentDate': paymentDate,
      'paymentProofCode': paymentProofCode,
      'bookedAt': bookedAt,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    final parsedStartHour = _asInt(map['startHour']);
    final parsedEndHour = _asInt(map['endHour']);
    final waktu = map['waktu']?.toString() ?? '';
    final fallbackStartHour = _parseStartHour(waktu);
    final fallbackDuration = _asInt(map['durationHours']) ?? 1;

    return Booking(
      id: _asInt(map['id']),
      userID: _asInt(map['userId']) ?? 0,
      lapangan: map['lapangan']?.toString() ?? '',
      tanggal: map['tanggal']?.toString() ?? '',
      waktu: waktu,
      startHour: parsedStartHour ?? fallbackStartHour,
      endHour: parsedEndHour ?? ((parsedStartHour ?? fallbackStartHour) + fallbackDuration),
      durationHours: fallbackDuration,
      status: map['status']?.toString() ?? '',
      harga: map['harga']?.toString() ?? '',
      invoiceNumber: map['invoiceNumber']?.toString() ?? '',
      paymentMethod: map['paymentMethod']?.toString() ?? '',
      paymentStatus: map['paymentStatus']?.toString() ?? '',
      paymentDate: map['paymentDate']?.toString() ?? '',
      paymentProofCode: map['paymentProofCode']?.toString() ?? '',
      bookedAt: map['bookedAt']?.toString() ?? '',
    );
  }

  Booking copyWith({
    int? id,
    int? userID,
    String? lapangan,
    String? tanggal,
    String? waktu,
    int? startHour,
    int? endHour,
    int? durationHours,
    String? status,
    String? harga,
    String? invoiceNumber,
    String? paymentMethod,
    String? paymentStatus,
    String? paymentDate,
    String? paymentProofCode,
    String? bookedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      lapangan: lapangan ?? this.lapangan,
      tanggal: tanggal ?? this.tanggal,
      waktu: waktu ?? this.waktu,
      startHour: startHour ?? this.startHour,
      endHour: endHour ?? this.endHour,
      durationHours: durationHours ?? this.durationHours,
      status: status ?? this.status,
      harga: harga ?? this.harga,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentProofCode: paymentProofCode ?? this.paymentProofCode,
      bookedAt: bookedAt ?? this.bookedAt,
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

  static int _parseStartHour(String waktu) {
    final match = RegExp(r'(\d{2}):\d{2}').firstMatch(waktu);
    return int.tryParse(match?.group(1) ?? '') ?? 0;
  }
}
