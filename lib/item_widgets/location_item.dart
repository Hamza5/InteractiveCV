import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:one_clock/one_clock.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../api/weather.dart';
import 'basic_info_item.dart';
import 'image_loading_builder.dart';


class LocationItem extends StatelessWidget {
  final LatLng geoPosition;
  final String fullAddress;
  static const owmApiKey = String.fromEnvironment('OWM_API_KEY');
  const LocationItem({
    super.key, required this.geoPosition, required this.fullAddress
  });

  @override
  Widget build(BuildContext context) {
    final addressBar = BasicInfoItem(icon: Icons.location_pin, title: fullAddress);
    final weatherSection = FutureBuilder(
      future: OpenWeatherMap(geoLocation: geoPosition, lang: Localizations.localeOf(context).languageCode).getWeather(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        } else if (snapshot.hasData) {
          final w = snapshot.requireData;
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
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            'https://openweathermap.org/img/wn/${w.iconName}@2x.png', height: 66, width: 66,
                            fit: BoxFit.fill, loadingBuilder: imageLoadingBuilder,
                            color: Theme.of(context).colorScheme.shadow.withOpacity(0.5),
                          ),
                          Image.network(
                            'https://openweathermap.org/img/wn/${w.iconName}@2x.png', height: 64, width: 64,
                            fit: BoxFit.fill, loadingBuilder: imageLoadingBuilder,
                          ),
                        ],
                      ),
                      Text(
                        w.description.characters.first.toUpperCase() + w.description.substring(w.description.characters.first.length),
                        style: Theme.of(context).textTheme.titleMedium,
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
                          const SizedBox(width: 5),
                          Text('${w.temperature.round()}°C', textDirection: TextDirection.ltr),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.face),
                          const SizedBox(width: 5),
                          Text('${w.feelsLike.round()}°C', textDirection: TextDirection.ltr),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.rotate(
                            angle: degToRadian(w.windDegree - 45),
                            child: const FaIcon(FontAwesomeIcons.locationArrow),
                          ),
                          const SizedBox(width: 5),
                          Text('${w.windSpeed.round()}km/h'),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: map,
      ),
    );
  }
}