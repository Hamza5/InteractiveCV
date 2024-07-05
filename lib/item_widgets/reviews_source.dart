import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../api/reviews.dart';

class ReviewsSource extends StatelessWidget {

  final Widget icon;
  final String name;
  final ReviewsService reviewsSource;

  const ReviewsSource({
    super.key,
    required this.icon,
    required this.name,
    required this.reviewsSource,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Card(
      child: FutureBuilder<ReviewsData>(
          future: reviewsSource.getReviews(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              debugPrintStack(stackTrace: snapshot.stackTrace);
              return const SizedBox.shrink();
            } else if (snapshot.hasData) {
              final reviewsData = snapshot.requireData;
              final reviews = reviewsData.reviews.cast<ReviewData>().map((r) => Review(
                  author: r.author, title: r.title, content: r.text, rating: r.averageRating,
                  link: r.link
              )).toList();
              return ExpansionTile(
                tilePadding: const EdgeInsets.all(10),
                childrenPadding: const EdgeInsets.all(10),
                title: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          margin: const EdgeInsetsDirectional.only(end: 5),
                          child: icon,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: Theme.of(context).textTheme.titleLarge),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.wifi, size: 12),
                                const SizedBox(width: 5),
                                Text(localization.dataSource('scrap')),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StatIconChip(icon: Icons.rate_review, value: reviewsData.reviews.length),
                        const SizedBox(width: 5),
                        StatIconChip(icon: Icons.star, value: reviewsData.averageRating),
                        const SizedBox(width: 5),
                        StatIconChip(icon: Icons.person, value: reviewsData.authorCount),
                      ],
                    )
                  ],
                ),
                initiallyExpanded: true,
                children: reviews,
              );
            } else {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const CircularProgressIndicator(),
              );
            }
          }
      ),
    );
  }

}

class Review extends StatelessWidget {

  final String author;
  final String title;
  final String content;
  final double rating;
  final Uri? link;

  const Review({
    super.key,
    required this.author,
    required this.title,
    required this.content,
    required this.rating,
    this.link,
  });

  bool get isRTL => content.startsWith(
    RegExp(r'[\u0590-\u05FF\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF\u1EE00-\u1EEFF]'),
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Card(
        child: InkWell(
          onTap: link != null ? () => launchUrl(link!) : null,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Text(author, style: Theme.of(context).textTheme.titleSmall),
                        ],
                      ),
                    ),
                    StatIconChip(icon: Icons.star, value: rating),
                  ],
                ),
                const Divider()
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(content, style: Theme.of(context).textTheme.bodyLarge),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class StatIconChip extends StatelessWidget {

  final IconData icon;
  final num value;

  const StatIconChip({super.key, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(NumberFormat("#.#").format(value), textDirection: TextDirection.ltr),
      labelStyle: Theme.of(context).textTheme.titleMedium,
      avatar: Icon(icon, size: 20),
    );
  }
}
