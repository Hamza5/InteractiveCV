import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'views.dart';

const firstName = 'Hamza';
const lastName = 'Abbad';
const shortDescription = 'PhD student in computer science and artificial intelligence';
const photoPath = 'images/Photo.jpg';

void main() {
  runApp(const InteractiveCV());
}

class ThemeSettings {
  static const List<Color> colors = [Colors.blue, Colors.green, Colors.red, Colors.brown, Colors.purple];
  final int colorIndex;
  final bool dark;

  const ThemeSettings({required this.colorIndex, required this.dark});

  Color get color => colors[colorIndex];
  Brightness get brightness => dark ? Brightness.dark : Brightness.light;
  ThemeMode get themeMode => dark ? ThemeMode.dark : ThemeMode.light;
  ColorScheme get colorScheme => ColorScheme.fromSeed(seedColor: color, brightness: brightness);

}

class InteractiveCV extends StatelessWidget {

  const InteractiveCV({super.key});
  
  @override
  Widget build(BuildContext context) {
    const useMaterial3 = false;
    final ValueNotifier<ThemeSettings> themeNotifier = ValueNotifier(
      ThemeSettings(
        colorIndex: 0, dark: MediaQuery.platformBrightnessOf(context) == Brightness.dark,
      ),
    );
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, settings, child) {
        final lightThemeSettings = ThemeSettings(colorIndex: settings.colorIndex, dark: false);
        final darkThemeSettings = ThemeSettings(colorIndex: settings.colorIndex, dark: true);
        final lightTheme = ThemeData.light().copyWith(
          colorScheme: lightThemeSettings.colorScheme,
          useMaterial3: useMaterial3,
        );
        return MaterialApp(
          title: 'Interactive CV',
          theme: lightTheme,
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: darkThemeSettings.colorScheme.copyWith(shadow: Colors.white),
            useMaterial3: useMaterial3,
          ),
          themeMode: settings.themeMode,
          color: settings.color,
          home: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              return Theme(
                data: theme.copyWith(
                  cardTheme: theme.cardTheme.copyWith(
                    margin: const EdgeInsets.all(3), elevation: 2, shadowColor: theme.colorScheme.shadow,
                  ),
                  listTileTheme: theme.listTileTheme.copyWith(
                    horizontalTitleGap: 0, contentPadding: const EdgeInsets.all(5),
                  ),
                  appBarTheme: theme.appBarTheme.copyWith(
                    backgroundColor: theme.brightness == Brightness.dark ?
                    theme.colorScheme.secondaryContainer : theme.colorScheme.primary,
                    shadowColor: theme.colorScheme.shadow,
                    titleTextStyle: theme.textTheme.titleLarge?.copyWith(
                      color: theme.brightness == Brightness.dark ?
                      theme.appBarTheme.foregroundColor : theme.colorScheme.onPrimary,
                    ),
                    toolbarTextStyle: theme.textTheme.titleSmall?.copyWith(
                      color: theme.brightness == Brightness.dark ?
                      theme.appBarTheme.foregroundColor : theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                child: MainPage(themeNotifier: themeNotifier),
              );
            }
          ),
        );
      }
    );
  }
}

class MainPage extends StatelessWidget {
  static const List<String> tabTitles = ['Basic', 'Education', 'Work', 'Experience', 'Projects'];
  static const List<IconData> tabIcons = [
    Icons.person, Icons.school, Icons.work, FontAwesomeIcons.screwdriverWrench, FontAwesomeIcons.toolbox,
  ];
  static const List<Widget> tabs = [BasicInfoView(), EducationView(), WorkView(), ExperienceView(), ProjectsView()];
  final ValueNotifier<ThemeSettings> themeNotifier;

  const MainPage({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    pinned: true,
                    toolbarHeight: 100,
                    expandedHeight: 200,
                    forceElevated: innerBoxIsScrolled,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        alignment: AlignmentDirectional.topEnd,
                        child: ColorSelection(themeNotifier: themeNotifier),
                      ),
                      titlePadding: const EdgeInsetsDirectional.symmetric(vertical: 10),
                      title: LayoutBuilder(
                        builder: (context, constraints) {
                          return Align(
                            alignment: const Alignment(0, 0.8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LimitedBox(
                                  maxWidth: constraints.maxWidth * 0.25,
                                  child: CirclePhoto(photo: Image.asset(photoPath).image),
                                ),
                                const SizedBox(width: 5),
                                LimitedBox(
                                  maxWidth: constraints.maxWidth * 0.7,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$firstName $lastName',
                                        style: Theme.of(context).appBarTheme.titleTextStyle,
                                      ),
                                      Text(
                                        shortDescription,
                                        style: Theme.of(context).appBarTheme.toolbarTextStyle,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                ),
              ],
              body: TabBarView(
                children: [
                  for(var tab in tabs) Builder(
                    builder: (context) => CustomScrollView(
                      slivers: [
                        SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                        tab,
                      ],
                    ),
                  ),
                ]
              ),
            ),
            bottomNavigationBar: Material(
              color: Theme.of(context).appBarTheme.backgroundColor,
              elevation: Theme.of(context).bottomAppBarTheme.elevation ?? 0,
              child: TabBar(
                tabs: [for (var i=0; i<tabTitles.length; i++) Tab(text: tabTitles[i], icon: FaIcon(tabIcons[i]))],
                isScrollable: MediaQuery.of(context).size.width < 500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CirclePhoto extends StatelessWidget {
  final ImageProvider photo;

  const CirclePhoto({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).colorScheme.primaryContainer,
            boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5), blurRadius: 5)]
        ),
        child: CircleAvatar(foregroundImage: photo, radius: 48),
      ),
    );
  }
}

class ColorSelection extends StatelessWidget {
  final ValueNotifier<ThemeSettings> themeNotifier;
  const ColorSelection({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var (index, color) in ThemeSettings.colors.indexed)
          IconButton(
            onPressed: () => themeNotifier.value = ThemeSettings(colorIndex: index, dark: themeNotifier.value.dark),
            icon: DecoratedBox(
              decoration: ShapeDecoration(
                shape: const CircleBorder(),
                shadows: [
                  BoxShadow(color: Theme.of(context).colorScheme.shadow, blurRadius: 5, spreadRadius: 0.5),
                ],
              ),
              child: CircleAvatar(backgroundColor: color),
            ),
          ),
        IconButton(
          icon: Icon(themeNotifier.value.dark ? Icons.light_mode : Icons.dark_mode),
          onPressed: () {
            themeNotifier.value = ThemeSettings(
              colorIndex: themeNotifier.value.colorIndex, dark: !themeNotifier.value.dark,
            );
          },
        )
      ],
    );
  }
}
