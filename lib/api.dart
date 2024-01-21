import 'dart:convert';

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
      throw Exception('Failed to load weather');
    }
  }

}

class GitHubProfileInfo {
  final String name;
  final String login;
  final String avatarUrl;
  final String bio;
  final int followerCount;
  final int repositoryCount;
  final int totalStars;
  final Uri url;

  GitHubProfileInfo({
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

  Future<GitHubProfileInfo> getProfileInfo() async {
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
      return GitHubProfileInfo(
        name: profileInfo['name'],
        login: profileInfo['login'],
        avatarUrl: profileInfo['avatarUrl'],
        bio: profileInfo['bio'],
        followerCount: profileInfo['followers']['totalCount'],
        repositoryCount: profileInfo['repositories']['totalCount'],
        totalStars: (profileInfo['repositories']['nodes'] as List).fold(0, (previousValue, element) => previousValue + (element['stargazerCount'] as int)),
        url: Uri.parse(profileInfo['url']),
      );
    } else {
      throw Exception('Failed to load profile info');
    }
  }


}