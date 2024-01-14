import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:time_machine/time_machine.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'item_widgets.dart';


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
                icon: Icons.phone, title: localization.phone1, url: Uri.parse('tel:+8613971654983'), shrink: large,
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: BasicInfoItem(
                icon: Icons.phone, title: localization.phone2, url: Uri.parse('tel:+213659418469'), shrink: large,
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
            items: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: BasicInfoItem(
                  icon: FontAwesomeIcons.github, title: localization.github, url: Uri.parse('https://${localization.github}'), shrink: large,
                ),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: BasicInfoItem(
                  icon: FontAwesomeIcons.stackOverflow, title: localization.stackOverflow, url: Uri.parse('https://${localization.stackOverflow}'),
                  shrink: large,
                ),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: BasicInfoItem(
                  icon: FontAwesomeIcons.linkedin, title: localization.linkedIn, url: Uri.parse('https://${localization.linkedIn}'), shrink: large,
                ),
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
              FieldItem(title: localization.institution2Speciality1, trailing: localization.institution2Years1),
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
          logo: Image.asset(localization.institution3Logo).image, title: localization.institution3, url: Uri.parse(localization.institution3Url),
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
            ),
          ],
        ),
      ],
    );
  }
}

class ExperienceView extends StatelessWidget {
  const ExperienceView({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return SliverList.list(
      children: [
        SectionTile(
          icon: FontAwesomeIcons.computer, text: localization.operatingSystems, wrapped: true,
          items: [
            KnowledgeItem(
              image: Image.asset(localization.windowsLogo).image, name: localization.windows,
              description: localization.dellLaptop, progress: 0.8,
            ),
            KnowledgeItem(
              image: Image.asset(localization.kubuntuLogo).image, name: localization.kubuntu,
              description: localization.dellLaptop, progress: 0.7,
            ),
            KnowledgeItem(
              image: Image.asset(localization.archlinuxLogo).image, name: localization.archlinux,
              description: localization.dellLaptop, progress: 0.6,
            ),
            KnowledgeItem(
              image: Image.asset(localization.macOsLogo).image, name: localization.macOs,
              description: localization.macbook, progress: 0.3,
            ),
            KnowledgeItem(
              image: Image.asset(localization.androidLogo).image, name: localization.android,
              description: localization.onePlusPhone, progress: 0.7,
            ),
          ],
        ),
        SectionTile(
          icon: Icons.app_settings_alt, text: localization.programming, wrapped: true,
          items: [
            KnowledgeItem(
              image: Image.asset(localization.pythonLogo).image, name: localization.python,
              description: localization.pythonDesc, progress: 0.95,
            ),
            KnowledgeItem(
              image: Image.asset(localization.flutterLogo).image, name: localization.flutter,
              description: localization.flutterDesc, progress: 0.7,
            ),
            KnowledgeItem(
              image: Image.asset(localization.jsLogo).image, name: localization.js,
              description: localization.jsDesc, progress: 0.6,
            ),
            KnowledgeItem(
              image: Image.asset(localization.javaLogo).image, name: localization.java,
              description: localization.javaDesc, progress: 0.3,
            ),
            KnowledgeItem(
              image: Image.asset(localization.mdLogo).image, name: localization.md,
              description: localization.mdDesc, progress: 0.95,
            ),
            KnowledgeItem(
              image: Image.asset(localization.htmlLogo).image, name: localization.html,
              description: localization.htmlDesc, progress: 0.7,
            ),
            KnowledgeItem(
              image: Image.asset(localization.latexLogo).image, name: localization.latex,
              description: localization.latexDesc, progress: 0.6,
            ),
          ],
        ),
        SectionTile(
          icon: Icons.library_books, text: localization.libraries, wrapped: true,
          items: [
            KnowledgeItem(
              image: Image.asset(localization.jupyterLogo).image, name: localization.jupyter,
              description: localization.jupyterDesc, progress: 0.8,
            ),
            KnowledgeItem(
              image: Image.asset(localization.mplLogo).image, name: localization.mpl,
              description: localization.mplDesc, progress: 0.6,
            ),
            KnowledgeItem(
              image: Image.asset(localization.tfLogo).image, name: localization.tf,
              description: localization.tfDesc, progress: 0.8,
            ),
            KnowledgeItem(
              image: Image.asset(localization.scrapyLogo).image, name: localization.scrapy,
              description: localization.scrapyDesc, progress: 0.8,
            ),
            KnowledgeItem(
              image: Image.asset(localization.djangoLogo).image, name: localization.django,
              description: localization.djangoDesc, progress: 0.6,
            ),
            KnowledgeItem(
              image: Image.asset(localization.fletLogo).image, name: localization.flet,
              description: localization.fletDesc, progress: 0.9,
            ),
            KnowledgeItem(
              image: Image.asset(localization.pyqtLogo).image, name: localization.pyqt,
              description: localization.pyqtDesc, progress: 0.8,
            ),
            KnowledgeItem(
              image: Image.asset(localization.jQueryLogo).image, name: localization.jQuery,
              description: localization.jQueryDesc, progress: 0.5,
            ),
            KnowledgeItem(
              image: Image.asset(localization.userScriptsLogo).image, name: localization.userScripts,
              description: localization.userScriptsDesc, progress: 0.8,
            ),
            KnowledgeItem(
              image: Image.asset(localization.bootstrapLogo).image, name: localization.bootstrap,
              description: localization.bootstrapDesc, progress: 0.2,
            ),
          ],
        ),
        SectionTile(
          icon: FontAwesomeIcons.database, text: localization.databases, wrapped: true,
          items: [
            KnowledgeItem(
              image: Image.asset(localization.sqliteLogo).image, name: localization.sqlite,
              description: localization.sqliteDesc, progress: 0.9,
            ),
            KnowledgeItem(
              image: Image.asset(localization.postgresqlLogo).image, name: localization.postgresql,
              description: localization.postgresqlDesc, progress: 0.4,
            ),
            KnowledgeItem(
              image: Image.asset(localization.mongoLogo).image, name: localization.mongo,
              description: localization.mongoDesc, progress: 0.6,
            ),
          ],
        ),
        SectionTile(
          icon: FontAwesomeIcons.screwdriver, text: localization.devops, wrapped: true,
          items: [
            KnowledgeItem(
              image: Image.asset(localization.gitLogo).image, name: localization.git,
              description: localization.gitDesc, progress: 0.8,
            ),
            KnowledgeItem(
              image: Image.asset(localization.poetryLogo).image, name: localization.poetry,
              description: localization.poetryDesc, progress: 0.8,
            ),
            KnowledgeItem(
              image: Image.asset(localization.dockerLogo).image, name: localization.docker,
              description: localization.dockerDesc, progress: 0.6,
            ),
            KnowledgeItem(
              image: Image.asset(localization.ghaLogo).image, name: localization.gha,
              description: localization.ghaDesc, progress: 0.7,
            ),
            KnowledgeItem(
              image: Image.asset(localization.gpgLogo).image, name: localization.gpg,
              description: localization.gpgDesc, progress: 0.4,
            ),
          ],
        ),
        SectionTile(
          icon: Icons.design_services, text: localization.graphicTools, wrapped: true,
          items: [
            KnowledgeItem(
              image: Image.asset(localization.inkscapeLogo).image, name: localization.inkscape,
              description: localization.inkscapeDesc, progress: 0.7,
            ),
            KnowledgeItem(
              image: Image.asset(localization.gimpLogo).image, name: localization.gimp,
              description: localization.gimpDesc, progress: 0.6,
            ),
            KnowledgeItem(
              image: Image.asset(localization.blenderLogo).image, name: localization.blender,
              description: localization.blenderDesc, progress: 0.3,
            ),
          ],
        ),
      ],
    );
  }
}

class ProjectsView extends StatelessWidget {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return SliverList.list(
      children: [
        SectionTile(
          icon: FontAwesomeIcons.computer, text: localization.programProjects,
          items: [
            BasicInfoItem(
              title: localization.dnat,
              description: localization.dnatDesc,
              url: Uri.parse(localization.dnatUrl),
            ),
            BasicInfoItem(
              title: localization.bret,
              description: localization.bretDesc,
              url: Uri.parse(localization.bretUrl),
            ),
            BasicInfoItem(
              title: localization.pfs,
              description: localization.pfsDesc,
              url: Uri.parse(localization.pfsDesc),
            ),
            BasicInfoItem(
              title: localization.mld,
              description: localization.mldDesc,
              url: Uri.parse(localization.mldUrl),
            ),
          ],
        ),
        SectionTile(
          icon: FontAwesomeIcons.pen, text: localization.writing,
          items: [
            BasicInfoItem(
              title: localization.learnc,
              description: localization.learncDesc,
              url: Uri.parse(localization.learncUrl),
            )
          ],
        ),
        SectionTile(
          icon: FontAwesomeIcons.image, text: localization.twodGraphics,
          items: [
            CertificationList(
              height: 200,
              certifications: [
                for (var imageName in [
                  'effects_background.png', 'scissors.png', 'BrainGlassesLogo.png', 'Laptop_front_view.png',
                  'learn.png', 'myself_light_circles.png', 'personal_stamp.png'
                ]) Image.asset('images/artwork/$imageName').image
              ],
            ),
          ],
        ),
        SectionTile(
          icon: FontAwesomeIcons.cube, text: localization.threedGraphics,
          items: [
            CertificationList(
              height: 200,
              certifications: [
                for (var imageName in [
                  'arrows.jpg', 'BooksCover.png', 'HamzaLogo3D.png', 'HamzaMulti.png', 'piKey.png',
                  'ProgrammingKeyboard.jpg'
                ]) Image.asset('images/artwork/$imageName').image
              ],
            )
          ],
        )
      ],
    );
  }
}
