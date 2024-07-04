import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'linkedin.dart';

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