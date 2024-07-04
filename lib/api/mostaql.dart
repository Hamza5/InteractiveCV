import 'dart:convert';

import 'package:http/http.dart' as http;

import 'linkedin.dart';
import 'reviews.dart';


class MostaqlReview extends ReviewData {
  final double proficiency;
  final double contact;
  final double quality;
  final double experience;
  final double timing;
  final double repeat;

  MostaqlReview({
    required String author,
    required String title,
    required String text,
    required this.proficiency,
    required this.contact,
    required this.quality,
    required this.experience,
    required this.timing,
    required this.repeat,
    Uri? link,
  }) : super(
      author: author, title: title, text: text, link: link,
      ratings: [proficiency, contact, quality, experience, timing, repeat]
  );

}

class MostaqlReviews extends ReviewsData {

  MostaqlReviews({
    required reviews,
    required averageProficiency,
    required averageContact,
    required averageQuality,
    required averageExperience,
    required averageTiming,
    required averageRepeat,
  }) : super(
      reviews: reviews,
      ratings: [averageProficiency, averageContact, averageQuality, averageExperience, averageTiming, averageRepeat]
  );
}

class Mostaql implements ReviewsService {
  static const repoReviewsVariableEndpoint = 'https://api.github.com/repos/${const String.fromEnvironment("GITHUB_REPOSITORY")}/actions/variables/MOSTAQL_REVIEWS';
  static const reviewsURL = String.fromEnvironment('MOSTAQL_REVIEWS_URL');
  static const headers = LinkedIn.headers;

  Mostaql();

  @override
  Future<MostaqlReviews> getReviews() async {
    final response = await http.get(
      Uri.parse(repoReviewsVariableEndpoint),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> reviewsData = jsonDecode(jsonDecode(response.body)['value']);
      return MostaqlReviews(
        averageProficiency: reviewsData['average_proficiency'],
        averageContact: reviewsData['average_contact'],
        averageQuality: reviewsData['average_quality'],
        averageExperience: reviewsData['average_experience'],
        averageTiming: reviewsData['average_timing'],
        averageRepeat: reviewsData['average_repeat'],
        reviews: (reviewsData['reviews'] as List).map((review) => MostaqlReview(
          title: review['title'],
          text: review['text'],
          author: review['author'],
          proficiency: review['proficiency'],
          contact: review['contact'],
          quality: review['quality'],
          experience: review['experience'],
          timing: review['timing'],
          repeat: review['repeat'],
          link: Uri.parse(reviewsURL),
        )).toList(),
      );
    } else {
      throw Exception('Failed to load Mostaql reviews');
    }
  }
}