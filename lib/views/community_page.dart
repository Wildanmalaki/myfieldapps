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
  final Color bgColor = const Color(0xFF121824);
  final Color cardColor = const Color(0xFF1E2736);
  final Color surfaceColor = const Color(0xFF141D2B);
  final Color primaryBlue = const Color(0xFF3B82F6);
  final Color textMuted = const Color(0xFF94A3B8);

  final List<String> categories = const [
    'Semua olahraga',
    'Sepak Bola',
    'Futsal',
    'Mini Soccer',
    'Tenis',
    'Padel',
  ];

  List<EventModel> events = [];
  String selectedCategory = 'Semua olahraga';

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    final data = await DatabaseHelper.instance.getEvents();
    if (!mounted) return;

    setState(() {
      events = data;
    });
  }

  Future<void> deleteEvent(int id) async {
    await DatabaseHelper.instance.deleteEvent(id);
    await loadEvents();
  }

  String getImage(String sport) {
    sport = sport.toLowerCase();

    if (sport.contains('sepak bola')) {
      return 'https://cdn.pixabay.com/photo/2018/06/12/20/17/soccer-3471402_1280.jpg';
    }
    if (sport.contains('futsal')) {
      return 'https://t4.ftcdn.net/jpg/06/84/11/45/360_F_684114561_54bnmuviQhUHO7TTmOjRgW0FRuvq6yip.jpg';
    }
    if (sport.contains('mini soccer')) {
      return 'https://asset.ayo.co.id/image/venue/165243845442977.image_cropper_1652438416406.jpg';
    }
    if (sport.contains('tenis')) {
      return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvFBbblWYBoxlT42x2zUM4HktbkKkMkcVCGA&s';
    }
    if (sport.contains('padel')) {
      return 'https://static.vecteezy.com/system/resources/thumbnails/053/654/065/small/padel-racket-on-a-padel-blue-court-with-a-ball-photo.jpg';
    }

    return 'https://images.unsplash.com/photo-1521412644187-c49fa049e84d';
  }

  List<EventModel> get filteredEvents {
    if (selectedCategory == 'Semua olahraga') {
      return events;
    }

    return events
        .where(
          (event) =>
              event.sport.toLowerCase() == selectedCategory.toLowerCase(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayedEvents = filteredEvents;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localBgColor = isDark ? bgColor : const Color(0xFFF5F7FB);
    final localCardColor = isDark ? cardColor : Colors.white;
    final localSurfaceColor = isDark ? surfaceColor : const Color(0xFFE8EEF8);
    final localTextMuted = isDark ? textMuted : const Color(0xFF66758A);
    final titleColor = isDark ? Colors.white : const Color(0xFF102033);

    return Scaffold(
      backgroundColor: localBgColor,
      body: RefreshIndicator(
        color: primaryBlue,
        backgroundColor: localCardColor,
        onRefresh: loadEvents,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
          children: [
            _buildHeader(localSurfaceColor, localTextMuted, titleColor),
            const SizedBox(height: 24),
            _buildCategoryList(localSurfaceColor, localTextMuted),
            const SizedBox(height: 24),
            _buildSectionTitle(displayedEvents.length, titleColor),
            const SizedBox(height: 14),
            if (displayedEvents.isEmpty)
              _buildEmptyState(localCardColor, localTextMuted, titleColor)
            else
              ...displayedEvents.map(
                (event) => eventCard(
                  event,
                  localCardColor,
                  localSurfaceColor,
                  localTextMuted,
                  titleColor,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        backgroundColor: primaryBlue,
        onPressed: () async {
          await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, animation, secondaryAnimation) =>
                  const CreateEventPage(),
              transitionDuration: const Duration(milliseconds: 180),
              reverseTransitionDuration: const Duration(milliseconds: 180),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                final curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                );

                return FadeTransition(
                  opacity: curvedAnimation,
                  child: child,
                );
              },
            ),
          );
          await loadEvents();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(
    Color surfaceColorValue,
    Color textMutedValue,
    Color titleColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerIconColor =
        isDark ? Colors.white : const Color(0xFF3A7BFF);
    final headerIconBg = isDark
        ? surfaceColorValue
        : const Color(0xFFEAF1FB);

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Community Event',
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cari teman main, atur jadwal, dan gabung ke event olahraga yang lagi aktif.',
                      style: TextStyle(
                        color: textMutedValue,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: headerIconBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : const Color(0xFFD9E5F5),
                  ),
                ),
                child: Icon(
                  Icons.groups_2_rounded,
                  color: headerIconColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryBlue,
                  const Color(0xFF1D4ED8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: primaryBlue.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.groups_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Event tersedia',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${events.length} komunitas aktif',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.flash_on_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Aktif',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(Color surfaceColorValue, Color textMutedValue) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isActive = category == selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: isActive ? primaryBlue : surfaceColorValue,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: isActive
                      ? Colors.transparent
                      : (isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : const Color(0xFFD9E5F5)),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isActive ? Colors.white : textMutedValue,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(int total, Color titleColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Event Komunitas',
          style: TextStyle(
            color: titleColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$total event',
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(
    Color cardColorValue,
    Color textMutedValue,
    Color titleColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColorValue,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: primaryBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(
              Icons.event_busy_outlined,
              color: primaryBlue,
              size: 34,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Belum ada event untuk kategori ini',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: titleColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba pilih kategori lain atau buat event baru untuk mulai mengumpulkan pemain.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textMutedValue,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget eventCard(
    EventModel event,
    Color cardColorValue,
    Color surfaceColorValue,
    Color textMutedValue,
    Color titleColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: cardColorValue,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : const Color(0xFFE2EAF5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            child: Stack(
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Image.network(
                    getImage(event.sport),
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return Container(
                        color: surfaceColorValue,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.8)
                              : primaryBlue,
                          strokeWidth: 2.4,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: surfaceColorValue,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.6)
                              : const Color(0xFF6B7C93),
                          size: 34,
                        ),
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.08),
                          Colors.black.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${event.players} players',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  bottom: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: primaryBlue.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      event.sport,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Butuh ${event.players} pemain untuk sesi ${event.sport.toLowerCase()}.',
                  style: TextStyle(
                    color: textMutedValue,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: surfaceColorValue,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        Icons.calendar_today_rounded,
                        '${event.date} - ${event.time}',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.location_on_outlined, event.location),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFF87171),
                        side: BorderSide(
                          color:
                              const Color(0xFFF87171).withValues(alpha: 0.35),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: cardColorValue,
                            title: Text(
                              'Hapus Event',
                              style: TextStyle(color: titleColor),
                            ),
                            content: Text(
                              'Event ini akan dihapus dari daftar komunitas.',
                              style: TextStyle(color: textMutedValue),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Batal',
                                  style: TextStyle(color: textMutedValue),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  deleteEvent(event.id!);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Hapus',
                                  style: TextStyle(
                                    color: Color(0xFFF87171),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: const Text('Hapus'),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.sports_handball_rounded, size: 18),
                      label: const Text('Join Event'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rowMuted = isDark ? textMuted : const Color(0xFF66758A);
    return Row(
      children: [
        Icon(icon, size: 18, color: rowMuted),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: rowMuted,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
