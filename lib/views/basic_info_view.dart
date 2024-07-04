import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:time_machine/time_machine.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../item_widgets/basic_info_item.dart';
import '../item_widgets/knowledge_item.dart';
import '../item_widgets/location_item.dart';
import '../item_widgets/profile_card.dart';
import '../item_widgets/section_tile.dart';

(int, int, int) timePassedSince(DateTime date) {
  final from = LocalDate.dateTime(date);
  final to = LocalDate.today();
  final diff = to.periodSince(from);
  return (diff.years, diff.months, diff.days);
}

class BasicInfoView extends StatelessWidget {

  const BasicInfoView({super.key});

  static String displayPhone(String phoneNumber) {
    if (phoneNumber.startsWith('+213')) {
      return '🇩🇿 $phoneNumber';
    } else if (phoneNumber.startsWith('+86')) {
      return '🇨🇳 $phoneNumber';
    }
    return phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    final large = MediaQuery.of(context).size.width >= 500;
    final localization = AppLocalizations.of(context)!;
    final age = timePassedSince(DateTime(1994, 5, 13));
    return SliverList.list(
      children: [
        SectionTile(
          icon: Icons.contacts, text: localization.contactInfo, wrapped: large,
          items: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: BasicInfoItem(
                icon: Icons.email, title: localization.email, url: Uri.parse('mailto:${localization.email}'),
                shrink: large,
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: BasicInfoItem(
                icon: Icons.phone, title: displayPhone(localization.phone1), url: Uri.parse('tel:+8613971654983'),
                shrink: large,
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: BasicInfoItem(
                icon: Icons.phone, title: displayPhone(localization.phone2), url: Uri.parse('tel:+213659418469'),
                shrink: large,
              ),
            ),
          ],
        ),
        SectionTile(
            icon: Icons.person_2, text: localization.personal, wrapped: large,
            items: [
              BasicInfoItem(
                icon: FontAwesomeIcons.baby, shrink: large,
                title: localization.age(age.$1, age.$2, age.$3),
              ),
              BasicInfoItem(icon: FontAwesomeIcons.book, title: localization.religion, shrink: large),
              BasicInfoItem(icon: FontAwesomeIcons.flag, title: localization.nationality, shrink: large),
            ]
        ),
        SectionTile(
          icon: Icons.language, text: localization.languages,
          items: [
            KnowledgeItem(
              image: Image.asset(localization.arabicFlag).image, name: localization.arabicName, dropImageShadow: true,
              description:  localization.arabicDesc, rectangularImage: true,
              progress: 0.9,
            ),
            KnowledgeItem(
              image: Image.asset(localization.englishFlag).image, name: localization.englishName,
              dropImageShadow: true, description: localization.englishDesc, progress: 0.8, rectangularImage: true,
            ),
            KnowledgeItem(
              image: Image.asset(localization.frenchFlag).image, name: localization.frenchName, dropImageShadow: true,
              description: localization.frenchDesc, progress: 0.7, rectangularImage: true,
            ),
            KnowledgeItem(
              image: Image.asset(localization.chineseFlag).image, name: localization.chineseName, dropImageShadow: true,
              description: localization.chineseDesc, progress: 0.6, rectangularImage: true,
            ),
            KnowledgeItem(
              image: Image.asset(localization.russianFlag).image, name: localization.russianName, dropImageShadow: true,
              description: localization.russianDesc, progress: 0.1, rectangularImage: true,
            )
          ],
          wrapped: true,
        ),
        SectionTile(icon: Icons.web, text: localization.web, wrapped: large,
            items: const [
              Directionality(
                textDirection: TextDirection.ltr,
                child: GitHubCard(),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: StackOverflowCard(),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: LinkedInCard(),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: HsoubAcademyCard(),
              ),
            ]
        ),
        SectionTile(icon: Icons.location_city, text: localization.physical, items: [
          LocationItem(
            geoPosition: LatLng(double.parse(localization.latitude), double.parse(localization.longitude)), fullAddress: localization.fullAddress,
          )
        ]),
      ],
    );
  }
}