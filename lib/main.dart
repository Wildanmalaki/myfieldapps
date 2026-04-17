import 'package:MyField/fieldreview/view/add_review_page.dart';
import 'package:MyField/firebase_options.dart';
import 'package:MyField/views/settings_page.dart';
import 'package:MyField/views/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppThemeController.themeMode,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF5F7FB),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF3A7BFF),
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFF5F7FB),
              foregroundColor: Color(0xFF102033),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF071A2C),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF3A7BFF),
              brightness: Brightness.dark,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF071A2C),
              foregroundColor: Colors.white,
            ),
          ),
          home: SplashScreen(),
          routes: {
            '/reviews': (context) =>
                const AddReviewPage(fieldName: 'Talenta Court'),
          },
        );
      },
    );
  }
}
