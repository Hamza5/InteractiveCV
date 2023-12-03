import 'package:flutter/material.dart';

import 'views.dart';

const firstName = 'Hamza';
const lastName = 'Abbad';
const shortDescription = 'PhD student in computer science and artificial intelligence';
const photoPath = 'images/Photo.jpg';

const tabTitles = ['Basic', 'Education', 'Work'];
const tabIcons = [Icons.person, Icons.school, Icons.work];
const tabs = [BasicInfoView(), EducationView(), WorkView()];

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
        // useMaterial3: true,
      ),
      home: DefaultTabController(length: tabTitles.length, child: const MainPage()),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Header(
            name: '$firstName $lastName', description: shortDescription, photoProvider: Image.asset(photoPath).image
        ),
        toolbarHeight: 200,
        centerTitle: true,
        bottom: TabBar(
          tabs: [for (var i=0; i<tabTitles.length; i++) Tab(text: tabTitles[i], icon: Icon(tabIcons[i]),)],
        ),
      ),
      body: const TabBarView(
        children: tabs,
      ),
    );
  }
}

class CirclePhoto extends StatelessWidget {
  final ImageProvider photoProvider;

  const CirclePhoto({super.key, required this.photoProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Theme.of(context).primaryColor,
          boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.5), blurRadius: 5)]
      ),
      child: CircleAvatar(foregroundImage: photoProvider, radius: 48),
    );
  }
}

class Header extends StatelessWidget {
  final String name;
  final String description;
  final ImageProvider photoProvider;

  const Header({super.key, required this.name, required this.description, required this.photoProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:[
        CirclePhoto(photoProvider: photoProvider),
        Text(name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).colorScheme.background,
            shadows: [Shadow(color: Theme.of(context).colorScheme.background, blurRadius: 2)]
        )),
        Text(description, style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.background,
            shadows: [Shadow(color: Theme.of(context).colorScheme.background, blurRadius: 2)]
        ))
      ],
    );
  }
}
