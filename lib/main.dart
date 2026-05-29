import 'package:flutter/material.dart';

import 'api.dart';
import 'screens/home_screen.dart';
import 'theme.dart';
import 'theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await themeController.load();
  runApp(const CheckinApp());
}

class CheckinApp extends StatelessWidget {
  const CheckinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, mode, _) => MaterialApp(
        title: 'Checkin Georgia',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: mode,
        home: HomeScreen(api: CheckinApi()),
      ),
    );
  }
}
