import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              final reviews = reviewsData.reviews.cast<ReviewData>().map((r) => Directionality(
                textDirection: r.isRTL ? TextDirection.rtl : TextDirection.ltr,
                child: Review(
                    author: r.author, title: r.title, content: r.text, rating: r.averageRating,
                    link: r.link
                ),
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
                        Chip(
                          label: Text(reviewsData.reviews.length.toString()),
                          avatar: const Icon(Icons.rate_review, size: 18),
                          labelStyle: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 5),
                        Chip(
                          label: Text(reviewsData.averageRating.toStringAsFixed(1)),
                          labelStyle: Theme.of(context).textTheme.titleMedium,
                          avatar: const Icon(Icons.star, size: 18),
                        ),
                        const SizedBox(width: 5),
                        Chip(
                          label: Text(reviewsData.authorCount.toString()),
                          labelStyle: Theme.of(context).textTheme.titleMedium,
                          avatar: const Icon(Icons.person, size: 18),
                        ),
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

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  Chip(
                    label: Text(rating.toStringAsFixed(1)),
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    avatar: const Icon(Icons.star, size: 24),
                  )
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
    );
  }
}
