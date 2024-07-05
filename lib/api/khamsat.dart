import 'dart:convert';

import 'package:http/http.dart' as http;

import 'linkedin.dart';
import 'reviews.dart';


class KhamsatReview extends ReviewData {

  final double contact;
  final double quality;
  final double timing;

  KhamsatReview({
    required String author,
    required String title,
    required String text,
    required this.contact,
    required this.quality,
    required this.timing,
    Uri? link,
  }) : super(
    ratings: [quality, contact, timing],
    author: author,
    title: title,
    text: text,
    link: link,
  );

}

class KhamsatReviews extends ReviewsData {

  KhamsatReviews({
    required averageContact,
    required averageQuality,
    required averageTiming,
    required reviews,
  }) : super(
    reviews: reviews,
    ratings: [averageQuality, averageContact, averageTiming],
  );

}

class Khamsat implements ReviewsService {
  static const repoReviewsVariableEndpoint = 'https://api.github.com/repos/${const String.fromEnvironment("GITHUB_REPOSITORY")}/actions/variables/KHAMSAT_REVIEWS';
  static const reviewsURL = String.fromEnvironment('KHAMSAT_REVIEWS_URL');
  static const headers = LinkedIn.headers;

  Khamsat();

  @override
  Future<KhamsatReviews> getReviews() async {
    final response = await http.get(
      Uri.parse(repoReviewsVariableEndpoint),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load Khamsat reviews');
    }

    final Map<String, dynamic> reviewsData = jsonDecode(jsonDecode(response.body)['value']);

    return KhamsatReviews(
      averageContact: reviewsData['average_contact'],
      averageQuality: reviewsData['average_quality'],
      averageTiming: reviewsData['average_timing'],
      reviews: (reviewsData['reviews'] as List).map((review) => KhamsatReview(
        title: review['title'],
        text: review['text'],
        author: review['author'],
        contact: review['contact'],
        quality: review['quality'],
        timing: review['timing'],
        link: Uri.parse(review['link'] ?? reviewsURL),
      )).toList(),
    );
  }
}
