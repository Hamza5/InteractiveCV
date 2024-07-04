import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class WeatherInfo {
  final String description;
  final String iconName;
  final double temperature;
  final double feelsLike;
  final double windSpeed;
  final double windDegree;
  final double humidity;

  WeatherInfo({
    required this.description,
    required this.iconName,
    required this.temperature,
    required this.feelsLike,
    required this.windSpeed,
    required this.windDegree,
    required this.humidity,
  });
}

class OpenWeatherMap {

  static const apiKey = String.fromEnvironment('OWM_API_KEY');
  static const String endpoint = "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid=$apiKey&lang={lang}&units=metric";
  final LatLng geoLocation;
  final String lang;


  OpenWeatherMap({required this.geoLocation, this.lang = 'en'});

  Future<WeatherInfo> getWeather() async {
    final url = endpoint
      .replaceFirst('{lat}', geoLocation.latitude.toString())
      .replaceFirst('{lon}', geoLocation.longitude.toString())
      .replaceFirst('{lang}', lang);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> currentWeather = jsonDecode(response.body);
      return WeatherInfo(
        description: currentWeather['weather'][0]['description'],
        iconName: currentWeather['weather'][0]['icon'],
        temperature: currentWeather['main']['temp'],
        feelsLike: currentWeather['main']['feels_like'],
        windSpeed: (currentWeather['wind']['speed'] / 1000) / (1 / 3600),
        windDegree: currentWeather['wind']['deg'],
        humidity: currentWeather['main']['humidity'],
      );
    } else {
      throw Exception('Failed to load OpenWeatherMap weather info');
    }
  }

}

class GitHubProfile {
  final String name;
  final String login;
  final Uri avatarUrl;
  final String bio;
  final int followerCount;
  final int repositoryCount;
  final int totalStars;
  final Uri url;

  GitHubProfile({
    required this.name,
    required this.login,
    required this.avatarUrl,
    required this.bio,
    required this.followerCount,
    required this.repositoryCount,
    required this.totalStars,
    required this.url,
  });
}

class GitHub {
  static const String apiKey = String.fromEnvironment('GITHUB_PROFILE_TOKEN');
  static const String endpoint = "https://api.github.com/graphql";
  static const Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};

  GitHub();

  Future<GitHubProfile> getProfileInfo() async {
    const String query = """
      query {
        viewer {
          login,
          name,
          avatarUrl,
          url,
          bio,
          followers {
            totalCount
          },
          repositories(first: 100, orderBy: {direction: DESC, field: CREATED_AT}) {
            totalCount,
            nodes {
              name,
              stargazerCount
            }
          }
        }
      }
    """;
    final response = await http.post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(<String, String>{'query': query}),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> profileInfo = jsonDecode(response.body)['data']['viewer'];
      return GitHubProfile(
        name: profileInfo['name'],
        login: profileInfo['login'],
        avatarUrl: Uri.parse(profileInfo['avatarUrl']),
        bio: profileInfo['bio'],
        followerCount: profileInfo['followers']['totalCount'],
        repositoryCount: profileInfo['repositories']['totalCount'],
        totalStars: (profileInfo['repositories']['nodes'] as List).fold(0, (previousValue, element) => previousValue + (element['stargazerCount'] as int)),
        url: Uri.parse(profileInfo['url']),
      );
    } else {
      throw Exception('Failed to load GitHub profile info');
    }
  }
}

class StackOverflowProfile {
  final String displayName;
  final String aboutMe;
  final Uri link;
  final Uri profileImage;
  final int reputation;
  final int bronzeBadgeCount;
  final int silverBadgeCount;
  final int goldBadgeCount;
  final int questionCount;
  final int answerCount;
  final int viewCount;

  StackOverflowProfile({
    required this.displayName,
    required this.aboutMe,
    required this.link,
    required this.profileImage,
    required this.reputation,
    required this.bronzeBadgeCount,
    required this.silverBadgeCount,
    required this.goldBadgeCount,
    required this.questionCount,
    required this.answerCount,
    required this.viewCount,
  });
}

class StackOverflow {
  static const String accessToken = String.fromEnvironment('STACKEXCHANGE_ACCESS_TOKEN');
  static const String key = String.fromEnvironment('STACKEXCHANGE_KEY');
  static const String meEndpoint = 'https://api.stackexchange.com/2.3/me?order=desc&sort=reputation&site=stackoverflow&filter=!)6DoWC*S3Tbm-VR9mkl04Own6ACz&access_token=$accessToken&key=$key';

  StackOverflow();

  Future<StackOverflowProfile> getProfileInfo() async {
    final response = await http.get(Uri.parse(meEndpoint));
    if (response.statusCode == 200) {
      final Map<String, dynamic> profileInfo = jsonDecode(response.body)['items'][0];
      return StackOverflowProfile(
        displayName: profileInfo['display_name'],
        aboutMe: profileInfo['about_me'].replaceAll(RegExp(r'<[^>]*>'), ''),
        link: Uri.parse(profileInfo['link']),
        profileImage: Uri.parse(profileInfo['profile_image']),
        reputation: profileInfo['reputation'],
        bronzeBadgeCount: profileInfo['badge_counts']['bronze'],
        silverBadgeCount: profileInfo['badge_counts']['silver'],
        goldBadgeCount: profileInfo['badge_counts']['gold'],
        questionCount: profileInfo['question_count'],
        answerCount: profileInfo['answer_count'],
        viewCount: profileInfo['view_count'],
      );
    } else {
      throw Exception('Failed to load StackOverflow profile info');
    }
  }
}

class LinkedInProfile {
  final String name;
  final String headline;
  final Uri profilePicture;
  final Uint8List profilePictureBytes;
  final Uri url;
  final int connectionsCount;

  LinkedInProfile({
    required this.name,
    required this.headline,
    required this.profilePicture,
    required this.profilePictureBytes,
    required this.url,
    required this.connectionsCount,
  });
}

class LinkedIn {
  static const repoProfileVariableEndpoint = 'https://api.github.com/repos/${const String.fromEnvironment("GITHUB_REPOSITORY")}/actions/variables/LINKEDIN_PROFILE';
  static const profileURL = String.fromEnvironment('LINKEDIN_PROFILE_URL');
  static const headers = {
    ...GitHub.headers,
    'Accept': 'application/vnd.github+json',
    'X-GitHub-Api-Version': '2022-11-28'
  };

  LinkedIn();

  Future<LinkedInProfile> getProfileInfo() async {
    final response = await http.get(
      Uri.parse(repoProfileVariableEndpoint),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> profileInfo = jsonDecode(jsonDecode(response.body)['value']);
      return LinkedInProfile(
        name: profileInfo['name'],
        headline: profileInfo['about'],
        profilePicture: Uri.parse(profileInfo['profile_picture_url']),
        profilePictureBytes: base64Decode(profileInfo['profile_picture_base64']),
        url: Uri.parse(profileURL),
        connectionsCount: profileInfo['connection_count'],
      );
    } else {
      throw Exception('Failed to load LinkedIn profile info');
    }
  }
}


class HsoubAcademyProfile {
  final String name;
  final Uri profilePicture;
  final Uint8List profilePictureBytes;
  final Uri url;
  final int postCount;
  final int reputation;
  final int bestAnswerCount;
  final String level;
  final String about;

  HsoubAcademyProfile({
    required this.name,
    required this.profilePicture,
    required this.profilePictureBytes,
    required this.url,
    required this.postCount,
    required this.reputation,
    required this.bestAnswerCount,
    required this.level,
    required this.about,
  });
}

class HsoubAcademy {
  static const repoProfileVariableEndpoint = 'https://api.github.com/repos/${const String.fromEnvironment("GITHUB_REPOSITORY")}/actions/variables/HSOUB_ACADEMY_PROFILE';
  static const profileURL = String.fromEnvironment('HSOUB_ACADEMY_PROFILE_URL');
  static const headers = LinkedIn.headers;

  HsoubAcademy();

  Future<HsoubAcademyProfile> getProfileInfo() async {
    final response = await http.get(
      Uri.parse(repoProfileVariableEndpoint),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> profileInfo = jsonDecode(jsonDecode(response.body)['value']);
      return HsoubAcademyProfile(
        name: profileInfo['name'],
        profilePicture: Uri.parse(profileInfo['profile_picture_url']),
        url: Uri.parse(profileURL),
        profilePictureBytes: base64Decode(profileInfo['profile_picture_base64']),
        postCount: profileInfo['postCount'],
        reputation: profileInfo['reputation'],
        bestAnswerCount: profileInfo['bestAnswerCount'],
        level: profileInfo['level'],
        about: profileInfo['about']
      );
    } else {
      throw Exception('Failed to load Hsoub Academy profile info');
    }
  }
}

abstract class ReviewData {
  final String author;
  final String title;
  final String text;
  final List<double> ratings;
  final Uri? link;

  ReviewData({
    required this.author, required this.title, required this.text,
    required this.ratings, this.link,
  });

  double get averageRating => ratings.fold(0.0, (previousValue, element) => previousValue + element) / ratings.length;

  bool get isRTL => text.contains(RegExp(r'[\u0590-\u05FF\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF\u1EE00-\u1EEFF]'));

}

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

abstract class ReviewsData {
  List<ReviewData> reviews;
  List<double> ratings;

  ReviewsData({
    required this.reviews,
    required this.ratings,
  });

  double get averageRating => ratings.fold(0.0, (previousValue, element) => previousValue + element) / ratings.length;

  int get authorCount => reviews.map((review) => review.author).toSet().length;
}

abstract class ReviewsService {
  Future<ReviewsData> getReviews();
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