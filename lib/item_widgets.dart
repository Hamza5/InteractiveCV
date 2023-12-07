import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:weather/weather.dart';

class BasicInfoItem extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? description;
  final Uri? url;
  const BasicInfoItem({super.key, this.icon, required this.title, this.description, this.url});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          leading: icon != null ? FaIcon(icon) : null,
          title: Text(title),
          subtitle: description != null ? Text(description!) : null,
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
        [Wrap(alignment: WrapAlignment.center, children: items)] :
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
  final WeatherFactory weatherFactory;
  LocationItem({
    super.key, required this.geoPosition, required this.country, required this.province, required this.city,
    required this.streetAddress
  }) : weatherFactory = WeatherFactory(const String.fromEnvironment('OWM_API_KEY'));

  @override
  Widget build(BuildContext context) {
    final addressBar = BasicInfoItem(
      icon: Icons.location_pin, title: '$streetAddress, $city, $province, $country',
    );
    final weatherSection = FutureBuilder(
      future: weatherFactory.currentWeatherByLocation(geoPosition.latitude, geoPosition.longitude),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        } else if (snapshot.hasData) {
          final weather = snapshot.requireData;
          return Opacity(
            opacity: 0.75,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadiusDirectional.only(topEnd: Radius.circular(5)),
                  color: Theme.of(context).colorScheme.background,
                ),
                height: 100,
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://openweathermap.org/img/wn/${weather.weatherIcon}@2x.png', height: 64, width: 64,
                          fit: BoxFit.fill,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(weather.weatherMain ?? '', style: Theme.of(context).textTheme.titleLarge),
                            Text(weather.weatherDescription ?? ''),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(FontAwesomeIcons.temperatureHalf),
                            const SizedBox(width: 2),
                            Text('${weather.temperature?.celsius?.round()}°C'),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.face),
                            const SizedBox(width: 2),
                            Text('${weather.tempFeelsLike?.celsius?.round()}°C'),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Transform.rotate(
                              angle: degToRadian((weather.windDegree ?? 45) - 45),
                              child: const FaIcon(FontAwesomeIcons.locationArrow),
                            ),
                            const SizedBox(width: 2),
                            Text('${weather.windSpeed?.round()}m/s'),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
    final attributionWatermark = Opacity(
      opacity: 0.5,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            borderRadius: const BorderRadiusDirectional.only(topStart: Radius.circular(5)),
            color: Theme.of(context).colorScheme.background
        ),
        child: TextSourceAttribution('Amap.com', onTap: () => launchUrl(Uri.parse('https://amap.com/'))),
      ),
    );
    final map = FlutterMap(
        options: MapOptions(initialCenter: geoPosition, initialZoom: 15, maxZoom: 17, minZoom: 9),
        children: [
          TileLayer(
            urlTemplate: 'https://webrd01.is.autonavi.com/appmaptile?lang=en&size=1&scale=1&style=8&x={x}&y={y}&z={z}',
            tileProvider: CancellableNetworkTileProvider(),
          ),
          addressBar,
          Align(alignment: AlignmentDirectional.bottomStart, child: weatherSection),
          Align(alignment: AlignmentDirectional.bottomEnd, child: attributionWatermark),
        ],
    );
    return LimitedBox(
      maxHeight: 400,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: map,
      ),
    );
  }
}

class KnowledgeItem extends StatelessWidget {
  final ImageProvider? image;
  final String name;
  final String description;
  final double progress;
  final bool dropImageShadow;
  final bool rectangularImage;
  final Uri? url;
  const KnowledgeItem({
    super.key, this.image, required this.name, required this.description, required this.progress,
    this.dropImageShadow = false, this.rectangularImage = false, this.url
  });

  int get _totalSteps => 10;
  int get _currentStep => (progress * 10).round();
  Color get _progressColor {
    switch (_currentStep) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.deepOrange;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.orangeAccent;
      case 5:
        return Colors.yellow;
      case 6:
        return Colors.lime;
      case 7:
        return Colors.lightGreen;
      case 8:
        return Colors.green;
      case 9:
        return Colors.green.shade700;
      case 10:
        return Colors.green.shade900;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: GestureDetector(
          onTap: url != null ? () => launchUrl(url!) : null,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (image != null) ...[
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: dropImageShadow ?
                        [BoxShadow(color: Theme.of(context).colorScheme.shadow, blurRadius: 1)] : null,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image(image: image!, fit: BoxFit.fill, width: rectangularImage ? 65 : 50, height: 50),
                    ),
                    const SizedBox(width: 5)
                  ],
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
                          height: 40,
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

class FieldItem extends StatelessWidget {
  final String title;
  final String trailing;
  final List<Widget> items;
  const FieldItem({super.key, required this.title, required this.trailing, this.items = const []});

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
        spacing: 5,
        runSpacing: 5,
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
