import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../item_widgets/knowledge_item.dart';
import '../item_widgets/section_tile.dart';


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
              image: Image.asset(localization.numpyLogo).image, name: localization.numpy,
              description: localization.numpyDesc, progress: 0.7,
            ),
            KnowledgeItem(
              image: Image.asset(localization.mplLogo).image, name: localization.mpl,
              description: localization.mplDesc, progress: 0.6,
            ),
            KnowledgeItem(
              image: Image.asset(localization.pandasLogo).image, name: localization.pandas,
              description: localization.pandasDesc, progress: 0.5,
            ),
            KnowledgeItem(
              image: Image.asset(localization.tfLogo).image, name: localization.tf,
              description: localization.tfDesc, progress: 0.7,
            ),
            KnowledgeItem(
              image: Image.asset(localization.djangoLogo).image, name: localization.django,
              description: localization.djangoDesc, progress: 0.8,
            ),
            KnowledgeItem(
              image: Image.asset(localization.flaskLogo).image, name: localization.flask,
              description: localization.flaskDesc, progress: 0.6,
            ),
            KnowledgeItem(image: Image.asset(localization.pillowLogo).image, name: localization.pillow,
              description: localization.pillowDesc, progress: 0.8,
            ),
            KnowledgeItem(image: Image.asset(localization.opencvLogo).image, name: localization.opencv,
              description: localization.opencvDesc, progress: 0.5,
            ),
            KnowledgeItem(image: Image.asset(localization.seleniumLogo).image, name: localization.selenium,
              description: localization.seleniumDesc, progress: 0.9,
            ),
            KnowledgeItem(
              image: Image.asset(localization.scrapyLogo).image, name: localization.scrapy,
              description: localization.scrapyDesc, progress: 0.7,
            ),
            KnowledgeItem(
              image: Image.asset(localization.pyqtLogo).image, name: localization.pyqt,
              description: localization.pyqtDesc, progress: 0.8,
            ),
            KnowledgeItem(
              image: Image.asset(localization.fletLogo).image, name: localization.flet,
              description: localization.fletDesc, progress: 0.9,
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
              description: localization.bootstrapDesc, progress: 0.7,
            ),
            KnowledgeItem(
              image: Image.asset(localization.reactLogo).image, name: localization.react,
              description: localization.reactDesc, progress: 0.6,
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
              description: localization.blenderDesc, progress: 0.2,
            ),
          ],
        ),
      ],
    );
  }
}