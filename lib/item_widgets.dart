import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

const mapLink = 'https://map.baidu.com/@13527705.46,4678954.75,18z';

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
        title: Padding(
          padding: const EdgeInsets.all(5),
          child: Center(
            child: IconButton(
              icon: ImageIcon(logo),
              iconSize: 128,
              onPressed: url != null ? () => launchUrl(url!) : null,
            ),
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
        child: items.isNotEmpty ? ExpansionTile(
          title: Text(title, textAlign: TextAlign.center),
          trailing: Text(trailing),
          children: items,
        ) : ListTile(
          title: Text(title, textAlign: TextAlign.center),
          trailing: Text(trailing),
        )
    );
  }
}

class CertificationList extends StatelessWidget {
  final List<ImageProvider> certifications;
  final double? height;
  final double? width;
  const CertificationList({super.key, required this.certifications, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: [
          for (var image in certifications) SizedBox(
              height: height,
              width: width,
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
      ),
    );
  }
}
