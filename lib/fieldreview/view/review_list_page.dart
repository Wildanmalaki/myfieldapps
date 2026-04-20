import 'package:MyField/fieldreview/view/add_review_page.dart';
import 'package:flutter/material.dart';
import 'package:MyField/database/database_helper.dart';
import 'package:MyField/fieldreview/models/field_review_model.dart';

/// Halaman daftar review untuk lapangan tertentu.
class ReviewListPage extends StatefulWidget {
  final String fieldName;

  const ReviewListPage({super.key, required this.fieldName});

  @override
  State<ReviewListPage> createState() => _ReviewListPageState();
}

/// State daftar review lapangan.
class _ReviewListPageState extends State<ReviewListPage> {

  List<FieldReview> reviews = [];

  @override
  void initState() {
    super.initState();
    loadReviews();
  }

  Future loadReviews() async {
    final data = await DatabaseHelper.instance.getReviews();

    setState(() {
      reviews = data
          .where((r) => r.fieldName == widget.fieldName)
          .toList();
    });
  }

  double getAverageRating() {
    if (reviews.isEmpty) return 0;

    double total = 0;

    for (var r in reviews) {
      total += r.rating;
    }

    return total / reviews.length;
  }

  @override
  Widget build(BuildContext context) {

    double avgRating = getAverageRating();

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Ulasan Lapangan"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddReviewPage(
                fieldName: widget.fieldName,
              ),
            ),
          );

          loadReviews();
        },
      ),

      body: Column(
        children: [

          // ===== SUMMARY =====

          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Column(
              children: [

                Text(
                  avgRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < avgRating.round()
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.orange,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Text("${reviews.length} ulasan"),

              ],
            ),
          ),

          // ===== LIST REVIEW =====

          Expanded(
            child: reviews.isEmpty
                ? const Center(
                    child: Text("Belum ada review"),
                  )
                : ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {

                      final r = reviews[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),

                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              children: [

                                const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),

                                const SizedBox(width: 10),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      r.reviewer,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    Text(
                                      r.date,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),

                                const Spacer(),

                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      i < r.rating
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.orange,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Text(r.comment),

                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
