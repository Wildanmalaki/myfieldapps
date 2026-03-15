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

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  String getImage(String sport) {

    sport = sport.toLowerCase();

    if (sport.contains("Sepak Bola")) {
      return "https://cdn.pixabay.com/photo/2018/06/12/20/17/soccer-3471402_1280.jpg";
    }

    if (sport.contains("basket")) {
      return "https://images.unsplash.com/photo-1546519638-68e109498ffc?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8d2FsbHBhcGVyJTIwYmFza2V0fGVufDB8fDB8fHww";
    }

    if (sport.contains("futsal")) {
      return "https://png.pngtree.com/thumb_back/fh260/background/20220610/pngtree-old-yellow-futsal-ball-on-blue-ground-score-background-goal-photo-image_31337294.jpg";
    }

    if (sport.contains("tenis")) {
      return "https://wallpapers.com/images/featured/tennis-pictures-9wprnsvgkmw77f02.jpg";
    }

    if (sport.contains("padel")) {
      return "https://pinqpadel.com/cdn/shop/articles/2.0IMG_3835.png?v=1753295770&width=1100";
    }
    if (sport.contains("minisoccer")) {
      return "https://asset.ayo.co.id/image/venue/165243845442977.image_cropper_1652438416406.jpg";
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
          "Explore Events",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
          ),
        ),
        actions: const [
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 10),
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 10)
        ],
      ),

      body: Column(
        children: [

          const SizedBox(height: 10),

          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [

                categoryChip("All Sports", true),
                categoryChip("Soccer", false),
                categoryChip("Basketball", false),
                categoryChip("Futsal", false),

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
                  "Community Matches",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("View Map", style: TextStyle(color: Colors.blue))
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

                }
            ),
          )
        ],
      ),

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

  Widget eventCard(EventModel event) {

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0,4),
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