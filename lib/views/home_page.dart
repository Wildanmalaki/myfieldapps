import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategory = 0;

  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? timer;

  final List<String> categories = [
    "Sepak bola",
    "Minisoccer",
    "Futsal",
    "Basket",
    "Padel",
  ];

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < 5) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0F172A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),

              /// HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    SizedBox(width: 10),

                    Column(
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

                    Spacer(),

                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),

              /// TEXT BESAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Mau main dimana,",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Wildan?",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 205, 27),
                  ),
                ),
              ),

              SizedBox(height: 20),

              /// SEARCH
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Color(0xff1E293B),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.grey),
                    hintText: "Cari lapanganmu..",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),

              SizedBox(height: 20),

              /// CATEGORY
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
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        constraints: BoxConstraints(minWidth: 70),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Color(0xff1E293B),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          categories[index],
                          softWrap: false,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 30),

              /// TITLE
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Lapangan Rekomendasi",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("See All", style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),

              SizedBox(height: 15),

              /// AUTO SLIDER
              SizedBox(
                height: 300,
                child: PageView(
                  controller: _pageController,
                  children: [
                    FeatureCard(
                      title: "Dekings Arena",
                      price: "Rp 700.000 - 1.500.000",
                      imageurl:
                          "https://admin.saraga.id/storage/images/14572131-10154585801270699-3099495380002420769-n_1631619103.jpg",
                      location: "Lubang Buaya",
                      rating: "4.5",
                    ),
                    FeatureCard(
                      title: "Pancoran Soccer Field",
                      price: "Rp 2.240.000 - 3.850.000",
                      imageurl:
                          "https://gelora-public-storage.s3-ap-southeast-1.amazonaws.com/upload/public-20210216090138.jpg",
                      location: "Jakarta Selatan",
                      rating: "4.5",
                    ),
                    FeatureCard(
                      title: "Lapangan Sepakbola C",
                      price: "Rp 1.500.000 - 4.500.000",
                      imageurl:
                          "https://cdn0-production-images-kly.akamaized.net/zXgbXIZi79R94m7KA894EfHB1jQ=/1231x710/smart/filters:quality(75):strip_icc()/kly-media-production/medias/1707784/original/096144000_1505210611-Lapangan-C-Senayan2.jpg",
                      location: "Senayan",
                      rating: "4.5",
                    ),
                    FeatureCard(
                      title: "F7 MINISOCCER ARENA",
                      price: "Rp 500.000 - 1.450.000",
                      imageurl:
                          "https://gelora-public-storage.s3-ap-southeast-1.amazonaws.com/upload/public-20230214134056.jpg",
                      location: "Cilandak",
                      rating: "4.5",
                    ),
                    FeatureCard(
                      title: "Social Padel House Menteng",
                      price: "Rp 180.000 - 400.000",
                      imageurl:
                          "https://images.unsplash.com/photo-1646649853703-7645147474ba?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGFkZWx8ZW58MHx8MHx8fDA%3D",
                      location: "Jakarta Timur",
                      rating: "4.5",
                    ),
                    FeatureCard(
                      title: "BBC Bali",
                      price: "Rp 1.000.000 - 2.500.000",
                      imageurl:
                          "https://asset.ayo.co.id/image/venue/171835445216622.image_cropper_A9B84175-A6F2-42D6-A12D-C80E79027E1A-674-0000002CA2B49FDB_large.jpg",
                      location: "Kota Denpasar, Bali",
                      rating: "4.5",
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Lapangan Terdekat",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.filter_list, color: Colors.white),
                  ],
                ),
              ),

              SizedBox(height: 15),

              NearbyCard(
                title: "Dekings Arena",
                price: "BOOKING",
                distance: "1.9 Km",
                rating: "4.8",
                imageUrl:
                    "https://admin.saraga.id/storage/images/14572131-10154585801270699-3099495380002420769-n_1631619103.jpg",
                tags: ["Football", "Shower", "Parking gratis", "Diskon"],
              ),

              NearbyCard(
                title: "Alfa Rooftop Mini Soccer Tamini Square",
                price: "BOOKING",
                distance: "650 m",
                rating: "4.6",
                imageUrl:
                    "https://asset.ayo.co.id/image/venue/170859795250713.image_cropper_1708597870231.jpg",
                tags: ["Minisoccer", "Parking", "Free WiFi", "Promo!"],
              ),

              NearbyCard(
                title: "Halim Futsal Badminton",
                price: "BOOKING",
                distance: "2.6 Km",
                rating: "4.2",
                imageUrl:
                    "https://asset.ayo.co.id/image/venue/174288649079497.image_cropper_1742886399702.jpg_large.jpeg",
                tags: ["Futsal", "Badminton", "free minuman", "Diskon!"],
              ),
              NearbyCard(
                title: "Talenta Court",
                price: "BOOKING",
                distance: "8.9 Km",
                rating: "4.2",
                imageUrl:
                    "https://asset.ayo.co.id/image/venue/177095980826513.image_cropper_1770959664162.jpg_large.jpeg",
                tags: ["Basketball", "Public"],
              ),
              NearbyCard(
                title: "Arena Dirgantara Mini Soccer",
                price: "BOOKING",
                distance: "18 Km",
                rating: "3.9",
                imageUrl:
                    "https://asset.ayo.co.id/image/venue/175281821762319.image_cropper_1752818166728.jpg_large.jpeg",
                tags: ["Basketball", "Public"],
              ),
              NearbyCard(
                title: "Arena Dirgantara Mini Soccer",
                price: "BOOKING",
                distance: "8.9 Km",
                rating: "4.2",
                imageUrl:
                    "https://asset.ayo.co.id/image/venue/175281821762319.image_cropper_1752818166728.jpg_large.jpeg",
                tags: ["Basketball", "Public"],
              ),
              NearbyCard(
                title: "Arena Dirgantara Mini Soccer",
                price: "BOOKING",
                distance: "8.9 Km",
                rating: "4.2",
                imageUrl:
                    "https://asset.ayo.co.id/image/venue/175281821762319.image_cropper_1752818166728.jpg_large.jpeg",
                tags: ["Basketball", "Public"],
              ),
              NearbyCard(
                title: "Arena Dirgantara Mini Soccer",
                price: "BOOKING",
                distance: "8.9 Km",
                rating: "4.2",
                imageUrl:
                    "https://asset.ayo.co.id/image/venue/175281821762319.image_cropper_1752818166728.jpg_large.jpeg",
                tags: ["Basketball", "Public"],
              ),

              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

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
      width: 300,
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xff1E293B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(price, style: TextStyle(color: Colors.white)),
          SizedBox(height: 5),
          Row(
            children: [
              Text(location, style: TextStyle(color: Colors.white)),
              Spacer(),
              Icon(Icons.location_on_outlined, color: Colors.white),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Text(rating, style: TextStyle(color: Colors.white)),
              Icon(Icons.star, color: Colors.amber, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}

class NearbyCard extends StatelessWidget {
  final String title;
  final String price;
  final String distance;
  final String rating;
  final String imageUrl;
  final List<String> tags;

  const NearbyCard({
    super.key,
    required this.title,
    required this.price,
    required this.distance,
    required this.rating,
    required this.imageUrl,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xff1E293B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 28, backgroundImage: NetworkImage(imageUrl)),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(price, style: TextStyle(color: Colors.blue)),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(distance, style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 10),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    SizedBox(width: 3),
                    Text(rating, style: TextStyle(color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: tags.map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
