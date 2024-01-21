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
  static const String baseUrl = "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid=$apiKey&lang={lang}&units=metric";
  final LatLng geoLocation;
  final String lang;


  OpenWeatherMap({required this.geoLocation, this.lang = 'en'});

  Future<WeatherInfo> getWeather() async {
    final url = baseUrl
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