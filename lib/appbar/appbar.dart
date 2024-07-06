import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'circle_photo.dart';
import 'color_selection.dart';
import 'language_switch.dart';
import 'theme_settings.dart';

Widget buildAppBar(BuildContext context, bool innerBoxIsScrolled, ValueNotifier<ThemeSettings> themeNotifier) {
  final localization = AppLocalizations.of(context)!;
  return SliverOverlapAbsorber(
    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
    sliver: SliverAppBar(
      pinned: true,
      toolbarHeight: 100,
      expandedHeight: 200,
      forceElevated: innerBoxIsScrolled,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            if (const bool.hasEnvironment('LAST_UPDATE'))
              Container(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    localization.lastUpdate(DateTime.parse(const String.fromEnvironment('LAST_UPDATE'))),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).appBarTheme.titleTextStyle?.color?.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            Container(
              alignment: AlignmentDirectional.topEnd,
              child: ColorSelection(themeNotifier: themeNotifier),
            ),
            Container(
              alignment: AlignmentDirectional.bottomEnd,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: LanguageSwitch(themeNotifier: themeNotifier),
              ),
            )
          ],
        ),
        titlePadding: const EdgeInsetsDirectional.symmetric(vertical: 10),
        title: LayoutBuilder(
            builder: (context, constraints) {
              return Align(
                alignment: const Alignment(0, 0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LimitedBox(
                      maxWidth: constraints.maxWidth * 0.25,
                      child: CirclePhoto(photo: Image.asset(localization.photoPath).image),
                    ),
                    const SizedBox(width: 5),
                    LimitedBox(
                      maxWidth: constraints.maxWidth * 0.7,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localization.fullName,
                              style: Theme.of(context).appBarTheme.titleTextStyle,
                            ),
                            Text(
                              localization.shortDescription,
                              style: Theme.of(context).appBarTheme.toolbarTextStyle,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
        ),
      ),
    ),
  );
}