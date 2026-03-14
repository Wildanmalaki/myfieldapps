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
      'id': id,
      'fieldName': fieldName,
      'reviewer': reviewer,
      'comment': comment,
      'rating': rating,
      'date': date,
    };
  }

  factory FieldReview.fromMap(Map<String, dynamic> map) {
    return FieldReview(
      id: map['id'],
      fieldName: map['fieldName'],
      reviewer: map['reviewer'],
      comment: map['comment'],
      rating: map['rating'],
      date: map['date'],
    );
  }
}