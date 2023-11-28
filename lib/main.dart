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
const stackOverflow = 'stackoverflow.com/users/5008968/hamza-abbad';

const university1 = 'University of Science and Technology Houari Boumediene (USTHB)';
const university1Logo = 'images/university1_logo.png';
const university2 = 'Wuhan University of Technology (WHUT)';
const university2Logo = 'images/university2_logo.jpg';
const specialities = [
  'Bachelor in Computer Science', 'Master in Artificial Intelligence', 'Mandarin Chinese',
  'PhD in Arabic Natural Language Processing using Deep Learning'
] ;
const universityNames = [university1, university1, university2, university2];
const universityLogos = [university1Logo, university1Logo, university2Logo, university2Logo];
const studyYears = ['2012-2015', '2015-2017', '2017-2018', '2018-2024'];

const tabTitles = ['Basic', 'Education'];
const tabIcons = [Icons.person, Icons.school];

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
      body: TabBarView(
        children: [
          const BasicInfoView(),
          EducationView(
            logos: universityLogos.map((e) => Image.asset(e).image).toList(growable: false), specialities: specialities,
            institutions: universityNames, years: studyYears
          ),
        ],
      ),
    );
  }
}

class BasicInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const BasicInfoItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(leading: FaIcon(icon), title: Text(text)));
  }
}

class SectionTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final List<Widget> items;
  const SectionTile({super.key, required this.icon, required this.text, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        textColor: Theme.of(context).colorScheme.onSurfaceVariant,
        leading: FaIcon(icon),
        title: Text(text, style: Theme.of(context).textTheme.titleLarge),
        iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
        initiallyExpanded: true,
        children: items,
      ),
    );
  }
}

class BasicInfoView extends StatelessWidget {

  const BasicInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SectionTile(
          icon: Icons.contacts, text: 'Contact information',
          items: [
            BasicInfoItem(icon: Icons.email, text: email),
            BasicInfoItem(icon: Icons.phone, text: phone1),
            BasicInfoItem(icon: Icons.phone, text: phone2),
          ],
        ),
        SectionTile(icon: Icons.web, text: 'Web presence',
            items: [
              BasicInfoItem(icon: FontAwesomeIcons.github, text: github),
              BasicInfoItem(icon: FontAwesomeIcons.stackOverflow, text: stackOverflow),
              BasicInfoItem(icon: FontAwesomeIcons.linkedin, text: linkedin),
            ]
        )
      ],
    );
  }
}

class EducationView extends StatelessWidget {
  final List<ImageProvider> logos;
  final List<String> specialities;
  final List<String> institutions;
  final List<String> years;
  const EducationView({
    super.key, required this.logos, required this.specialities, required this.institutions, required this.years
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var i=0; i<logos.length; i++)
        ListTile(
          leading: Image(image: logos[i]), title: Text(specialities[i]),
          subtitle: Text(institutions[i]), trailing: Text(years[i]),
        ),
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


