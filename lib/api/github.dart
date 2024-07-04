import 'dart:convert';
import 'package:http/http.dart' as http;

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