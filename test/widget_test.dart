import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:MyField/views/splash.dart';

void main() {
  testWidgets('Splash screen renders welcome text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(),
      ),
    );

    expect(find.text('Selamat Datang di Aplikasi Kami'), findsOneWidget);
    expect(find.text('BETA '), findsOneWidget);
  });
}
