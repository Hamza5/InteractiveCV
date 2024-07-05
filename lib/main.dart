import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'appbar/circle_photo.dart';
import 'appbar/color_selection.dart';
import 'appbar/language_switch.dart';
import 'appbar/theme_settings.dart';
import 'views/basic_info_view.dart';
import 'views/education_view.dart';
import 'views/experience_view.dart';
import 'views/project_view.dart';
import 'views/reviews_view.dart';
import 'views/work_view.dart';


void main() {
  runApp(const InteractiveCV());
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
                                        color: Theme.of(context).appBarTheme.titleTextStyle?.color?.withOpacity(0.5),
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
                                            Text(
                                              localization.fullName,
                                              style: Theme.of(context).appBarTheme.titleTextStyle,
                                            ),
                                            Text(
                                              localization.shortDescription,
                                              style: Theme.of(context).appBarTheme.toolbarTextStyle,
                                            )
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
