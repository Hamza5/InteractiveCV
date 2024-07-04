import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../item_widgets/certification_list.dart';
import '../item_widgets/field_item.dart';
import '../item_widgets/institution_item.dart';

class WorkView extends StatelessWidget {
  const WorkView({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return SliverList.list(
      children: [
        InstitutionItem(
          logo: Image.asset(localization.institution6Logo).image, title: localization.institution6,
          url: Uri.parse(localization.institution6Url),
          items: [
            FieldItem(
              title: localization.institution6Speciality1, trailing: localization.institution6Years1,
              items: [
                CertificationList(
                  certifications: [Image.asset(localization.institution6Certification1).image],
                  height: 500,
                )
              ],
            ),
          ],
        ),
        InstitutionItem(
          logo: Image.asset(localization.institution7Logo).image, title: localization.institution7,
          url: Uri.parse(localization.institution7Url),
          items: [
            FieldItem(
              title: localization.institution7Speciality1, trailing: localization.institution7Years1,
              items: [
                CertificationList(
                  certifications: [Image.asset(localization.institution7Certification1).image],
                  height: 500,
                )
              ],
            ),
          ],
        ),
        InstitutionItem(
          logo: Image.asset(localization.institution8Logo).image, title: localization.institution8,
          url: Uri.parse(localization.institution8Url),
          items: [
            FieldItem(
              title: localization.institution8Speciality1, trailing: localization.institution8Years1,
            ),
          ],
        ),
      ],
    );
  }
}