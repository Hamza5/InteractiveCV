import 'package:flutter/material.dart';

import 'theme_settings.dart';

class ColorSelection extends StatelessWidget {
  final ValueNotifier<ThemeSettings> themeNotifier;
  const ColorSelection({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var (index, color) in ThemeSettings.colors.indexed)
          IconButton(
            onPressed: () => themeNotifier.value = ThemeSettings(
                colorIndex: index, dark: themeNotifier.value.dark, lang: themeNotifier.value.lang
            ),
            icon: DecoratedBox(
              decoration: ShapeDecoration(
                shape: const CircleBorder(),
                shadows: [
                  BoxShadow(color: Theme.of(context).colorScheme.shadow.withOpacity(0.5), blurRadius: 3),
                ],
              ),
              child: CircleAvatar(backgroundColor: color, radius: 5),
            ),
            padding: const EdgeInsets.all(0),
          ),
        IconButton(
          padding: const EdgeInsets.all(0),
          icon: Icon(themeNotifier.value.dark ? Icons.light_mode : Icons.dark_mode),
          onPressed: () {
            themeNotifier.value = ThemeSettings(
              colorIndex: themeNotifier.value.colorIndex, dark: !themeNotifier.value.dark,
              lang: themeNotifier.value.lang,
            );
          },
        )
      ],
    );
  }
}