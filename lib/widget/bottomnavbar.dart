import 'package:MyField/views/home_page.dart';
import 'package:flutter/material.dart';

class bottomNavbar extends StatefulWidget {
  const bottomNavbar({super.key});

  @override
  State<bottomNavbar> createState() => Bottomnavbar();
}

class Bottomnavbar extends State<bottomNavbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
  HomePage(),
  Center(child: Text("Bookings Page")),
  Center(child: Text("Community Page")),
  Center(child: Text("Profile Page")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xff0F172A), // dark background
      body: _pages[_selectedIndex],

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xff1E293B),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,

          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: "Bookings",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups),
              label: "Community",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}