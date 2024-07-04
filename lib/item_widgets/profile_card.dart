import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/github.dart';
import '../api/hsoubacademy.dart';
import '../api/linkedin.dart';
import '../api/stackoverflow.dart';

class ProfileCard extends StatelessWidget {
  final Widget icon;
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
                              Text(
                                AppLocalizations.of(context)!.dataSource(scraped ? 'scrap' : 'api'),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
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
        PositionedDirectional(
          top: 10,
          end: 10,
          child: SizedBox.square(dimension: 32, child: FittedBox(child: icon)),
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
            icon: const FaIcon(FontAwesomeIcons.github), name: p.name, about: p.bio, avatarUrl: p.avatarUrl, url: p.url,
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
          icon: const FaIcon(FontAwesomeIcons.stackOverflow), name: p.displayName, about: p.aboutMe,
          avatarUrl: p.profileImage, url: p.link, scraped: false,
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
          icon: const FaIcon(FontAwesomeIcons.linkedin), name: p.name, about: p.headline, avatarUrl: p.profilePicture,
          url: p.url, scraped: true, avatarBytes: p.profilePictureBytes,
          stats: {
            FontAwesomeIcons.userGroup: p.connectionsCount
          },
        );
      },
    );
  }
}

class HsoubAcademyCard extends StatelessWidget {
  const HsoubAcademyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingProfileCard(
      getProfileInfoMethod: HsoubAcademy().getProfileInfo,
      profileCardBuilder: (p) {
        p = p as HsoubAcademyProfile;
        return ProfileCard(
          icon: ImageIcon(Image.asset('images/logos/Hsoub_academy.png').image), name: p.name, about: p.about,
          avatarUrl: p.profilePicture, url: p.url, avatarBytes: p.profilePictureBytes, scraped: true,
          stats: {
            FontAwesomeIcons.rankingStar: p.reputation,
            FontAwesomeIcons.circleCheck: p.bestAnswerCount,
            FontAwesomeIcons.message: p.postCount,
          },
        );
      },
    );
  }
}