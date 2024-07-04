import 'package:flutter/material.dart';

class ThemeSettings {

  static const List<Color> colors = [Colors.blue, Colors.green, Colors.red, Colors.brown, Colors.purple];
  final int colorIndex;
  final bool dark;
  final String lang;

  const ThemeSettings({required this.colorIndex, required this.dark, required this.lang});

  Color get color => colors[colorIndex];
  Brightness get brightness => dark ? Brightness.dark : Brightness.light;
  ThemeMode get themeMode => dark ? ThemeMode.dark : ThemeMode.light;
  ColorScheme get colorScheme => ColorScheme.fromSeed(seedColor: color, brightness: brightness);
  Locale get locale => Locale(lang);

}
