import 'dart:convert';
import 'package:http/http.dart' as http;
import 'leaderboard_repository.dart';
import '../../models/player.dart';

class LeaderboardRepositoryClass implements LeaderboardRepository {
  final String apiUrl = 'https://dart-leaderboard-rdchfzm4oa-ey.a.run.app';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Future<dynamic> _makeRequest(Future<http.Response> Function() request) async {
    try {
      final response = await request();
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  @override
  Future<List<Player>> getAllPlayers() async {
    final jsonData = await _makeRequest(() => http.get(Uri.parse("$apiUrl/api/players")));
    return (jsonData as List).map((json) => Player.fromJson(json)).toList();
  }

  @override
  Future<void> addPlayerById(String id) async {
    await _makeRequest(() => http.post(
      Uri.parse("$apiUrl/api/players"),
      headers: headers,
      body: json.encode({"id": id}),
    ));
  }

  @override
  Future<void> addPlayerWinById(String id) async {
    String encodedId = Uri.encodeComponent(id);
    await _makeRequest(() => http.post(
      Uri.parse("$apiUrl/api/players/$encodedId/score/win"),
      headers: headers,
    ));
  }

  @override
  Future<Player> getPlayerById(String id) async {
    String encodedId = Uri.encodeComponent(id);
    final jsonData = await _makeRequest(() => http.get(Uri.parse("$apiUrl/api/players/$encodedId")));
    return Player.fromJson(jsonData);
  }
}
