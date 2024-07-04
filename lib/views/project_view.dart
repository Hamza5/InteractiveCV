import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../item_widgets/basic_info_item.dart';
import '../item_widgets/certification_list.dart';
import '../item_widgets/section_tile.dart';

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
            BasicInfoItem(
              title: localization.mdwn,
              description: localization.mdwnDesc,
              url: Uri.parse(localization.mdwnUrl),
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