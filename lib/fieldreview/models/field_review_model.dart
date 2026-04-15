class FieldReview {
  final int? id;
  final String fieldName;
  final String reviewer;
  final String comment;
  final int rating;
  final String date;

  FieldReview({
    this.id,
    required this.fieldName,
    required this.reviewer,
    required this.comment,
    required this.rating,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'fieldName': fieldName,
      'reviewer': reviewer,
      'comment': comment,
      'rating': rating,
      'date': date,
    };
  }

  factory FieldReview.fromMap(Map<String, dynamic> map) {
    return FieldReview(
      id: _asInt(map['id']),
      fieldName: map['fieldName']?.toString() ?? '',
      reviewer: map['reviewer']?.toString() ?? '',
      comment: map['comment']?.toString() ?? '',
      rating: _asInt(map['rating']) ?? 0,
      date: map['date']?.toString() ?? '',
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
