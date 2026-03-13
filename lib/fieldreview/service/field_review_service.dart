import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/field_review_model.dart';

class FieldReviewService {
  static const String baseUrl = "https://your-api.com/reviews";

  static Future<List<FieldReview>> getReviews() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => FieldReview.fromJson(e)).toList();
    } else {
      throw Exception("Failed load reviews");
    }
  }

  static Future<void> createReview(FieldReview review) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(review.toJson()),
    );
  }

  static Future<void> updateReview(int id, FieldReview review) async {
    await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(review.toJson()),
    );
  }

  static Future<void> deleteReview(int id) async {
    await http.delete(Uri.parse("$baseUrl/$id"));
  }
}
