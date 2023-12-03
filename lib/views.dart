import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'item_widgets.dart';

const email = 'hamza.abbad@gmail.com';
const phone1 = '🇨🇳 +86 139 7165 4983';
const phone2 = '🇩🇿 +213 659 41 84 69';
const streetAddress = 'DaYouWen garden';
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
const university1Logo = 'images/usthb_logo.png';
const university1Url = 'https://www.usthb.dz/';
const university2 = 'Wuhan University of Technology (WHUT)';
const university2Logo = 'images/whut_logo.png';
const university2Url = 'https://www.whut.edu.cn/';
const institution3 = 'International Education Specialists (IDP)';
const institution3Logo = 'images/idp_logo.png';
const institution3Url = 'https://www.idp.com/';
const institution3Certification = 'images/IELTS_TRF.jpg';
const specialities = [
  'Bachelor in Computer Science', 'Master in Artificial Intelligence', 'Mandarin Chinese',
  'PhD in Arabic Natural Language Processing using Deep Learning',
  'International English Language Testing System (IELTS)'
] ;
const universityNames = [university1, university1, university2, university2];
const universityLogos = [university1Logo, university1Logo, university2Logo, university2Logo];
const studyYears = ['2012-2015', '2015-2017', '2017-2018', '2018-2024', '2018'];
const bachelorCertifications = ['images/Bachelor-1.jpg', 'images/Master-2.jpg'];

class BasicInfoView extends StatelessWidget {

  const BasicInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SectionTile(
          icon: Icons.contacts, text: 'Contact information',
          items: [
            BasicInfoItem(icon: Icons.email, text: email, url: Uri.parse('mailto:$email')),
            BasicInfoItem(icon: Icons.phone, text: phone1, url: Uri.parse('tel:$phone1'),),
            BasicInfoItem(icon: Icons.phone, text: phone2, url: Uri.parse('tel:$phone2'),),
          ],
        ),
        const SectionTile(
            icon: Icons.person_2, text: 'Personal',
            items: [
              BasicInfoItem(icon: FontAwesomeIcons.book, text: religion),
              BasicInfoItem(icon: FontAwesomeIcons.flag, text: nationality),
            ]
        ),
        SectionTile(
          icon: Icons.language, text: 'Spoken languages',
          items: [
            LanguageItem(
              flag: Image.asset('images/arab-league.png').image, name: 'العَرَبِيَّة',
              description: 'Standard Arabic and most dialects',
              progress: 0.95,
            ),
            LanguageItem(
              flag: Image.asset('images/united-states.png').image, name: 'English',
              description: 'American accent', progress: 0.85,
            ),
            LanguageItem(
              flag: Image.asset('images/france.png').image, name: 'Français',
              description: 'Metropolitan French', progress: 0.8,
            ),
            LanguageItem(
              flag: Image.asset('images/china.png').image, name: '中文',
              description: 'Mandarin Chinese', progress: 0.6,
            ),
            LanguageItem(
              flag: Image.asset('images/russia.png').image, name: 'Русский',
              description: 'Basic words and sentences', progress: 0.1,
            )
          ],
          wrapped: true,
        ),
        SectionTile(icon: Icons.web, text: 'Web presence',
            items: [
              BasicInfoItem(icon: FontAwesomeIcons.github, text: github, url: Uri.parse('https://$github'),),
              BasicInfoItem(
                icon: FontAwesomeIcons.stackOverflow, text: stackOverflow, url: Uri.parse('https://$stackOverflow'),
              ),
              BasicInfoItem(icon: FontAwesomeIcons.linkedin, text: linkedin, url: Uri.parse('https://$linkedin'),),
            ]
        ),
        const SectionTile(icon: Icons.location_city, text: 'Physical presence', items: [
          LocationItem(
              geoPosition: geoPosition, country: country, province: province, city: city, streetAddress: streetAddress
          )
        ])
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
              ExperienceItem(
                title: specialities[0], trailing: studyYears[0],
                items: [
                  CertificationList(
                    certifications: [
                      for (var fileName in ['Bachelor-1.jpg', 'Bachelor-2.jpg']) Image.asset('images/$fileName').image
                    ],
                    height: 300,
                  )
                ],
              ),
              ExperienceItem(
                title: specialities[1], trailing: studyYears[1],
                items: [
                  CertificationList(
                    certifications: [
                      for (var fileName in ['Master-1.jpg', 'Master-2.jpg']) Image.asset('images/$fileName').image
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
              ExperienceItem(title: specialities[2], trailing: studyYears[2]),
              ExperienceItem(title: specialities[3], trailing: studyYears[3])
            ]
        ),
        InstitutionItem(
          logo: Image.asset(institution3Logo).image, title: institution3, url: Uri.parse(institution3Url),
          items: [
            ExperienceItem(
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
          logo: Image.asset('images/coursera_logo.png').image, title: 'Coursera',
          url: Uri.parse('https://www.coursera.org/'),
          items: [
            ExperienceItem(
              title: 'Machine Learning', trailing: '2018',
              items: [
                CertificationList(
                  certifications: [Image.asset('images/Coursera-congrats.png').image],
                  height: 200,
                ),
              ],
            )
          ],
        ),
        InstitutionItem(
          logo: Image.asset('images/edx_logo.png').image, title: 'EdX', url: Uri.parse('https://www.edx.org/'),
          items: [
            ExperienceItem(
              title: 'Reinforcement Learning', trailing: '2019',
              items: [
                CertificationList(
                  certifications: [Image.asset('images/Reinforcement_learning_certificate.jpg').image],
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
