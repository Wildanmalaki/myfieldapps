import 'dart:convert';
import 'package:MyField/views/detail_booking.dart';
import 'package:MyField/models/user_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  final UserModel currentUser;

  const HomePage({super.key, required this.currentUser});

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

  String get displayFirstName {
    final username = widget.currentUser.username.trim();
    final rawName = username.isNotEmpty
        ? username.split(RegExp(r'\s+')).first.trim()
        : widget.currentUser.displayName.trim();
    if (rawName.isEmpty) return "Member";

    final source = rawName.contains('@') ? rawName.split('@').first : rawName;
    final cleaned = source.replaceAll(RegExp(r'[._-]+'), ' ').trim();
    final parts = cleaned
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return "Member";

    final first = parts.first;
    return first[0].toUpperCase() + first.substring(1).toLowerCase();
  }

  ImageProvider? get profileImage {
    final photoUrl = widget.currentUser.photoUrl.trim();
    if (photoUrl.isEmpty) return null;

    if (photoUrl.startsWith('http://') || photoUrl.startsWith('https://')) {
      return NetworkImage(photoUrl);
    }

    try {
      return MemoryImage(base64Decode(photoUrl));
    } catch (_) {
      return null;
    }
  }

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xff0F172A) : const Color(0xFFF5F7FB);
    final sectionColor = isDark ? Colors.white : const Color(0xFF102033);
    final mutedColor = isDark ? Colors.grey : const Color(0xFF64748B);
    final cardColor = isDark ? const Color(0xff1E293B) : Colors.white;
    final chipColor =
        isDark ? const Color(0xff1E293B) : const Color(0xFFE8EEF8);
    final heroAccent = isDark
        ? const Color.fromARGB(255, 255, 205, 27)
        : const Color(0xFFF59E0B);
    final selectedChipColor = isDark ? heroAccent : const Color(0xFF3A7BFF);
    final accentColor = isDark ? heroAccent : const Color(0xFF3A7BFF);
    final headerPanelColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : const Color(0xFFEAF1FB);
    final headerIconColor = isDark ? accentColor : const Color(0xFF3A7BFF);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              /// HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: headerPanelColor,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 19,
                        backgroundColor: const Color(0xFF0B3A66),
                        backgroundImage: profileImage,
                        child: profileImage == null
                            ? Text(
                                displayFirstName[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selamat datang,",
                          style: TextStyle(
                            color: mutedColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "$displayFirstName!",
                          style: TextStyle(
                            color: sectionColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: headerPanelColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_none,
                        color: headerIconColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// TEXT BESAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "Mau main dimana,",
                  style: TextStyle(
                    fontSize: 22,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                    color: sectionColor,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "$displayFirstName?",
                  style: TextStyle(
                    fontSize: 22,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              /// SEARCH
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 3,
                ), // Tambahan margin agar sejajar
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // Ubah radius agar lebih smooth
                ),
                child: TextField(
                  style: TextStyle(color: sectionColor),
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: mutedColor),
                    hintText: "Cari lapanganmu..",
                    hintStyle: TextStyle(color: mutedColor),
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
                        margin: EdgeInsets.only(
                          left: index == 0 ? 10 : 0,
                          right: 10,
                        ), // Padding awal
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        constraints: BoxConstraints(minWidth: 70),
                        decoration: BoxDecoration(
                          color: isSelected ? selectedChipColor : chipColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          categories[index],
                          softWrap: false,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            color: isSelected ? Colors.white : mutedColor,
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
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Lapangan Rekomendasi",
                      style: TextStyle(
                        color: sectionColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("See All", style: TextStyle(color: accentColor)),
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
                      isDark: isDark,
                      title: "Dekings Arena",
                      price: "Rp 700.000 - 1.500.000",
                      imageurl:
                          "https://admin.saraga.id/storage/images/14572131-10154585801270699-3099495380002420769-n_1631619103.jpg",
                      location: "Lubang Buaya",
                      rating: "4.5",
                    ),
                    FeatureCard(
                      isDark: isDark,
                      title: "Pancoran Soccer Field",
                      price: "Rp 2.240.000 - 3.850.000",
                      imageurl:
                          "https://gelora-public-storage.s3-ap-southeast-1.amazonaws.com/upload/public-20210216090138.jpg",
                      location: "Jakarta Selatan",
                      rating: "4.5",
                    ),
                    FeatureCard(
                      isDark: isDark,
                      title: "Lapangan Sepakbola C",
                      price: "Rp 1.500.000 - 4.500.000",
                      imageurl:
                          "https://cdn0-production-images-kly.akamaized.net/zXgbXIZi79R94m7KA894EfHB1jQ=/1231x710/smart/filters:quality(75):strip_icc()/kly-media-production/medias/1707784/original/096144000_1505210611-Lapangan-C-Senayan2.jpg",
                      location: "Senayan",
                      rating: "4.5",
                    ),
                    FeatureCard(
                      isDark: isDark,
                      title: "F7 MINISOCCER ARENA",
                      price: "Rp 500.000 - 1.450.000",
                      imageurl:
                          "https://gelora-public-storage.s3-ap-southeast-1.amazonaws.com/upload/public-20230214134056.jpg",
                      location: "Cilandak",
                      rating: "4.5",
                    ),
                    FeatureCard(
                      isDark: isDark,
                      title: "Social Padel House Menteng",
                      price: "Rp 180.000 - 400.000",
                      imageurl:
                          "https://images.unsplash.com/photo-1646649853703-7645147474ba?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGFkZWx8ZW58MHx8MHx8fDA%3D",
                      location: "Jakarta Timur",
                      rating: "4.5",
                    ),
                    FeatureCard(
                      isDark: isDark,
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
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text(
                      "Lapangan Terdekat",
                      style: TextStyle(
                        color: sectionColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.filter_list, color: sectionColor),
                  ],
                ),
              ),

              SizedBox(height: 15),

              NearbyCard(
                title: "Dekings Arena",
                price: "Rp 1.500.000",
                distance: "1.9 Km",
                rating: "4.8",
                imageUrl:
                    "https://admin.saraga.id/storage/images/14572131-10154585801270699-3099495380002420769-n_1631619103.jpg",
                tags: ["Football", "Shower", "Parking gratis", "Diskon"],
                currentUser: widget.currentUser,
              ),

              NearbyCard(
                title: "Alfa Rooftop Mini Soccer Tamini Square",
                price: "Rp 2.500.000",
                distance: "650 m",
                rating: "4.6",
                imageUrl:
                    "https://asset.ayo.co.id/image/venue/170859795250713.image_cropper_1708597870231.jpg",
                tags: ["Minisoccer", "Parking", "Free WiFi", "Promo!"],
                currentUser: widget.currentUser,
              ),

              NearbyCard(
                title: "Halim Futsal Badminton",
                price: "Rp 200.000",
                distance: "2.6 Km",
                rating: "4.2",
                imageUrl:
                    "https://asset.ayo.co.id/image/venue/174288649079497.image_cropper_1742886399702.jpg_large.jpeg",
                tags: ["Futsal", "Badminton", "free minuman", "Diskon!"],
                currentUser: widget.currentUser,
              ),
              NearbyCard(
                title: "Talenta Court",
                price: "Rp 400.000",
                distance: "8.9 Km",
                rating: "4.2",
                imageUrl:
                    "https://asset.ayo.co.id/image/venue/177095980826513.image_cropper_1770959664162.jpg_large.jpeg",
                tags: ["Basketball", "Public"],
                currentUser: widget.currentUser,
              ),
              NearbyCard(
                title: "Arena Dirgantara Mini Soccer",
                price: "Rp 600.000",
                distance: "18 Km",
                rating: "3.9",
                imageUrl:
                    "https://asset.ayo.co.id/image/venue/175281821762319.image_cropper_1752818166728.jpg_large.jpeg",
                tags: ["Basketball", "Public"],
                currentUser: widget.currentUser,
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
  final bool isDark;
  final String title;
  final String price;
  final String imageurl;
  final String location;
  final String rating;

  const FeatureCard({
    super.key,
    required this.isDark,
    required this.title,
    required this.price,
    required this.imageurl,
    required this.location,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xff1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF102033);
    final mutedColor = isDark ? Colors.white70 : const Color(0xFF66758A);

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardColor,
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
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(price, style: TextStyle(color: textColor)),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(location, style: TextStyle(color: mutedColor)),
              const Spacer(),
              Icon(Icons.location_on_outlined, color: mutedColor),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(rating, style: TextStyle(color: textColor)),
              const Icon(Icons.star, color: Colors.amber, size: 20),
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
  final UserModel currentUser;

  const NearbyCard({
    super.key,
    required this.title,
    required this.price,
    required this.distance,
    required this.rating,
    required this.imageUrl,
    required this.tags,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xff1E293B) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF102033);
    final mutedColor = isDark ? Colors.grey : const Color(0xFF66758A);

    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 28, backgroundImage: NetworkImage(imageUrl)),
          const SizedBox(width: 15),
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
                          color: titleColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    /// PERUBAHAN ADA DI SINI: TextButton untuk Booking
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF3A7BFF),
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    DetailBooking(
                                      namaLapangan: title,
                                      lokasi: distance,
                                      rating: double.parse(rating),
                                      gambar: imageUrl,
                                      harga: price,
                                      currentUser: currentUser,
                                    ),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                      child: Text("BOOKING"),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(distance, style: TextStyle(color: mutedColor)),
                    SizedBox(width: 10),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    SizedBox(width: 3),
                    Text(rating, style: TextStyle(color: mutedColor)),
                  ],
                ),
                SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: tags.map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black26
                            : const Color(0xFFE8EEF8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF102033),
                          fontSize: 11,
                        ),
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
