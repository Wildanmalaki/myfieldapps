import 'package:flutter/material.dart';
import 'package:MyField/models/user_model.dart';
import 'package:MyField/views/home_page.dart';
import 'package:MyField/views/bookings_page.dart';
import 'package:MyField/views/community_page.dart';
import 'package:MyField/views/profile.dart';

class BottomNavbar extends StatefulWidget {
  final UserModel currentUser;

  const BottomNavbar({super.key, required this.currentUser});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(currentUser: widget.currentUser),
      BookingsPage(currentUser: widget.currentUser),
      CommunityPage(),
      ProfilePage(currentUser: widget.currentUser),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF081A2F),

        selectedItemColor: const Color(0xFFFFC107),
        unselectedItemColor: Colors.white70,

        currentIndex: index,

        onTap: (value) {
          setState(() {
            index = value;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Booking",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Community",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
