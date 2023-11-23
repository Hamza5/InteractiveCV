import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const firstName = 'Hamza';
const lastName = 'Abbad';
const shortDescription = 'PhD student in computer science and artificial intelligence';
const photoPath = 'images/Photo.jpg';
const email = 'hamza.abbad@gmail.com';
const phone1 = '🇨🇳 +86 139 7165 4983';
const phone2 = '🇩🇿 +213 659 41 84 69';
const city = 'Dalian';
const province = 'Liaoning';
const country = 'China';
const nationality = '🇩🇿 Algerian';
const religion = '☪️ Islam';
const github = 'github.com/Hamza5';
const linkedin = 'linkedin.com/in/hamza-abbad/';

const tabTitles = [
  'Basic',
  'Education',
];
const tabIcons = [
  Icons.person,
  Icons.school,
];

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
            name: '$firstName $lastName', description: shortDescription,
            photoProvider: Image.asset(photoPath).image
        ),
        toolbarHeight: 200,
        centerTitle: true,
        bottom: TabBar(
          tabs: [for (var i=0; i<tabTitles.length; i++) Tab(text: tabTitles[i], icon: Icon(tabIcons[i]),)],
        ),
      ),
      body: const TabBarView(
        children: [BasicInfo(), Placeholder()],
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final IconData iconName;
  final String text;
  const InfoItem({super.key, required this.iconName, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            onTap: () {},
            child: ListTile(leading: FaIcon(iconName), title: Text(text))
        )
    );
  }
}


class BasicInfo extends StatelessWidget {
  const BasicInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 400, mainAxisExtent: 50),
      children: const [
        InfoItem(iconName: Icons.email, text: email),
        InfoItem(iconName: Icons.phone, text: phone1),
        InfoItem(iconName: Icons.phone, text: phone2),
        InfoItem(iconName: Icons.location_pin, text: '$city, $province, $country'),
        InfoItem(iconName: Icons.flag_circle, text: nationality),
        InfoItem(iconName: Icons.book, text: religion),
        InfoItem(iconName: FontAwesomeIcons.github, text: github),
        InfoItem(iconName: FontAwesomeIcons.linkedin, text: linkedin),
      ],
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


