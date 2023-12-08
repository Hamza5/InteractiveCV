import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'item_widgets.dart';

const email = 'hamza.abbad@gmail.com';
const phone1 = '🇨🇳 +86 139 7165 4983';
const phone2 = '🇩🇿 +213 659 41 84 69';
const streetAddress = 'Dayou Wenyuan';
const city = 'Dalian';
const province = 'Liaoning';
const country = 'China';
const geoPosition = LatLng(38.8820, 121.5022);
const nationality = '🇩🇿 Algerian';
const religion = '☪️ Islam';
const github = 'github.com/Hamza5';
const linkedin = 'linkedin.com/in/hamza-abbad/';
const stackOverflow = 'stackoverflow.com/users/5008968/hamza-abbad';

const university1 = 'University of Science and Technology Houari Boumediene (USTHB)';
const university1Logo = 'images/logos/usthb_logo.png';
const university1Url = 'https://www.usthb.dz/';
const university2 = 'Wuhan University of Technology (WHUT)';
const university2Logo = 'images/logos/whut_logo.png';
const university2Url = 'https://www.whut.edu.cn/';
const institution3 = 'International Education Specialists (IDP)';
const institution3Logo = 'images/logos/idp_logo.png';
const institution3Url = 'https://www.idp.com/';
const institution3Certification = 'images/certificates/IELTS_TRF.jpg';
const specialities = [
  'Bachelor in Computer Science', 'Master in Artificial Intelligence', 'Mandarin Chinese',
  'PhD in Arabic Natural Language Processing using Deep Learning',
  'International English Language Testing System (IELTS)'
] ;
const universityNames = [university1, university1, university2, university2];
const universityLogos = [university1Logo, university1Logo, university2Logo, university2Logo];
const studyYears = ['2012-2015', '2015-2017', '2017-2018', '2018-2024', '2018'];

class BasicInfoView extends StatelessWidget {

  const BasicInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final large = MediaQuery.of(context).size.width >= 500;
    return ListView(
      children: [
        SectionTile(
          icon: Icons.contacts, text: 'Contact information', wrapped: large,
          items: [
            BasicInfoItem(icon: Icons.email, title: email, url: Uri.parse('mailto:$email'), shrink: large),
            BasicInfoItem(icon: Icons.phone, title: phone1, url: Uri.parse('tel:$phone1'), shrink: large),
            BasicInfoItem(icon: Icons.phone, title: phone2, url: Uri.parse('tel:$phone2'), shrink: large),
          ],
        ),
        SectionTile(
            icon: Icons.person_2, text: 'Personal', wrapped: large,
            items: [
              BasicInfoItem(icon: FontAwesomeIcons.book, title: religion, shrink: large),
              BasicInfoItem(icon: FontAwesomeIcons.flag, title: nationality, shrink: large),
            ]
        ),
        SectionTile(
          icon: Icons.language, text: 'Spoken languages',
          items: [
            KnowledgeItem(
              image: Image.asset('images/flags/arab-league.png').image, name: 'العَرَبِيَّة', dropImageShadow: true,
              description: 'Standard Arabic and most dialects', rectangularImage: true,
              progress: 0.9,
            ),
            KnowledgeItem(
              image: Image.asset('images/flags/united-states.png').image, name: 'English', dropImageShadow: true,
              description: 'American accent', progress: 0.8, rectangularImage: true,
            ),
            KnowledgeItem(
              image: Image.asset('images/flags/france.png').image, name: 'Français', dropImageShadow: true,
              description: 'Metropolitan French', progress: 0.7, rectangularImage: true,
            ),
            KnowledgeItem(
              image: Image.asset('images/flags/china.png').image, name: '中文', dropImageShadow: true,
              description: 'Mandarin Chinese', progress: 0.6, rectangularImage: true,
            ),
            KnowledgeItem(
              image: Image.asset('images/flags/russia.png').image, name: 'Русский', dropImageShadow: true,
              description: 'Basic words and sentences', progress: 0.1, rectangularImage: true,
            )
          ],
          wrapped: true,
        ),
        SectionTile(icon: Icons.web, text: 'Web presence', wrapped: large,
            items: [
              BasicInfoItem(
                icon: FontAwesomeIcons.github, title: github, url: Uri.parse('https://$github'), shrink: large,
              ),
              BasicInfoItem(
                icon: FontAwesomeIcons.stackOverflow, title: stackOverflow, url: Uri.parse('https://$stackOverflow'),
                shrink: large,
              ),
              BasicInfoItem(
                icon: FontAwesomeIcons.linkedin, title: linkedin, url: Uri.parse('https://$linkedin'), shrink: large,
              ),
            ]
        ),
        SectionTile(icon: Icons.location_city, text: 'Physical presence', items: [
          LocationItem(
              geoPosition: geoPosition, country: country, province: province, city: city, streetAddress: streetAddress
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
    return ListView(
      children: [
        InstitutionItem(
            logo: Image.asset(university1Logo).image, title: university1, url: Uri.parse(university1Url),
            items: [
              FieldItem(
                title: specialities[0], trailing: studyYears[0],
                items: [
                  CertificationList(
                    certifications: [
                      for (var fileName in ['Bachelor-1.jpg', 'Bachelor-2.jpg'])
                        Image.asset('images/certificates/$fileName').image
                    ],
                    height: 300,
                  )
                ],
              ),
              FieldItem(
                title: specialities[1], trailing: studyYears[1],
                items: [
                  CertificationList(
                    certifications: [
                      for (var fileName in ['Master-1.jpg', 'Master-2.jpg'])
                        Image.asset('images/certificates/$fileName').image
                    ],
                    height: 300,
                  )
                ],
              )
            ]
        ),
        InstitutionItem(
            logo: Image.asset(university2Logo).image, title: university2, url: Uri.parse(university2Url),
            items: [
              FieldItem(title: specialities[2], trailing: studyYears[2]),
              FieldItem(
                title: specialities[3], trailing: studyYears[3],
                items: [
                  CertificationList(
                    height: 500,
                    certifications: [
                      Image.asset('images/certificates/2020-paper.jpg').image,
                      Image.asset('images/certificates/2022-paper.jpg').image,
                    ],
                  )
                ],
              )
            ]
        ),
        InstitutionItem(
          logo: Image.asset(institution3Logo).image, title: institution3, url: Uri.parse(institution3Url),
          items: [
            FieldItem(
              title: specialities[4], trailing: studyYears[4],
              items: [
                CertificationList(
                  certifications: [Image.asset(institution3Certification).image],
                  height: 500,
                ),
              ],
            )
          ],
        ),
        InstitutionItem(
          logo: Image.asset('images/logos/coursera_logo.png').image, title: 'Coursera',
          url: Uri.parse('https://www.coursera.org/'),
          items: [
            FieldItem(
              title: 'Machine Learning', trailing: '2018',
              items: [
                CertificationList(
                  certifications: [Image.asset('images/certificates/Coursera-congrats.png').image],
                  height: 200,
                ),
              ],
            )
          ],
        ),
        InstitutionItem(
          logo: Image.asset('images/logos/edx_logo.png').image, title: 'EdX', url: Uri.parse('https://www.edx.org/'),
          items: [
            FieldItem(
              title: 'Reinforcement Learning Explained', trailing: '2019',
              items: [
                CertificationList(
                  certifications: [Image.asset('images/certificates/Reinforcement_learning_certificate.jpg').image],
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
    return ListView(
      children: [
        InstitutionItem(
          logo: Image.asset('images/logos/albaraka_logo.png').image, title: 'AlBaraka Bank',
          url: Uri.parse('https://www.albaraka-bank.dz/'),
          items: [
            FieldItem(
              title: 'Internship in IT', trailing: '2014',
              items: [
                CertificationList(
                  certifications: [Image.asset('images/certificates/Internship_2014.jpg').image],
                  height: 500,
                )
              ],
            ),
          ],
        ),
        InstitutionItem(
          logo: Image.asset('images/logos/dataimpact_logo.png').image, title: 'Data Impact',
          url: Uri.parse('https://www.dataimpact.io/'),
          items: const [
            FieldItem(
              title: 'Web scraping for digital shelf', trailing: '2022',
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
    return ListView(
      children: [
        SectionTile(
          icon: FontAwesomeIcons.computer, text: 'Operating systems', wrapped: true,
          items: [
            KnowledgeItem(
              image: Image.asset('images/logos/Windows_logo.png').image, name: 'Windows',
              description: 'Dell Laptop', progress: 0.8,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/Kubuntu_logo.png').image, name: 'Kubuntu',
              description: 'Dell Laptop', progress: 0.7,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/archlinux_logo.png').image, name: 'Arch Linux',
              description: 'Dell laptop', progress: 0.6,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/macOS_logo.png').image, name: 'Mac OS',
              description: 'Apple Macbook', progress: 0.3,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/Android_logo.png').image, name: 'Android',
              description: 'OnePlus Smartphone', progress: 0.7,
            ),
          ],
        ),
        SectionTile(
          icon: Icons.app_settings_alt, text: 'Programming and markup languages', wrapped: true,
          items: [
            KnowledgeItem(
              image: Image.asset('images/logos/Python_logo.png').image, name: 'Python',
              description: 'Backend and scripting', progress: 0.95,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/Flutter_logo.png').image, name: 'Dart/Flutter',
              description: 'Multiplatform development', progress: 0.7,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/JavaScript_logo.png').image, name: 'JavaScript',
              description: 'Web browser environment', progress: 0.5,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/Java_logo.png').image, name: 'Java',
              description: 'Desktop development', progress: 0.5,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/Markdown_logo.png').image, name: 'Markdown',
              description: 'Documentation writing', progress: 0.95,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/HTML5_logo.png').image, name: 'HTML/CSS',
              description: 'Basic markup', progress: 0.5,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/LaTeX_project_logo.png').image, name: 'LaTeX',
              description: 'Document publishing', progress: 0.6,
            ),
          ],
        ),
        SectionTile(
          icon: Icons.library_books, text: 'Frameworks and libraries', wrapped: true,
          items: [
            KnowledgeItem(
              image: Image.asset('images/logos/Jupyter_logo.png').image, name: 'Jupyter',
              description: 'Interactive programming', progress: 0.8,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/Matplotlib_logo.png').image, name: 'Matplotlib',
              description: 'Visualization and charting', progress: 0.6,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/Tensorflow_logo.png').image, name: 'TensorFlow',
              description: 'Deep learning', progress: 0.8,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/Scrapy_logo.png').image, name: 'Scrapy',
              description: 'Web crawling', progress: 0.8,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/Django_logo.png').image, name: 'Django',
              description: 'Backend web development', progress: 0.7,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/Flet_logo.png').image, name: 'Flet',
              description: 'Web app development', progress: 0.9,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/PyQt_logo.png').image, name: 'PyQt',
              description: 'Desktop GUI development', progress: 0.8,
            ),
          ],
        ),
        SectionTile(
          icon: FontAwesomeIcons.database, text: 'Databases', wrapped: true,
          items: [
            KnowledgeItem(
              image: Image.asset('images/logos/SQLite_logo.png').image, name: 'SQLite',
              description: 'File-based simple database', progress: 0.9,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/Postgresql_logo.png').image, name: 'Postgresql',
              description: 'Fully-featured relational database', progress: 0.4,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/MongoDB_logo.png').image, name: 'MongoDB',
              description: 'Advanced NoSQL database', progress: 0.6,
            ),
          ],
        ),
        SectionTile(
          icon: FontAwesomeIcons.screwdriver, text: 'DevOps', wrapped: true,
          items: [
            KnowledgeItem(
              image: Image.asset('images/logos/Git_logo.png').image, name: 'Git',
              description: 'Version control system', progress: 0.8,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/Poetry_logo.png').image, name: 'Poetry',
              description: 'Python packaging', progress: 0.8,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/Docker_logo.png').image, name: 'Docker',
              description: 'Container building tool', progress: 0.6,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/GitHub_logo.png').image, name: 'GH Actions',
              description: 'CI/CD workflows', progress: 0.7,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/Gnupg_logo.png').image, name: 'GnuPG',
              description: 'Encryption and signing', progress: 0.4,
            ),
          ],
        ),
        SectionTile(
          icon: Icons.design_services, text: 'Graphic tools', wrapped: true,
          items: [
            KnowledgeItem(
              image: Image.asset('images/logos/Inkscape_logo.png').image, name: 'Inkscape',
              description: 'Vector graphics design', progress: 0.7,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/GIMP_logo.png').image, name: 'GIMP',
              description: 'Image editing', progress: 0.6,
            ),
            KnowledgeItem(
              image: Image.asset('images/logos/Blender_logo.png').image, name: 'Blender',
              description: '3D modeling and rendering', progress: 0.4,
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
    return ListView(
      children: [
        SectionTile(
          icon: FontAwesomeIcons.computer, text: 'Programming',
          items: [
            BasicInfoItem(
              title: 'DNA translator (Arabic)',
              description: 'Classic AutoIt and HTML/CSS/JS app to translate between the DNA and RNA sequences',
              url: Uri.parse('https://github.com/Hamza5/DNA-translator_AR/'),
            ),
            BasicInfoItem(
              title: 'Basic Regular Expression Tester',
              description: 'Python3/PyQt4 application to test regular expressions functions on a text',
              url: Uri.parse('https://github.com/Hamza5/Basic-Regular-Expressions-Tester'),
            ),
            BasicInfoItem(
              title: 'Periodical File Sender',
              description: 'Python3/PyQt5 application that allows sending emails with attachment periodically using an '
                  'SMTP server',
              url: Uri.parse('https://github.com/Hamza5/Periodical-File-Sender/'),
            ),
            BasicInfoItem(
              title: 'Multilevel diacritizer',
              description: 'Flask/Flutter/TensorFlow web application acting as a GUI to a Deep Learning model developed'
                  ' for research work',
              url: Uri.parse('https://github.com/Hamza5/multilevel-diacritizer'),
            ),
          ],
        ),
        SectionTile(
          icon: FontAwesomeIcons.pen, text: 'Writing',
          items: [
            BasicInfoItem(
              title: 'Learn to program with C (Arabic)',
              description: 'Translation of a French book teaching the C programming language to Arabic',
              url: Uri.parse('https://github.com/Hamza5/Learn-to-program-with-C_AR'),
            )
          ],
        ),
        SectionTile(
          icon: FontAwesomeIcons.image, text: '2D graphics',
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
          icon: FontAwesomeIcons.cube, text: '3D graphics',
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
