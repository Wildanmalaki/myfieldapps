import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../models/field_review_model.dart';

class AddReviewPage extends StatefulWidget {
  final String fieldName;

  const AddReviewPage({super.key, required this.fieldName});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();

  int rating = 5;

  void saveReview() async {

    if (nameController.text.isEmpty || reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan review harus diisi")),
      );
      return;
    }

    final review = FieldReview(
      fieldName: widget.fieldName,
      reviewer: nameController.text,
      comment: reviewController.text,
      rating: rating,
      date: DateTime.now().toString(),
    );

    await DatabaseHelper.instance.insertReview(review);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Review berhasil dikirim")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Field Review"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nama",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: reviewController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Review",
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const Icon(Icons.star, color: Colors.amber),

                const SizedBox(width: 10),

                DropdownButton<int>(
                  value: rating,
                  items: [1,2,3,4,5]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text("$e"),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      rating = value!;
                    });
                  },
                )
              ],
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveReview,
                child: const Text("Submit Review"),
              ),
            )
          ],
        ),
      ),
    );
  }
}