import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

const firstName = 'Hamza';
const lastName = 'Abbad';
const shortDescription = 'PhD student in computer science and artificial intelligence';
const photoPath = 'images/Photo.jpg';
const email = 'hamza.abbad@gmail.com';
const phone1 = '🇨🇳 +86 139 7165 4983';
const phone2 = '🇩🇿 +213 659 41 84 69';
const streetAddress = 'DaYouWen garden';
const city = 'Dalian';
const province = 'Liaoning';
const country = 'China';
const geoPosition = LatLng(38.8820, 121.5022);
const mapLink = 'https://map.baidu.com/@13527705.46,4678954.75,18z';
const nationality = '🇩🇿 Algerian';
const religion = '☪️ Islam';
const github = 'github.com/Hamza5';
const linkedin = 'linkedin.com/in/hamza-abbad/';
const stackOverflow = 'stackoverflow.com/users/5008968/hamza-abbad';

const university1 = 'University of Science and Technology Houari Boumediene (USTHB)';
const university1Logo = 'images/usthb_logo.png';
const university1Url = 'https://www.usthb.dz/';
const university2 = 'Wuhan University of Technology (WHUT)';
const university2Logo = 'images/whut_logo.png';
const university2Url = 'https://www.whut.edu.cn/';
const institution3 = 'International Education Specialists (IDP)';
const institution3Logo = 'images/idp_logo.png';
const institution3Url = 'https://www.idp.com/';
const institution3Certification = 'images/IELTS_TRF.jpg';
const specialities = [
  'Bachelor in Computer Science', 'Master in Artificial Intelligence', 'Mandarin Chinese',
  'PhD in Arabic Natural Language Processing using Deep Learning',
  'International English Language Testing System (IELTS)'
] ;
const universityNames = [university1, university1, university2, university2];
const universityLogos = [university1Logo, university1Logo, university2Logo, university2Logo];
const studyYears = ['2012-2015', '2015-2017', '2017-2018', '2018-2024', '2018'];
const bachelorCertifications = ['images/Bachelor-1.jpg', 'images/Master-2.jpg'];

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
      home: DefaultTabController(length: tabTitles.length, initialIndex: 1, child: const MainPage()),
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
  final Uri? url;
  final String? trailing;
  const BasicInfoItem({super.key, required this.icon, required this.text, this.url, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          leading: FaIcon(icon),
          title: Text(text),
          trailing: trailing != null ? Text(trailing!) : null,
          onTap: url != null ? () => launchUrl(url!) : null,
          tileColor: Theme.of(context).colorScheme.secondaryContainer,
          textColor: Theme.of(context).colorScheme.onSecondaryContainer,
        )
    );
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
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        textColor: Theme.of(context).colorScheme.onPrimaryContainer,
        leading: FaIcon(icon),
        title: Text(text, style: Theme.of(context).textTheme.titleLarge),
        iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
        initiallyExpanded: true,
        children: items,
      ),
    );
  }
}

class LocationItem extends StatelessWidget {
  final LatLng geoPosition;
  final String country;
  final String province;
  final String city;
  final String streetAddress;
  const LocationItem({
    super.key, required this.geoPosition, required this.country, required this.province, required this.city,
    required this.streetAddress
  });

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 500,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: FlutterMap(
            options: MapOptions(initialCenter: geoPosition, initialZoom: 16),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileProvider: CancellableNetworkTileProvider(),
              ),
              const SimpleAttributionWidget(source: Text('OpenStreetMap')),
              Align(
                alignment: Alignment.topCenter,
                child: BasicInfoItem(
                  icon: Icons.location_pin, text: '$streetAddress, $city, $province, $country',
                  url: Uri.parse(mapLink),
                ),
              )
            ]
        ),
      ),
    );
  }
}

class BasicInfoView extends StatelessWidget {

  const BasicInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SectionTile(
          icon: Icons.contacts, text: 'Contact information',
          items: [
            BasicInfoItem(icon: Icons.email, text: email, url: Uri.parse('mailto:$email')),
            BasicInfoItem(icon: Icons.phone, text: phone1, url: Uri.parse('tel:$phone1'),),
            BasicInfoItem(icon: Icons.phone, text: phone2, url: Uri.parse('tel:$phone2'),),
          ],
        ),
        SectionTile(icon: Icons.web, text: 'Web presence',
            items: [
              BasicInfoItem(icon: FontAwesomeIcons.github, text: github, url: Uri.parse('https://$github'),),
              BasicInfoItem(
                icon: FontAwesomeIcons.stackOverflow, text: stackOverflow, url: Uri.parse('https://$stackOverflow'),
              ),
              BasicInfoItem(icon: FontAwesomeIcons.linkedin, text: linkedin, url: Uri.parse('https://$linkedin'),),
            ]
        ),
        const SectionTile(icon: Icons.location_city, text: 'Physical presence', items: [
          LocationItem(
              geoPosition: geoPosition, country: country, province: province, city: city, streetAddress: streetAddress
          )
        ])
      ],
    );
  }
}

class InstitutionItem extends StatelessWidget {
  final ImageProvider logo;
  final String title;
  final List<Widget> items;
  final Uri? url;
  const InstitutionItem({super.key, required this.logo, required this.title, required this.items, this.url});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: GestureDetector(
          onTap: url != null ? () => launchUrl(url!) : null,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ImageIcon(logo, size: 128),
          ),
        ),
        subtitle: Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
        initiallyExpanded: true,
        children: items,
      ),
    );
  }
}

class StudyItem extends StatelessWidget {
  final String title;
  final String trailing;
  final List<Widget> items;
  const StudyItem({super.key, required this.title, required this.trailing, this.items = const []});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ExpansionTile(
          title: Text(title),
          trailing: Text(trailing),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          textColor: Theme.of(context).colorScheme.onSecondaryContainer,
          children: items,
        )
    );
  }
}

class CertificationList extends StatelessWidget {
  final List<ImageProvider> certifications;
  const CertificationList({super.key, required this.certifications});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 10,
      runSpacing: 10,
      children: [
        for (var image in certifications) SizedBox(
            height: 300,
            child: OutlinedButton(
              style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 15, horizontal: 5))
              ),
              onPressed: () async {
                final imageProvider = MultiImageProvider(certifications);
                await showImageViewerPager(context, imageProvider, swipeDismissible: true, doubleTapZoomable: true);
              },
              child: Image(image: image),
            )
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
        InstitutionItem(
            logo: Image.asset(university1Logo).image, title: university1, url: Uri.parse(university1Url),
            items: [
              StudyItem(
                title: specialities[0], trailing: years[0],
                items: [
                  CertificationList(
                      certifications: [
                        for (var fileName in ['Bachelor-1.jpg', 'Bachelor-2.jpg']) Image.asset('images/$fileName').image
                      ]
                  )
                ],
              ),
              StudyItem(
                title: specialities[1], trailing: years[1],
                items: [
                  CertificationList(
                    certifications: [
                      for (var fileName in ['Master-1.jpg', 'Master-2.jpg']) Image.asset('images/$fileName').image
                    ]
                  )
                ],
              )
            ]
        ),
        InstitutionItem(
            logo: Image.asset(university2Logo).image, title: university2, url: Uri.parse(university2Url),
            items: [
              StudyItem(title: specialities[2], trailing: years[2]),
              StudyItem(title: specialities[3], trailing: years[3])
            ]
        ),
        InstitutionItem(
          logo: Image.asset(institution3Logo).image, title: institution3, url: Uri.parse(institution3Url),
          items: [
            StudyItem(
              title: specialities[4], trailing: years[4],
              items: [CertificationList(certifications: [Image.asset(institution3Certification).image])],
            )
          ],
        )
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


