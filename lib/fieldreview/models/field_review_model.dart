class FieldReview {
  final int? id;
  final String fieldName;
  final String reviewer;
  final String comment;
  final int rating;
  final DateTime createdAt;

  FieldReview({
    this.id,
    required this.fieldName,
    required this.reviewer,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory FieldReview.fromJson(Map<String, dynamic> json) {
    return FieldReview(
      id: json['id'],
      fieldName: json['field_name'],
      reviewer: json['reviewer'],
      comment: json['comment'],
      rating: json['rating'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field_name': fieldName,
      'reviewer': reviewer,
      'comment': comment,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
