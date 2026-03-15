import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/event_model.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {

  final title = TextEditingController();
  final location = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();
  final players = TextEditingController();

  String? selectedSport;

  final List<String> sports = [
    "Sepak Bola",
    "Futsal",
    "Mini Soccer",
    "Padel",
    "Tenis",
  ];

  Future saveEvent() async {

    if (title.text.isEmpty ||
        location.text.isEmpty ||
        date.text.isEmpty ||
        time.text.isEmpty ||
        players.text.isEmpty ||
        selectedSport == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field harus diisi")),
      );
      return;
    }

    int playerCount = int.tryParse(players.text) ?? 0;

    EventModel event = EventModel(
      title: title.text,
      sport: selectedSport!,
      location: location.text,
      date: date.text,
      time: time.text,
      players: playerCount,
    );

    await DatabaseHelper.instance.insertEvent(event);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Create Event"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [

            TextField(
              controller: title,
              decoration: const InputDecoration(
                labelText: "Event Title",
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedSport,
              hint: const Text("Select Sport"),
              items: sports.map((sport) {
                return DropdownMenuItem(
                  value: sport,
                  child: Text(sport),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSport = value;
                });
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: location,
              decoration: const InputDecoration(
                labelText: "Location",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: date,
              decoration: const InputDecoration(
                labelText: "Date",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: time,
              decoration: const InputDecoration(
                labelText: "Time",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: players,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Players Needed",
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveEvent,
                child: const Text("Create Event"),
              ),
            )

          ],
        ),
      ),
    );
  }
}