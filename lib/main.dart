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

class InteractiveCV extends StatelessWidget {
  const InteractiveCV({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive CV',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        cardTheme: const CardTheme(margin: EdgeInsets.all(3), elevation: 2),
        listTileTheme: const ListTileThemeData(horizontalTitleGap: 0, contentPadding: EdgeInsets.all(5)),
        // useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  static const List<String> tabTitles = ['Basic', 'Education', 'Work', 'Experience', 'Projects'];
  static const List<IconData> tabIcons = [
    Icons.person, Icons.school, Icons.work, FontAwesomeIcons.screwdriverWrench, FontAwesomeIcons.toolbox,
  ];
  static const List<Widget> tabs = [BasicInfoView(), EducationView(), WorkView(), ExperienceView(), ProjectsView()];

  const MainPage({super.key});

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
                    expandedHeight: 200,
                    forceElevated: innerBoxIsScrolled,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      background: Align(
                        alignment: const Alignment(0.33, 0.6),
                        child: Text(
                          shortDescription,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CirclePhoto(photo: Image.asset(photoPath).image),
                          const SizedBox(width: 5),
                          const Text('$firstName $lastName'),
                        ],
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
              color: Theme.of(context).colorScheme.primary,
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
