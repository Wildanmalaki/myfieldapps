import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/booking_model.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  late Future<List<Booking>> bookingList;

  @override
  void initState() {
    super.initState();
    bookingList = DatabaseHelper.instance.getBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0F1B2A),

      appBar: AppBar(
        backgroundColor: Color(0xff0F1B2A),
        title: Text("My Bookings"),
      ),

      body: FutureBuilder<List<Booking>>(
        future: bookingList,

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var bookings = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              var booking = bookings[index];

              return bookingCard(booking);
            },
          );
        },
      ),
    );
  }

  Widget bookingCard(Booking booking) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Color(0xff1E2A3A),
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            booking.lapangan,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(booking.tanggal, style: TextStyle(color: Colors.white70)),

          Text(booking.waktu, style: TextStyle(color: Colors.white70)),

          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Text(
                  booking.status,
                  style: TextStyle(color: Colors.white),
                ),
              ),

              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),

                onPressed: () async {
                  await DatabaseHelper.instance.deleteBooking(booking.id!);

                  setState(() {
                    bookingList = DatabaseHelper.instance.getBookings();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
