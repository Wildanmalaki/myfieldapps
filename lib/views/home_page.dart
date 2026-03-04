import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      

       backgroundColor: const Color(0xff0F172A),
        body: Padding(padding:  const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Selamat datang,",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            ),
            Text("Wildan!,",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            )
          ],
          
        )
          
          ),
        );
  }
}