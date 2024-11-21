import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import './bottom_nav_view.dart';
import '../repositories/leaderboard/leaderboard_repository.dart';
import '../models/player.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final LeaderboardRepository leaderboardRepository = GetIt.instance<LeaderboardRepository>();
  late Future<List<Player>> players;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // Fetch players data from the repository
  void fetchUsers() {
    players = leaderboardRepository.getAllPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Path to your image asset
            fit: BoxFit.cover, // Makes the image cover the entire screen
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.75,
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 24.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: FutureBuilder<List<Player>>(
                  future: players, // Use the players future
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No players found'));
                    }

                    // Sort players by score in descending order
                    final sortedPlayers = snapshot.data!..sort((a, b) => b.score.compareTo(a.score));

                    return ListView.builder(
                      itemCount: sortedPlayers.length,
                      itemBuilder: (context, index) {
                        final player = sortedPlayers[index];
                        final rank = index + 1; // Ranking starts from 1

                        return ListTile(
                          leading: Text(
                            '#$rank',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: Text(
                            player.name,
                            style: const TextStyle(fontSize: 18),
                          ),
                          trailing: Text(
                            'Score: ${player.score}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }
}
/*
class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final LeaderboardRepository leaderboardRepository = GetIt.instance<LeaderboardRepository>();
  late Future<List<Player>> players;
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() {
    players = leaderboardRepository.getAllPlayers();
  }


  Future<void> fetchUsers_old() async {
    final url = Uri.parse(
        'https://dart-leaderboard-rdchfzm4oa-ey.a.run.app/api/players');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse JSON response
      final List<dynamic> data = json.decode(response.body);

      // Convert to list of maps with sorting
      setState(() {
        users = data
            .map((item) => {'id': item['id'], 'score': item['score']})
            .toList();

        // Sort the list by score in descending order
        users.sort((a, b) => b['score'].compareTo(a['score']));
      });
    } else {
      print('Failed to load users');
    }
  }// */
/*

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
            AssetImage('assets/background.jpg'), // Path to your image asset
            fit: BoxFit.cover, // Makes the image cover the entire screen
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Leaderboard",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.75,
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 24.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final rank = index + 1; // Ranking starts from 1

                    return ListTile(
                      leading: Text(
                        '#$rank',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      title: Text(
                        user['id'],
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: Text(
                        'Score: ${user['score']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }
}// */