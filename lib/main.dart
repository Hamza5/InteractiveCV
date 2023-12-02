import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
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
        children: [
          BasicInfoView(),
          EducationView(),
        ],
      ),
    );
  }
}

class BasicInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Uri? url;
  const BasicInfoItem({super.key, required this.icon, required this.text, this.url});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          leading: FaIcon(icon),
          title: Text(text),
          onTap: url != null ? () => launchUrl(url!) : null,
        )
    );
  }
}

class SectionTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final List<Widget> items;
  final bool wrapped;
  const SectionTile({super.key, required this.icon, required this.text, required this.items, this.wrapped = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: FaIcon(icon),
        title: Text(text, style: Theme.of(context).textTheme.titleLarge),
        iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
        initiallyExpanded: true,
        children: wrapped ?
        [Wrap(spacing: 10, runSpacing: 10, alignment: WrapAlignment.center, children: items)] :
        items,
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

class LanguageItem extends StatelessWidget {
  final ImageProvider flag;
  final String name;
  final String description;
  final double progress;
  const LanguageItem({
    super.key, required this.flag, required this.name, required this.description, required this.progress
  });

  int get _totalSteps => 5;
  int get _currentStep => (progress * 5).round();
  Color get _progressColor {
    switch (_currentStep) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.blue;
      case 5:
        return Colors.green;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.shadow, blurRadius: 1)],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image(image: flag, fit: BoxFit.fill, width: 65, height: 50),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: 120,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 35,
                        child: Text(name, style: Theme.of(context).textTheme.titleLarge),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 35,
                        child: Text(description, textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 190,
              child: StepProgressIndicator(
                totalSteps: _totalSteps,
                size: 10,
                roundedEdges: const Radius.circular(5),
                customColor: (i) {
                  return i < _currentStep ? _progressColor : Theme.of(context).colorScheme.surfaceVariant;
                },
              ),
            )
          ],
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
        const SectionTile(
            icon: Icons.person_2, text: 'Personal',
            items: [
              BasicInfoItem(icon: FontAwesomeIcons.book, text: religion),
              BasicInfoItem(icon: FontAwesomeIcons.flag, text: nationality),
            ]
        ),
        SectionTile(
          icon: Icons.language, text: 'Spoken languages',
          items: [
            LanguageItem(
              flag: Image.asset('images/arab-league.png').image, name: 'العَرَبِيَّة',
              description: 'Standard Arabic and most dialects',
              progress: 0.95,
            ),
            LanguageItem(
              flag: Image.asset('images/united-states.png').image, name: 'English',
              description: 'American accent', progress: 0.85,
            ),
            LanguageItem(
              flag: Image.asset('images/france.png').image, name: 'Français',
              description: 'Metropolitan French', progress: 0.8,
            ),
            LanguageItem(
              flag: Image.asset('images/china.png').image, name: '中文',
              description: 'Mandarin Chinese', progress: 0.6,
            ),
            LanguageItem(
              flag: Image.asset('images/russia.png').image, name: 'Русский',
              description: 'Basic words and sentences', progress: 0.1,
            )
          ],
          wrapped: true,
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

class ExperienceItem extends StatelessWidget {
  final String title;
  final String trailing;
  final List<Widget> items;
  const ExperienceItem({super.key, required this.title, required this.trailing, this.items = const []});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ExpansionTile(
          title: Text(title),
          trailing: Text(trailing),
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
      alignment: WrapAlignment.center,
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
  const EducationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        InstitutionItem(
            logo: Image.asset(university1Logo).image, title: university1, url: Uri.parse(university1Url),
            items: [
              ExperienceItem(
                title: specialities[0], trailing: studyYears[0],
                items: [
                  CertificationList(
                      certifications: [
                        for (var fileName in ['Bachelor-1.jpg', 'Bachelor-2.jpg']) Image.asset('images/$fileName').image
                      ]
                  )
                ],
              ),
              ExperienceItem(
                title: specialities[1], trailing: studyYears[1],
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
              ExperienceItem(title: specialities[2], trailing: studyYears[2]),
              ExperienceItem(title: specialities[3], trailing: studyYears[3])
            ]
        ),
        InstitutionItem(
          logo: Image.asset(institution3Logo).image, title: institution3, url: Uri.parse(institution3Url),
          items: [
            ExperienceItem(
              title: specialities[4], trailing: studyYears[4],
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


