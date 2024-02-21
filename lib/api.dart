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
