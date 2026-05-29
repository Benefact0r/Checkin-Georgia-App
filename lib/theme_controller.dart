import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the app's ThemeMode, persisted across launches.
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.system);

  static const _key = 'theme_mode';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    value = switch (prefs.getString(_key)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> toggle(Brightness current) async {
    // Flip relative to what's showing now.
    final next =
        current == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    value = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, next == ThemeMode.dark ? 'dark' : 'light');
  }
}

/// App-wide singleton.
final themeController = ThemeController();
