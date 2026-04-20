import 'package:flutter/material.dart';
import 'login_page.dart';

class AppThemeController {
  AppThemeController._();

  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier(ThemeMode.light);

  static bool get isDarkMode => themeMode.value == ThemeMode.dark;

  static void setDarkMode(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppThemeController.themeMode,
      builder: (context, themeMode, _) {
        final isDark = themeMode == ThemeMode.dark;
        final backgroundColor =
            isDark ? const Color(0xFF071A2C) : const Color(0xFFF5F7FB);
        final cardColor = isDark ? const Color(0xFF0E2A47) : Colors.white;
        final titleColor =
            isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
        final subtitleColor =
            isDark ? const Color(0xFFAFC0D4) : const Color(0xFF64748B);
        final sectionLabelColor =
            isDark ? const Color(0xFF7DD3FC) : const Color(0xFF2563EB);
        final dividerColor = isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.06);

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            title: Text(
              'Pengaturan',
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(color: titleColor),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.18)
                          : const Color(0xFF102033).withValues(alpha: 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PREFERENSI',
                      style: TextStyle(
                        color: sectionLabelColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Pengaturan',
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Atur tampilan aplikasi dan beberapa preferensi dasar akun kamu.',
                      style: TextStyle(
                        color: subtitleColor,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.18)
                          : const Color(0xFF102033).withValues(alpha: 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: isDark,
                      activeThumbColor: const Color(0xFF3A7BFF),
                      title: Text(
                        'Mode Gelap',
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        isDark
                            ? 'Tampilan aplikasi sedang menggunakan mode gelap.'
                            : 'Tampilan aplikasi sedang menggunakan mode terang.',
                        style: TextStyle(color: subtitleColor),
                      ),
                      secondary: Icon(
                        isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        color: const Color(0xFF3A7BFF),
                      ),
                      onChanged: AppThemeController.setDarkMode,
                    ),
                    Divider(
                      height: 1,
                      color: dividerColor,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.notifications_active_outlined,
                        color: Color(0xFF3A7BFF),
                      ),
                      title: Text(
                        'Notifikasi',
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Pengaturan notifikasi akan ditambahkan berikutnya.',
                        style: TextStyle(color: subtitleColor),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: dividerColor,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.privacy_tip_outlined,
                        color: Color(0xFF3A7BFF),
                      ),
                      title: Text(
                        'Privasi Akun',
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Kelola preferensi privasi dan data akun kamu.',
                        style: TextStyle(color: subtitleColor),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: dividerColor,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.logout_rounded,
                        color: Color(0xFFF87171),
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Keluar dari akun dan kembali ke halaman login.',
                        style: TextStyle(color: subtitleColor),
                      ),
                      onTap: () async {
                        final shouldLogout = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            backgroundColor: cardColor,
                            title: Text(
                              'Logout akun?',
                              style: TextStyle(
                                color: titleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              'Kamu akan keluar dari akun saat ini dan perlu login lagi untuk masuk.',
                              style: TextStyle(color: subtitleColor),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(dialogContext, false),
                                child: Text(
                                  'Batal',
                                  style: TextStyle(color: subtitleColor),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF87171),
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () =>
                                    Navigator.pop(dialogContext, true),
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );

                        if (shouldLogout != true || !context.mounted) return;

                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
