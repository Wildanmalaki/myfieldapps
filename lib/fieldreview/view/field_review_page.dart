import 'package:MyField/fieldreview/service/field_review_service.dart';
import 'package:flutter/material.dart';
import '../models/field_review_model.dart';

class FieldReviewListPage extends StatefulWidget {
  const FieldReviewListPage({super.key});

  @override
  State<FieldReviewListPage> createState() => _FieldReviewListPageState();
}

class _FieldReviewListPageState extends State<FieldReviewListPage> {
  late Future<List<FieldReview>> reviews;

  @override
  void initState() {
    super.initState();
    reviews = FieldReviewService.getReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Field Reviews")),
      body: FutureBuilder<List<FieldReview>>(
        future: reviews,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final review = data[index];

              return ListTile(
                title: Text(review.fieldName),
                subtitle: Text(review.comment),
                trailing: Text("${review.rating}/5"),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FieldReviewListPage()),
          );
        },
      ),
    );
  }
}
