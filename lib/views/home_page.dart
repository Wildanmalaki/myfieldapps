import 'dart:convert';
import 'dart:typed_data';
import 'package:MyField/views/detail_booking.dart';
import 'package:MyField/models/user_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class _FieldPriceData {
  final String title;
  final String priceLabel;
  final int oneHourPrice;
  final int twoHourPrice;
  final String imageUrl;
  final String location;
  final String rating;

  const _FieldPriceData({
    required this.title,
    required this.priceLabel,
    required this.oneHourPrice,
    required this.twoHourPrice,
    required this.imageUrl,
    required this.location,
    required this.rating,
  });
}

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
  bool _hasShownPromoDialog = false;
  final List<_FieldPriceData> _featuredFieldCards = const [
    _FieldPriceData(
      title: 'Dekings Arena',
      priceLabel: 'Rp 700.000 / 1 jam | Rp 1.500.000 / 2 jam',
      oneHourPrice: 700000,
      twoHourPrice: 1500000,
      imageUrl:
          'https://admin.saraga.id/storage/images/14572131-10154585801270699-3099495380002420769-n_1631619103.jpg',
      location: 'Lubang Buaya',
      rating: '4.5',
    ),
    _FieldPriceData(
      title: 'Pancoran Soccer Field',
      priceLabel: 'Rp 2.240.000 / 1 jam | Rp 3.850.000 / 2 jam',
      oneHourPrice: 2240000,
      twoHourPrice: 3850000,
      imageUrl:
          'https://gelora-public-storage.s3-ap-southeast-1.amazonaws.com/upload/public-20210216090138.jpg',
      location: 'Jakarta Selatan',
      rating: '4.5',
    ),
    _FieldPriceData(
      title: 'Lapangan Sepakbola C',
      priceLabel: 'Rp 1.500.000 / 1 jam | Rp 4.500.000 / 2 jam',
      oneHourPrice: 1500000,
      twoHourPrice: 4500000,
      imageUrl:
          'https://cdn0-production-images-kly.akamaized.net/zXgbXIZi79R94m7KA894EfHB1jQ=/1231x710/smart/filters:quality(75):strip_icc()/kly-media-production/medias/1707784/original/096144000_1505210611-Lapangan-C-Senayan2.jpg',
      location: 'Senayan',
      rating: '4.5',
    ),
    _FieldPriceData(
      title: 'F7 MINISOCCER ARENA',
      priceLabel: 'Rp 500.000 / 1 jam | Rp 1.450.000 / 2 jam',
      oneHourPrice: 500000,
      twoHourPrice: 1450000,
      imageUrl:
          'https://gelora-public-storage.s3-ap-southeast-1.amazonaws.com/upload/public-20230214134056.jpg',
      location: 'Cilandak',
      rating: '4.5',
    ),
    _FieldPriceData(
      title: 'Social Padel House Menteng',
      priceLabel: 'Rp 180.000 / 1 jam | Rp 400.000 / 2 jam',
      oneHourPrice: 180000,
      twoHourPrice: 400000,
      imageUrl:
          'https://images.unsplash.com/photo-1646649853703-7645147474ba?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGFkZWx8ZW58MHx8MHx8fDA%3D',
      location: 'Jakarta Timur',
      rating: '4.5',
    ),
    _FieldPriceData(
      title: 'BBC Bali',
      priceLabel: 'Rp 1.000.000 / 1 jam | Rp 2.500.000 / 2 jam',
      oneHourPrice: 1000000,
      twoHourPrice: 2500000,
      imageUrl:
          'https://asset.ayo.co.id/image/venue/171835445216622.image_cropper_A9B84175-A6F2-42D6-A12D-C80E79027E1A-674-0000002CA2B49FDB_large.jpg',
      location: 'Kota Denpasar, Bali',
      rating: '4.5',
    ),
  ];
  final List<String> categories = [
    "Sepak bola",
    "Minisoccer",
    "Futsal",
    "Basket",
    "Padel",
  ];
  final List<Map<String, String>> _promoBanners = const [
    {
      'image': 'assets/images/Promo_lapangan_satu.png',
      'title': 'Promo Booking Pagi',
      'subtitle': 'Diskon spesial untuk slot pagi hari pilihan minggu ini.',
    },
    {
      'image': 'assets/images/Promo_lapangan_2_dua.png',
      'title': 'Weekend Flash Deal',
      'subtitle': 'Harga lebih hemat untuk booking rame-rame di akhir pekan.',
    },
  ];

  String get displayFirstName {
    final username = widget.currentUser.username.trim();
    final rawName = username.isNotEmpty
        ? username.split(RegExp(r'\s+')).first.trim()
        : widget.currentUser.displayName.trim();
    if (rawName.isEmpty) return "Member";

    final source = rawName.contains('@') ? rawName.split('@').first : rawName;
    final cleaned = source.replaceAll(RegExp(r'[._-]+'), ' ').trim();
    final parts =
        cleaned.split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();

    if (parts.isEmpty) return "Member";

    final first = parts.first;
    return first[0].toUpperCase() + first.substring(1).toLowerCase();
  }

  Uint8List? get profileImageBytes {
    final photoUrl = widget.currentUser.photoUrl.trim();
    if (photoUrl.isEmpty) return null;

    try {
      final payload =
          photoUrl.contains(',') ? photoUrl.split(',').last.trim() : photoUrl;
      return base64Decode(payload);
    } catch (_) {
      return null;
    }
  }

  String get profileImageUrl {
    final photoUrl = widget.currentUser.photoUrl.trim();
    if (photoUrl.startsWith('http://') || photoUrl.startsWith('https://')) {
      return photoUrl;
    }
    return '';
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _hasShownPromoDialog) return;
      _hasShownPromoDialog = true;
      _showPromoDialog();
    });

    timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (!_pageController.hasClients || _featuredFieldCards.isEmpty) return;

      _currentPage = (_currentPage + 1) % _featuredFieldCards.length;

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
    final headerPanelColor =
        isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFEAF1FB);
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
                        child: _buildHeaderAvatar(),
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
                    GestureDetector(
                      onTap: _showPromoDialog,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: headerPanelColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.local_offer_outlined,
                          color: headerIconColor,
                          size: 20,
                        ),
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _buildPromoSpotlight(
                  isDark,
                  sectionColor,
                  mutedColor,
                  accentColor,
                ),
              ),

              SizedBox(height: 28),

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
                child: PageView.builder(
                  controller: _pageController,
                  allowImplicitScrolling: true,
                  itemCount: _featuredFieldCards.length,
                  onPageChanged: (index) {
                    _currentPage = index;
                  },
                  itemBuilder: (context, index) {
                    final field = _featuredFieldCards[index];
                    return FeatureCard(
                      key: ValueKey(field.imageUrl),
                      isDark: isDark,
                      title: field.title,
                      price: field.priceLabel,
                      oneHourPrice: field.oneHourPrice,
                      twoHourPrice: field.twoHourPrice,
                      imageurl: field.imageUrl,
                      location: field.location,
                      rating: field.rating,
                      currentUser: widget.currentUser,
                    );
                  },
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
                price: "Rp 750.000 / 1 jam • Rp 1.500.000 / 2 jam",
                oneHourPrice: 750000,
                twoHourPrice: 1500000,
                distance: "1.9 Km",
                rating: "4.8",
                imageUrl:
                    "https://admin.saraga.id/storage/images/14572131-10154585801270699-3099495380002420769-n_1631619103.jpg",
                tags: ["Football", "Shower", "Parking gratis", "Diskon"],
                currentUser: widget.currentUser,
              ),

              NearbyCard(
                title: "Alfa Rooftop Mini Soccer Tamini Square",
                price: "Rp 1.250.000 / 1 jam • Rp 2.500.000 / 2 jam",
                oneHourPrice: 1250000,
                twoHourPrice: 2500000,
                distance: "650 m",
                rating: "4.6",
                imageUrl:
                    "https://asset.ayo.co.id/image/venue/170859795250713.image_cropper_1708597870231.jpg",
                tags: ["Minisoccer", "Parking", "Free WiFi", "Promo!"],
                currentUser: widget.currentUser,
              ),

              NearbyCard(
                title: "Halim Futsal Badminton",
                price: "Rp 100.000 / 1 jam • Rp 200.000 / 2 jam",
                oneHourPrice: 100000,
                twoHourPrice: 200000,
                distance: "2.6 Km",
                rating: "4.2",
                imageUrl:
                    "https://asset.ayo.co.id/image/venue/174288649079497.image_cropper_1742886399702.jpg_large.jpeg",
                tags: ["Futsal", "Badminton", "free minuman", "Diskon!"],
                currentUser: widget.currentUser,
              ),
              NearbyCard(
                title: "Talenta Court",
                price: "Rp 200.000 / 1 jam • Rp 400.000 / 2 jam",
                oneHourPrice: 200000,
                twoHourPrice: 400000,
                distance: "8.9 Km",
                rating: "4.2",
                imageUrl:
                    "https://asset.ayo.co.id/image/venue/177095980826513.image_cropper_1770959664162.jpg_large.jpeg",
                tags: ["Basketball", "Public"],
                currentUser: widget.currentUser,
              ),
              NearbyCard(
                title: "Arena Dirgantara Mini Soccer",
                price: "Rp 300.000 / 1 jam • Rp 600.000 / 2 jam",
                oneHourPrice: 300000,
                twoHourPrice: 600000,
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

  Widget _buildHeaderAvatar() {
    if (profileImageBytes != null) {
      return ClipOval(
        child: Image.memory(
          profileImageBytes!,
          width: 38,
          height: 38,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => _buildHeaderAvatarFallback(),
        ),
      );
    }

    if (profileImageUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          profileImageUrl,
          width: 38,
          height: 38,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildHeaderAvatarFallback(),
        ),
      );
    }

    return _buildHeaderAvatarFallback();
  }

  Widget _buildHeaderAvatarFallback() {
    return Center(
      child: Text(
        displayFirstName[0],
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPromoSpotlight(
    bool isDark,
    Color titleColor,
    Color subtitleColor,
    Color accentColor,
  ) {
    final promo = _promoBanners.first;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF123A65), Color(0xFF1D4ED8)]
              : const [Color(0xFFEAF1FB), Color(0xFFDCE8FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _showPromoDialog,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      promo['image']!,
                      width: 82,
                      height: 82,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.16)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Promo Aktif',
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          promo['title']!,
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          promo['subtitle']!,
                          style: TextStyle(
                            color: subtitleColor,
                            fontSize: 12.5,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.chevron_right_rounded, color: accentColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showPromoDialog() async {
    if (!mounted) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0E2A47) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF102033);
    final subtitleColor =
        isDark ? const Color(0xFFAFC0D4) : const Color(0xFF66758A);
    final accentColor = isDark
        ? const Color.fromARGB(255, 255, 205, 27)
        : const Color(0xFF3A7BFF);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final screenHeight = MediaQuery.of(dialogContext).size.height;
        final dialogMaxHeight = screenHeight * 0.76;
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: dialogMaxHeight),
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Promo Lapangan',
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Lagi ada penawaran menarik buat booking berikutnya.',
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 13,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        icon: Icon(Icons.close_rounded, color: titleColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Flexible(
                    child: PageView.builder(
                      itemCount: _promoBanners.length,
                      itemBuilder: (context, index) {
                        final promo = _promoBanners[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == _promoBanners.length - 1 ? 0 : 10,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.04)
                                  : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      constraints: const BoxConstraints(
                                        minHeight: 320,
                                        maxHeight: 420,
                                      ),
                                      color: isDark
                                          ? const Color(0xFF102A44)
                                          : const Color(0xFFF1F5F9),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 10,
                                      ),
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        promo['image']!,
                                        width: double.infinity,
                                        fit: BoxFit.contain,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      14,
                                      16,
                                      16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          promo['title']!,
                                          style: TextStyle(
                                            color: titleColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          promo['subtitle']!,
                                          style: TextStyle(
                                            color: subtitleColor,
                                            fontSize: 13,
                                            height: 1.45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor:
                            isDark ? const Color(0xFF102033) : Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Lihat Nanti',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class FeatureCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final String price;
  final int oneHourPrice;
  final int twoHourPrice;
  final String imageurl;
  final String location;
  final String rating;
  final UserModel currentUser;

  const FeatureCard({
    super.key,
    required this.isDark,
    required this.title,
    required this.price,
    required this.oneHourPrice,
    required this.twoHourPrice,
    required this.imageurl,
    required this.location,
    required this.rating,
    required this.currentUser,
  });

  String get oneHourPriceLabel => 'Rp ${_formatCurrency(oneHourPrice)} / 1 jam';

  String _formatCurrency(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final reversedIndex = digits.length - i;
      buffer.write(digits[i]);
      if (reversedIndex > 1 && reversedIndex % 3 == 1) {
        buffer.write('.');
      }
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xff1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF102033);
    final mutedColor = isDark ? Colors.white70 : const Color(0xFF66758A);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                DetailBooking(
              namaLapangan: title,
              lokasi: location,
              rating: double.parse(rating),
              gambar: imageurl,
              harga: price,
              harga1Jam: oneHourPrice,
              harga2Jam: twoHourPrice,
              currentUser: currentUser,
            ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
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
                child: _NetworkCardImage(imageUrl: imageurl),
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
            Text(oneHourPriceLabel, style: TextStyle(color: textColor)),
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
      ),
    );
  }
}

class _NetworkCardImage extends StatelessWidget {
  final String imageUrl;

  const _NetworkCardImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final placeholderColor =
        isDark ? const Color(0xFF0F172A) : const Color(0xFFEAF1FB);
    final iconColor = isDark ? Colors.white70 : const Color(0xFF64748B);

    return Image.network(
      imageUrl,
      width: double.infinity,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 180),
            child: child,
          );
        }

        return Container(
          color: placeholderColor,
          alignment: Alignment.center,
          child: Icon(Icons.image_outlined, color: iconColor, size: 28),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: placeholderColor,
          alignment: Alignment.center,
          child: Icon(Icons.broken_image_outlined, color: iconColor, size: 28),
        );
      },
    );
  }
}

class NearbyCard extends StatelessWidget {
  final String title;
  final String price;
  final int oneHourPrice;
  final int twoHourPrice;
  final String distance;
  final String rating;
  final String imageUrl;
  final List<String> tags;
  final UserModel currentUser;

  const NearbyCard({
    super.key,
    required this.title,
    required this.price,
    required this.oneHourPrice,
    required this.twoHourPrice,
    required this.distance,
    required this.rating,
    required this.imageUrl,
    required this.tags,
    required this.currentUser,
  });

  String get oneHourPriceLabel => 'Rp ${_formatCurrency(oneHourPrice)} / 1 jam';

  String _formatCurrency(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final reversedIndex = digits.length - i;
      buffer.write(digits[i]);
      if (reversedIndex > 1 && reversedIndex % 3 == 1) {
        buffer.write('.');
      }
    }
    return buffer.toString();
  }

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
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFEAF1FB),
              borderRadius: BorderRadius.circular(18),
            ),
            clipBehavior: Clip.antiAlias,
            child: _NetworkCardImage(imageUrl: imageUrl),
          ),
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
                              harga1Jam: oneHourPrice,
                              harga2Jam: twoHourPrice,
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
                    Text(
                      oneHourPriceLabel,
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
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
                        color:
                            isDark ? Colors.black26 : const Color(0xFFE8EEF8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color:
                              isDark ? Colors.white : const Color(0xFF102033),
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
