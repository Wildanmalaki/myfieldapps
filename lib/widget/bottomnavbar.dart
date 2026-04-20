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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isDark
        ? const Color.fromARGB(255, 255, 205, 27)
        : const Color(0xFF3A7BFF);
    final pages = [
      HomePage(currentUser: widget.currentUser),
      BookingsPage(currentUser: widget.currentUser),
      CommunityPage(currentUser: widget.currentUser),
      ProfilePage(currentUser: widget.currentUser),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            isDark ? const Color(0xFF081A2F) : Colors.white,

        selectedItemColor: selectedColor,
        unselectedItemColor:
            isDark ? Colors.white70 : const Color(0xFF66758A),

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
