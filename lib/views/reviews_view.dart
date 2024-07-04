import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../api/mostaql.dart';
import '../item_widgets/reviews_source.dart';

class ReviewsView extends StatelessWidget {
  const ReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return SliverList.list(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(localization.clientReviews, style: Theme.of(context).textTheme.headlineLarge),
          ),
          ReviewsSource(
            icon: ImageIcon(Image.asset('images/logos/mostaql_logo.png').image), name: localization.mostaql,
            reviewsSource: Mostaql(),
          )
        ]
    );
  }
}