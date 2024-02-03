import 'dart:typed_data';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:interactive_cv/api.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:one_clock/one_clock.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:transparent_image/transparent_image.dart';

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
    );
    return Card(
      child: InkWell(
        onTap: url != null ? () => launchUrl(url!) : null,
        child: Padding(padding: const EdgeInsets.all(5), child: shrink ? IntrinsicWidth(child: listTile) : listTile),
      ),
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
  int get _currentStep => (progress * _totalSteps).round();
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
        padding: const EdgeInsets.all(10),
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
                  progressDirection: Directionality.of(context),
                  totalSteps: _totalSteps,
                  size: 10,
                  roundedEdges: const Radius.circular(5),
                  customColor: (i) {
                    if (Directionality.of(context) == TextDirection.rtl) {
                      i = _totalSteps - i - 1;
                    }
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
                style: ButtonStyle(
                  padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 15, horizontal: 5)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
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

class ProfileCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String about;
  final Uri avatarUrl;
  final Uint8List? avatarBytes;
  final Uri url;
  final bool scraped;
  final Map<IconData, int> stats;

  const ProfileCard({
    super.key,
    required this.icon,
    required this.name,
    required this.about,
    required this.avatarUrl,
    required this.url,
    required this.scraped,
    this.stats = const {},
    this.avatarBytes,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    return Stack(
      children: [
        Card(
          child: InkWell(
            onTap: () => launchUrl(url),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                spacing: 5,
                runSpacing: 5,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: CircleAvatar(
                      backgroundImage: MemoryImage(avatarBytes ?? kTransparentImage),
                      foregroundImage: NetworkImage(avatarUrl.toString()),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      radius: 48,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ConstrainedBox(
                      constraints: BoxConstraints.loose(const Size.fromWidth(400)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(name, style: Theme.of(context).textTheme.titleLarge),
                          ),
                          Text(about, overflow: TextOverflow.ellipsis, maxLines: isLandscape ? 3 : 5),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Wrap(
                              spacing: 20,
                              runSpacing: 10,
                              children: [
                                for (var entry in stats.entries)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FaIcon(entry.key),
                                      const SizedBox(width: 5),
                                      Text('${entry.value}'),
                                    ]
                                  )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FaIcon(FontAwesomeIcons.wifi, size: 12),
                              const SizedBox(width: 5),
                              Text(AppLocalizations.of(context)!.dataSource(scraped ? 'scrap' : 'api'), style: Theme.of(context).textTheme.labelSmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: FaIcon(icon, size: 32),
        ),
      ],
    );
  }
}

class LoadingProfileCard extends StatelessWidget {
  final ProfileCard Function(dynamic) profileCardBuilder;
  final Function() getProfileInfoMethod;
  const LoadingProfileCard({super.key, required this.getProfileInfoMethod, required this.profileCardBuilder});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: FutureBuilder(
        future: getProfileInfoMethod(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return const SizedBox.shrink();
          } else if (snapshot.hasData) {
            return profileCardBuilder(snapshot.requireData!);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class GitHubCard extends StatelessWidget {
  const GitHubCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingProfileCard(
      getProfileInfoMethod: GitHub().getProfileInfo,
      profileCardBuilder: (p) {
        p = p as GitHubProfile;
        return ProfileCard(
          icon: FontAwesomeIcons.github, name: p.name, about: p.bio, avatarUrl: p.avatarUrl, url: p.url,
          scraped: false,
          stats: {
            FontAwesomeIcons.star: p.totalStars,
            FontAwesomeIcons.userGroup: p.followerCount,
            FontAwesomeIcons.book: p.repositoryCount,
          },
        );
      }
    );
  }
}

class StackOverflowCard extends StatelessWidget {
  const StackOverflowCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingProfileCard(
      getProfileInfoMethod: StackOverflow().getProfileInfo,
      profileCardBuilder: (p) {
        p = p as StackOverflowProfile;
        return ProfileCard(
          icon: FontAwesomeIcons.stackOverflow, name: p.displayName, about: p.aboutMe, avatarUrl: p.profileImage, url: p.link,
          scraped: false,
          stats: {
            FontAwesomeIcons.medal: p.reputation,
            FontAwesomeIcons.certificate: p.goldBadgeCount + p.silverBadgeCount + p.bronzeBadgeCount,
            FontAwesomeIcons.circleQuestion: p.questionCount,
            FontAwesomeIcons.message: p.answerCount,
          },
        );
      },
    );
  }
}

class LinkedInCard extends StatelessWidget {
  const LinkedInCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingProfileCard(
      getProfileInfoMethod: LinkedIn().getProfileInfo,
      profileCardBuilder: (p) {
        p = p as LinkedInProfile;
        return ProfileCard(
          icon: FontAwesomeIcons.linkedin, name: p.name, about: p.headline, avatarUrl: p.profilePicture, url: p.url,
          scraped: true, avatarBytes: p.profilePictureBytes,
          stats: {
            FontAwesomeIcons.userGroup: p.connectionsCount
          },
        );
      },
    );
  }
}