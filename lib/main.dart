import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'views.dart';

void main() {
  runApp(const InteractiveCV());
}

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

class InteractiveCV extends StatelessWidget {

  const InteractiveCV({super.key});
  
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<ThemeSettings> themeNotifier = ValueNotifier(
      ThemeSettings(
        colorIndex: 0, dark: MediaQuery.platformBrightnessOf(context) == Brightness.dark,
        lang: 'en',
      ),
    );
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, settings, child) {
        final lightThemeSettings = ThemeSettings(
          colorIndex: settings.colorIndex, dark: false, lang: settings.lang,
        );
        final darkThemeSettings = ThemeSettings(
          colorIndex: settings.colorIndex, dark: true, lang: settings.lang
        );
        final lightTheme = ThemeData.light().copyWith(
          colorScheme: lightThemeSettings.colorScheme,
        );
        return MaterialApp(
          title: 'Interactive CV',
          theme: lightTheme,
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: darkThemeSettings.colorScheme.copyWith(shadow: Colors.white),
          ),
          themeMode: settings.themeMode,
          color: settings.color,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: settings.locale,
          home: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              return Theme(
                data: theme.copyWith(
                  cardTheme: theme.cardTheme.copyWith(
                    margin: const EdgeInsets.all(5), elevation: 1, shadowColor: theme.colorScheme.shadow,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: theme.colorScheme.shadow.withOpacity(0.25), width: 1),
                    ),
                  ),
                  listTileTheme: theme.listTileTheme.copyWith(
                    horizontalTitleGap: 10, contentPadding: const EdgeInsets.all(5),
                  ),
                  appBarTheme: theme.appBarTheme.copyWith(
                    backgroundColor: theme.brightness == Brightness.dark ?
                    theme.colorScheme.secondaryContainer : theme.colorScheme.primary,
                    shadowColor: theme.colorScheme.shadow,
                    titleTextStyle: theme.textTheme.titleLarge?.copyWith(
                      color: theme.brightness == Brightness.dark ?
                      theme.appBarTheme.foregroundColor : theme.colorScheme.onPrimary,
                      height: 1.25,
                    ),
                    toolbarTextStyle: theme.textTheme.titleSmall?.copyWith(
                      color: theme.brightness == Brightness.dark ?
                      theme.appBarTheme.foregroundColor : theme.colorScheme.onPrimary,
                      height: 1.25,
                    ),
                  ),
                  tabBarTheme: theme.tabBarTheme.copyWith(
                    labelColor: theme.brightness == Brightness.dark ?
                    theme.appBarTheme.foregroundColor : theme.colorScheme.onPrimary,
                    unselectedLabelColor: (theme.brightness == Brightness.dark ?
                    theme.appBarTheme.foregroundColor : theme.colorScheme.onPrimary)?.withOpacity(0.5),
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
  static const List<IconData> tabIcons = [
    Icons.person, Icons.school, Icons.work, FontAwesomeIcons.screwdriverWrench, FontAwesomeIcons.toolbox,
    Icons.reviews
  ];
  static const List<Widget> tabs = [
    BasicInfoView(), EducationView(), WorkView(), ExperienceView(), ProjectsView(), ReviewsView()
  ];
  final ValueNotifier<ThemeSettings> themeNotifier;

  const MainPage({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final List<String> tabTitles = [
      localization.basic , localization.education, localization.work, localization.experience, localization.projects,
      localization.reviews
    ];
    return Container(
      color: Theme.of(context).colorScheme.surface,
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth > 1000 ? 50 : 0),
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
                          background: Stack(
                            children: [
                              if (const bool.hasEnvironment('LAST_UPDATE'))
                                Container(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Text(
                                      localization.lastUpdate(DateTime.parse(const String.fromEnvironment('LAST_UPDATE'))),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).appBarTheme.titleTextStyle?.color?.withOpacity(0.5)
                                      ),
                                    ),
                                  ),
                                ),
                              Container(
                                alignment: AlignmentDirectional.topEnd,
                                child: ColorSelection(themeNotifier: themeNotifier),
                              ),
                              Container(
                                alignment: AlignmentDirectional.bottomEnd,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: LanguageSwitch(themeNotifier: themeNotifier),
                                ),
                              )
                            ],
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
                                      child: CirclePhoto(photo: Image.asset(localization.photoPath).image),
                                    ),
                                    const SizedBox(width: 5),
                                    LimitedBox(
                                      maxWidth: constraints.maxWidth * 0.7,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(localization.fullName, style: Theme.of(context).appBarTheme.titleTextStyle),
                                            Text(localization.shortDescription, style: Theme.of(context).appBarTheme.toolbarTextStyle)
                                          ],
                                        ),
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
                    tabAlignment: MediaQuery.of(context).size.width < 500 ? TabAlignment.center : TabAlignment.fill,
                  ),
                ),
              ),
            ),
          );
        }
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

class LanguageSwitch extends StatelessWidget {

  static const supportedLocalesFlagPaths = {
    'ar': 'images/flags/arab-league.png',
    'en': 'images/flags/united-states.png',
    'fr': 'images/flags/france.png',
    'zh': 'images/flags/china.png',
  };
  static String flagImageForLangCode(String langCode) {
    return supportedLocalesFlagPaths[langCode] ?? '';
  }

  String nextLangCode(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final currentIndex = AppLocalizations.supportedLocales.indexOf(currentLocale);
    return AppLocalizations.supportedLocales[(currentIndex + 1) % AppLocalizations.supportedLocales.length].languageCode;
  }

  final ValueNotifier<ThemeSettings> themeNotifier;
  const LanguageSwitch({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {

    return TextButton(
      onPressed: () {
        themeNotifier.value = ThemeSettings(
          colorIndex: themeNotifier.value.colorIndex, dark: themeNotifier.value.dark,
          lang: nextLangCode(context),
        );
      },
      child: Image.asset(flagImageForLangCode(nextLangCode(context)), width: 50, height: 50),
    );
  }
}
