import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'github.dart';


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
