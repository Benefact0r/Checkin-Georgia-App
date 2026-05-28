import 'package:flutter/material.dart';

import 'api.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

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
      theme: AppTheme.light,
      home: HomeScreen(api: CheckinApi()),
    );
  }
}
