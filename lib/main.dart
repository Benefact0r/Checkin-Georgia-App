import 'package:flutter/material.dart';

import 'api.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CheckinApp());
}

class CheckinApp extends StatelessWidget {
  const CheckinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkin Georgia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0EA5E9),
        ),
      ),
      home: HomeScreen(api: CheckinApi()),
    );
  }
}
