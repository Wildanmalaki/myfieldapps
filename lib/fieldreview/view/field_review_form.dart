import 'package:MyField/fieldreview/service/field_review_service.dart';
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
  int rating = 5;

  void saveReview() async {
    final review = FieldReview(
      fieldName: fieldController.text,
      reviewer: reviewerController.text,
      comment: commentController.text,
      rating: rating,
      createdAt: DateTime.now(),
    );

    await FieldReviewService.createReview(review);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Review")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: fieldController,
              decoration: const InputDecoration(labelText: "Field Name"),
            ),

            TextField(
              controller: reviewerController,
              decoration: const InputDecoration(labelText: "Reviewer"),
            ),

            TextField(
              controller: commentController,
              decoration: const InputDecoration(labelText: "Comment"),
            ),

            DropdownButton<int>(
              value: rating,
              items: List.generate(
                5,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text("${index + 1}"),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  rating = val!;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: saveReview, child: const Text("Save")),
          ],
        ),
      ),
    );
  }
}
