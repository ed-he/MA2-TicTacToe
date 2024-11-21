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
                width: MediaQuery.of(context).size.width * 0.7,
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
                        Color rankColor = getRankColor(rank);

                        return Column(
                          children: [
                            ListTile(
                              leading: Text(
                                '#$rank',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: rankColor,
                                ),
                              ),
                              title: Text(
                                player.name,
                                style: const TextStyle(fontSize: 18),
                              ),
                              subtitle: Text(
                                'Score: ${player.score}',
                                style: const TextStyle(fontSize: 14),  // Smaller font for score
                              ),
                            ),
                            const Divider(
                              color: Colors.black12,  // Thin line after each user
                              thickness: 1,  // Adjust thickness if needed
                            ),
                          ],
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

  Color getRankColor(int rank) {
    if (rank == 1) {
      return Color(0xFFFFD700);
    } else if (rank == 2) {
      return Color(0xFFC0C0C0);
    } else if (rank == 3) {
      return Color(0xFFCD7F32);
    }
    return Theme.of(context).textTheme.bodySmall?.color ?? Colors.black;
  }
}