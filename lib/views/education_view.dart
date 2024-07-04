import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../item_widgets/certification_list.dart';
import '../item_widgets/field_item.dart';
import '../item_widgets/institution_item.dart';

class EducationView extends StatelessWidget {
  const EducationView({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return SliverList.list(
      children: [
        InstitutionItem(
            logo: Image.asset(localization.institution1Logo).image, title: localization.institution1,
            url: Uri.parse(localization.institution1Url),
            items: [
              FieldItem(
                title: localization.institution1Speciality1, trailing: localization.institution1Years1,
                items: [
                  CertificationList(
                    certifications: [
                      Image.asset(localization.institution1Certification1).image,
                      Image.asset(localization.institution1Certification2).image,
                    ],
                    height: 300,
                  )
                ],
              ),
              FieldItem(
                title: localization.institution1Speciality2, trailing: localization.institution1Years2,
                items: [
                  CertificationList(
                    certifications: [
                      Image.asset(localization.institution1Certification3).image,
                      Image.asset(localization.institution1Certification4).image,
                    ],
                    height: 300,
                  )
                ],
              )
            ]
        ),
        InstitutionItem(
            logo: Image.asset(localization.institution2Logo).image, title: localization.institution2,
            url: Uri.parse(localization.institution2Url),
            items: [
              FieldItem(
                title: localization.institution2Speciality1, trailing: localization.institution2Years1,
                items: [
                  CertificationList(
                    height: 500,
                    certifications: [
                      Image.asset(localization.institution2Certification3).image,
                    ],
                  ),
                ],
              ),
              FieldItem(
                title: localization.institution2Speciality2, trailing: localization.institution2Years2,
                items: [
                  CertificationList(
                    height: 500,
                    certifications: [
                      Image.asset(localization.institution2Certification1).image,
                      Image.asset(localization.institution2Certification2).image,
                    ],
                  )
                ],
              )
            ]
        ),
        InstitutionItem(
          logo: Image.asset(
              localization.institution3Logo).image, title: localization.institution3,
          url: Uri.parse(localization.institution3Url),
          items: [
            FieldItem(
              title: localization.institution3Speciality1, trailing: localization.institution3Years1,
              items: [
                CertificationList(
                  certifications: [Image.asset(localization.institution3Certification1).image],
                  height: 500,
                ),
              ],
            )
          ],
        ),
        InstitutionItem(
          logo: Image.asset(localization.institution4Logo).image, title: localization.institution4,
          url: Uri.parse(localization.institution4Url),
          items: [
            FieldItem(
              title: localization.institution4Speciality1, trailing: localization.institution4Years1,
              items: [
                CertificationList(
                  certifications: [Image.asset(localization.institution4Certification1).image],
                  height: 200,
                ),
              ],
            )
          ],
        ),
        InstitutionItem(
          logo: Image.asset(localization.institution5Logo).image, title: localization.institution5,
          url: Uri.parse(localization.institution5Url),
          items: [
            FieldItem(
              title: localization.institution5Speciality1, trailing: localization.institution5Years1,
              items: [
                CertificationList(
                  certifications: [Image.asset(localization.institution5Certification1).image],
                  height: 400,
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}