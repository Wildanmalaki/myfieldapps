import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/event_model.dart';
import 'create_event_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {

  List<EventModel> events = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future loadEvents() async {
    final data = await DatabaseHelper.instance.getEvents();

    setState(() {
      events = data;
    });
  }

  Future deleteEvent(int id) async {
    await DatabaseHelper.instance.deleteEvent(id);
    loadEvents();
  }

  // FOTO OTOMATIS BERDASARKAN SPORT
  String getImage(String sport) {

    sport = sport.toLowerCase();

    if (sport.contains("sepak bola")) {
      return "https://cdn.pixabay.com/photo/2018/06/12/20/17/soccer-3471402_1280.jpg";
    }

    if (sport.contains("futsal")) {
      return "https://t4.ftcdn.net/jpg/06/84/11/45/360_F_684114561_54bnmuviQhUHO7TTmOjRgW0FRuvq6yip.jpg";
    }

    if (sport.contains("mini soccer")) {
      return "https://asset.ayo.co.id/image/venue/165243845442977.image_cropper_1652438416406.jpg";
    }

    if (sport.contains("tenis")) {
      return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvFBbblWYBoxlT42x2zUM4HktbkKkMkcVCGA&s";
    }

    if (sport.contains("padel")) {
      return "https://static.vecteezy.com/system/resources/thumbnails/053/654/065/small/padel-racket-on-a-padel-blue-court-with-a-ball-photo.jpg";
    }

    return "https://images.unsplash.com/photo-1521412644187-c49fa049e84d";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "EVENT",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: const [
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 10),
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),

      body: Column(
        children: [

          const SizedBox(height: 10),

          // FILTER SPORT (UI SAJA)
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                categoryChip("Semua olahraga", true),
                categoryChip("Sepak Bola", false),
                categoryChip("Futsal", false),
                categoryChip("Mini Soccer", false),
                categoryChip("Tenis", false),
                categoryChip("Padel", false),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Event Komunitas",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Lihat Selengkapnya",
                  style: TextStyle(color: Colors.blue),
                )
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: events.isEmpty
                ? const Center(child: Text("Belum ada event"))
                : ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {

                      final event = events[index];

                      return eventCard(event);

                    },
                  ),
          )
        ],
      ),

      // TOMBOL TAMBAH EVENT
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () async {

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateEventPage(),
            ),
          );

          loadEvents();
        },
      ),
    );
  }

  // CHIP SPORT
  Widget categoryChip(String text, bool active) {

    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(text),
        backgroundColor: active ? Colors.blue : Colors.white,
        labelStyle: TextStyle(
          color: active ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  // CARD EVENT
  Widget eventCard(EventModel event) {

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0,4),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(18),
            ),
            child: Stack(
              children: [

                Image.network(
                  getImage(event.sport),
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${event.players} players",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                      ),
                    ),
                  ),
                )

              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  event.sport,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [

                    const Icon(Icons.calendar_today,
                        size: 16,
                        color: Colors.orange),

                    const SizedBox(width: 6),

                    Text("${event.date} • ${event.time}"),

                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  children: [

                    const Icon(Icons.location_on,
                        size: 16,
                        color: Colors.red),

                    const SizedBox(width: 6),

                    Text(event.location),

                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    // DELETE BUTTON
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete Event"),
                            content: const Text(
                              "Are you sure want to delete this event?"
                            ),
                            actions: [

                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),

                              TextButton(
                                onPressed: () {
                                  deleteEvent(event.id!);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              )

                            ],
                          ),
                        );

                      },
                    ),

                    // JOIN BUTTON
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("Join"),
                    )

                  ],
                )

              ],
            ),
          )

        ],
      ),
    );
  }
}