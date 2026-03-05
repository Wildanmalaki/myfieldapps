import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
    
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    

    

  int selectedCategory = 0;

  final List<String> categories = [
    "Sepak bola",
    "Minisoccer",
    "Futsal",
    "Basket",
    "Padel",
  ];

  

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ================= HEADER =================
              const SizedBox(height: 10),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat datang,",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "Wildan Malaki",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 25),

              /// ================= TITLE =================
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Mau main dimana\n",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: "Wildan?",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ================= SEARCH =================
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xff1E293B),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.grey),
                    hintText: "Cari lapanganmu..",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ================= CATEGORY BUTTONS =================
              SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {

                    bool isSelected = selectedCategory == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.green
                              : const Color(0xff1E293B),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              /// ================= FEATURED =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Lapangan Rekomendasi",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    FeatureCard(title: "Dekings Arena", 
                    price: "Rp 700.000 - 1.500.000 ",
                    imageurl: ("https://admin.saraga.id/storage/images/14572131-10154585801270699-3099495380002420769-n_1631619103.jpg"),

                    ),
                    FeatureCard(
                    title: "Pancoran Soccer Field",
                    price: "Rp 2.240.000 - 3.850.000  ",
                    imageurl: ("https://gelora-public-storage.s3-ap-southeast-1.amazonaws.com/upload/public-20210216090138.jpg") 
                    ),
                    FeatureCard(
                    title: "Goedang Sports Centre",
                    price: "Rp 80.000 - 150.000  ",
                    imageurl: "https://lh3.googleusercontent.com/gps-cs-s/AHVAweqOe9o23PeSBqWpJTwc-YBVsRXlPD5XQY5ZX6w4q8H7M3t46wJCVOsYyqthjQ0fdXWMKA8ADqxi79fkiRkJ4YhdYfIV7o7rurCQX7SYukto6u5FyzZdTLDWnldwam3kXTz-lS3M=s680-w680-h510-rw",
                     ),
                    FeatureCard(
                    title: "Tifosi Sport Center", price: "Rp 175.000 - 350.000  ",
                    imageurl: "https://www.indosport.com/views/1/images/tifosi/tifosi_2.jpg",
                    ),
                    FeatureCard(
                    title: "One Padel",
                    price: "Rp 130.000 - 230.000 ",
                    imageurl: "https://asset.ayo.co.id/image/venue/177126892330542.image_cropper_1771268674495.jpg_large.jpeg",
                    ),
                    FeatureCard(
                    title: "SR32 Minisoccer Setia Budi", 
                    price: "Rp 2.240.000 - 3.850.000  ",
                    imageurl: "https://sports-sr32.com/_next/image?url=%2Ffields%2Fmini-soccer%2Fsetiabudi%2Fsetiabudi-1.jpg&w=3840&q=75"),

                    
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// ================= NEARBY =================
              const Text(
                "Lapangan Terdekat",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              const NearbyCard(title: "Pinang Ranti", price: "Mulai dari     Rp 100.000"),
              const NearbyCard(title: "Lubang Buaya", price: "\$30/hr"),
              const NearbyCard(title: "Ragunan", price: "Free"),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

///FEATURED CARD FUNGSINYA DISINI
class FeatureCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageurl;
  final String location;
  final String rating;

  const FeatureCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageurl,
    required this.location,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xff1E293B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// FOTO LAPANGAN
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageurl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),

          ///

          Text(
            title,style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
            ), 
          ),
          SizedBox(height: 5),

          Text(price,
          style: TextStyle(
            color: Colors.white,
          ),)
        ]
      )
    );
  }
}

/// ================= NEARBY CARD =================
class NearbyCard extends StatelessWidget {
  final String title;
  final String price;

  const NearbyCard({
    super.key,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xff1E293B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blueGrey,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            price,
            style: const TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }
}