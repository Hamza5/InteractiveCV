import 'package:universal_html/html.dart' show window;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'appbar/appbar.dart';
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

class MainPage extends StatefulWidget {
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
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {

  late final TabController _tabController;

  int getCurrentTabFromUri() {
    final uri = Uri.base;
    final tab = uri.queryParameters['tab'];
    final tabIndex = tab != null ? int.tryParse(tab) ?? 0 : 0;
    return tabIndex.clamp(0, MainPage.tabs.length - 1);
  }

  void setCurrentTabToUri(int index) {
    final uri = Uri.base;
    final newUri = uri.replace(queryParameters: {'tab': index.toString()});
    window.history.replaceState(null, '', newUri.toString());
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: MainPage.tabs.length, vsync: this, initialIndex: getCurrentTabFromUri());
    _tabController.addListener(() {
      setCurrentTabToUri(_tabController.index);
    });
  }

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
            child: Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
                  buildAppBar(context, innerBoxIsScrolled, widget.themeNotifier),
                ],
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    for(var tab in MainPage.tabs) Builder(
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
                  controller: _tabController,
                  tabs: [for (var i=0; i<tabTitles.length; i++)
                    Tab(text: tabTitles[i], icon: FaIcon(MainPage.tabIcons[i]))
                  ],
                  isScrollable: MediaQuery.of(context).size.width < 500,
                  tabAlignment: MediaQuery.of(context).size.width < 500 ? TabAlignment.center : TabAlignment.fill,
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
