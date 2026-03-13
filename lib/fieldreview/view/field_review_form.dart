import 'package:MyField/fieldreview/service/field_review_service.dart';
import 'package:MyField/fieldreview/view/field_review_page.dart';
import 'package:flutter/material.dart';
import '../models/field_review_model.dart';

class FieldReviewFormPage extends StatefulWidget {
  final FieldReview? review;

  const FieldReviewFormPage({super.key, this.review});

  @override
  State<FieldReviewFormPage> createState() => _FieldReviewFormPageState();
}

class _FieldReviewFormPageState extends State<FieldReviewFormPage> {
  final fieldController = TextEditingController();
  final reviewerController = TextEditingController();
  final commentController = TextEditingController();

  int rating = 4;

  @override
  void initState() {
    super.initState();

    if (widget.review != null) {
      fieldController.text = widget.review!.fieldName;
      reviewerController.text = widget.review!.reviewer;
      commentController.text = widget.review!.comment;
      rating = widget.review!.rating;
    }
  }

  void saveReview() async {
    try {
      final review = FieldReview(
        fieldName: fieldController.text,
        reviewer: reviewerController.text,
        comment: commentController.text,
        rating: rating,
        createdAt: DateTime.now(),
      );

      await FieldReviewService.createReview(review);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Review berhasil disimpan")));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Widget buildStar(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          rating = index + 1;
        });
      },
      child: Icon(
        index < rating ? Icons.star : Icons.star_border,
        color: Colors.orange,
        size: 34,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const Text(
              "Add Field Review",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            const Text(
              "Help the community by sharing your experience",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            /// FIELD NAME
            TextField(
              controller: fieldController,
              decoration: InputDecoration(
                labelText: "Field Name",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// REVIEWER NAME
            TextField(
              controller: reviewerController,
              decoration: InputDecoration(
                labelText: "Your Name",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Rate your experience",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => buildStar(index)),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Write your review",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: commentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Bagikan pengalamanmu bermain di sini...",
                ),
              ),
            ),

            const Spacer(),

            /// SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: saveReview,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF3A8DFF), Color(0xFF2A6FD6)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(28)),
                  ),
                  child: const Center(
                    child: Text(
                      "Submit Review ➤",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
