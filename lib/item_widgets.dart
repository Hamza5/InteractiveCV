import 'dart:convert';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:one_clock/one_clock.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BasicInfoItem extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? description;
  final Uri? url;
  final bool shrink;
  const BasicInfoItem({super.key, this.icon, required this.title, this.description, this.url, this.shrink = false});

  @override
  Widget build(BuildContext context) {
    final listTile = ListTile(
      leading: icon != null ? FaIcon(icon) : null,
      title: Text(title),
      subtitle: description != null ? Text(description!) : null,
      onTap: url != null ? () => launchUrl(url!) : null,
    );
    return Card(child: shrink ? IntrinsicWidth(child: listTile) : listTile);
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

Widget imageLoadingBuilder(BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
  if (loadingProgress?.cumulativeBytesLoaded == loadingProgress?.expectedTotalBytes) {
    return child;
  } else {
    return Center(
      child: CircularProgressIndicator(
        value: (loadingProgress?.cumulativeBytesLoaded ?? 0) / (loadingProgress?.expectedTotalBytes ?? 1),
      ),
    );
  }
}

class LocationItem extends StatelessWidget {
  final LatLng geoPosition;
  final String fullAddress;
  static const owmApiKey = String.fromEnvironment('OWM_API_KEY');
  const LocationItem({
    super.key, required this.geoPosition, required this.fullAddress
  });

  @override
  Widget build(BuildContext context) {
    final addressBar = BasicInfoItem(
      icon: Icons.location_pin, title: fullAddress,
    );
    final weatherSection = FutureBuilder(
      future: http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${geoPosition.latitude}&lon=${geoPosition.longitude}&'
              'appid=$owmApiKey&units=metric&lang=${Localizations.localeOf(context).languageCode}',
        ),
      ).then((response) => json.decode(response.body) as Map<String, dynamic>),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        } else if (snapshot.hasData) {
          final currentWeather = snapshot.requireData;
          final double windSpeed = (currentWeather['wind']['speed'] / 1000) / (1 / 3600);
          final double windDegree = currentWeather['wind']['deg'];
          final String iconName = currentWeather['weather'][0]['icon'];
          final String description = currentWeather['weather'][0]['description'];
          final double temperature = currentWeather['main']['temp'];
          final double feelsLike = currentWeather['main']['feels_like'];
          // final double humidity = currentWeather['main']['humidity'];
          return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadiusDirectional.only(topEnd: Radius.circular(5)),
                color: Theme.of(context).colorScheme.surface.withOpacity(0.75),
              ),
              height: 100,
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://openweathermap.org/img/wn/$iconName@2x.png', height: 64, width: 64,
                        fit: BoxFit.fill, loadingBuilder: imageLoadingBuilder,
                      ),
                      Text(description, style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FaIcon(FontAwesomeIcons.temperatureHalf),
                          const SizedBox(width: 5),
                          Text('${temperature.round()}°C', textDirection: TextDirection.ltr),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.face),
                          const SizedBox(width: 5),
                          Text('${feelsLike.round()}°C', textDirection: TextDirection.ltr),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.rotate(
                            angle: degToRadian(windDegree - 45),
                            child: const FaIcon(FontAwesomeIcons.locationArrow),
                          ),
                          const SizedBox(width: 5),
                          Text('${windSpeed.round()}km/h'),
                        ],
                      ),
                    ],
                  ),
                ],
              )
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
    final attributionWatermark = RichAttributionWidget(
      alignment: Directionality.of(context) == TextDirection.rtl ?
      AttributionAlignment.bottomLeft : AttributionAlignment.bottomRight,
      attributions: [
        TextSourceAttribution('Amap', onTap: () => launchUrl(Uri.parse('https://amap.com/'))),
        TextSourceAttribution('OpenWeatherMap', onTap: () => launchUrl(Uri.parse('https://openweathermap.org/'))),
      ],
    );
    final currentTime = DateTime.now().toUtc().add(
      Duration(hours: int.parse(AppLocalizations.of(context)!.timezone_hours)),
    );
    final clockColor = Theme.of(context).colorScheme.onSurface;
    final clock = AnalogClock(
      height: 150, width: 150, isLive: true, showDigitalClock: true, showAllNumbers: true,
      datetime: currentTime,
      textScaleFactor: 1.5,
      digitalClockColor: clockColor,
      hourHandColor: clockColor,
      minuteHandColor: clockColor,
      numberColor: clockColor,
    );
    final locale = Localizations.localeOf(context);
    HijriCalendar.setLocal(locale.languageCode);
    final style = Theme.of(context).textTheme.titleSmall?.copyWith(color: clockColor, height: 1);
    final dates = SizedBox(
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(DateFormat.EEEE(locale.languageCode).format(currentTime), style: style?.copyWith(fontWeight: FontWeight.bold)),
          Text(HijriCalendar.fromDate(currentTime).toFormat('dd MMMM yyyy'), style: style),
          Text(DateFormat.yMMMMd(locale.languageCode).format(currentTime), style: style),
        ],
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
          Container(
              margin: const EdgeInsets.only(top: 60),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.75),
                  borderRadius: const BorderRadiusDirectional.horizontal(end: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [clock, const SizedBox(height: 5), dates],
              ),
          ),
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
                      child: Image(
                        image: image!, fit: BoxFit.fill, width: rectangularImage ? 65 : 50, height: 50,
                        loadingBuilder: imageLoadingBuilder,
                      ),
                    ),
                    const SizedBox(width: 5)
                  ],
                  IntrinsicWidth(
                    stepWidth: 5,
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
                  progressDirection: Directionality.of(context),
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
          for (var (index, image) in certifications.indexed) SizedBox(
              height: height,
              width: width,
              child: OutlinedButton(
                style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 15, horizontal: 5))
                ),
                onPressed: () async {
                  final imageProvider = MultiImageProvider(certifications, initialIndex: index);
                  await showImageViewerPager(
                    context, imageProvider, swipeDismissible: true, doubleTapZoomable: true,
                    backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.75),
                    closeButtonColor: Theme.of(context).colorScheme.onBackground,
                  );
                },
                child: Image(image: image, loadingBuilder: imageLoadingBuilder),
              )
          )
        ],
      ),
    );
  }
}
