import 'dart:convert';

import 'package:http/http.dart' as http;


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