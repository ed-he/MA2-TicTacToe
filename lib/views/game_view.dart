import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import './bottom_nav_view.dart';
import '../repositories/leaderboard/leaderboard_repository.dart';
import '../models/player.dart';

class GameScreen extends StatefulWidget {
  String player1;
  String player2;

  GameScreen({required this.player1, required this.player2});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final LeaderboardRepository leaderboardRepository = GetIt.instance<LeaderboardRepository>();
  late Future<void> initializationFuture;
  List<String> gridState = ['', '', '', '', '', '', '', '', ''];
  bool isXTurn = true; // To track whose turn it is
  String winner = ''; // Variable to store the winner ("X" or "O")
  List<int> winningCombination = []; // To store the indices of the winning combination
  List<Map<String, dynamic>> users = [];
  late Future<Player> gotPlayer1;
  late Future<Player> gotPlayer2;

  @override
  void initState() {
    super.initState();
    initializationFuture = initializePlayers();
  }

  Future<void> initializePlayers() async {
    await checkAndAddPlayer(widget.player1);
    await checkAndAddPlayer(widget.player2);
  }

  Future<void> checkAndAddPlayer(String playerName) async {
    try {
      // Check if the player exists in the database
      await leaderboardRepository.getPlayerById(playerName);
    } catch (e) {
      // If player doesn't exist, add them to the database
      await leaderboardRepository.addPlayerById(playerName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error initializing players: ${snapshot.error}")),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Tic-Tac-Toe')),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    winner.isEmpty
                        ? '${isXTurn ? widget.player1 : widget.player2}\'s Turn'
                        : winner == "Draw"
                        ? "Draw!"
                        : '${winner == 'X' ? widget.player1 : widget.player2} Wins!',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  buildGrid(),
                  const SizedBox(height: 25),
                  if (winner.isNotEmpty) // Check if a winner has been declared
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              // Reset the game state to play again
                              gridState = ['', '', '', '', '', '', '', '', ''];
                              isXTurn = true;
                              winner = '';
                              winningCombination = [];
                            });
                          },
                          child: const Text("Play Again"),
                        ),
                        const SizedBox(height: 16), // Add spacing between the buttons
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the leaderboard or scores screen
                            context.go('/leaderboard'); // Replace with your leaderboard route
                          },
                          child: const Text("View Scores"),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
          bottomNavigationBar: AppBottomNavigationBar(),
        );
      },
    );
  }

  Widget buildGrid() {
    final size = MediaQuery.of(context).size;
    final double gridSize = size.width < size.height
        ? size.width * 0.8
        : size.height * 0.8;

    return Container(
      height: gridSize, // MediaQuery.of(context).size.width * 0.9,
      width: gridSize, // MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          int row = index ~/ 3;
          int col = index % 3;
          bool isWinningCell = winningCombination.contains(index);

          return GestureDetector(
            onTap: () {
              setState(() {
                if (gridState[index] == '' && winner.isEmpty) {
                  gridState[index] = isXTurn ? 'X' : 'O';
                  isXTurn = !isXTurn;
                  checkWinner();
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: row == 0
                      ? BorderSide.none
                      : const BorderSide(color: Colors.black),
                  left: col == 0
                      ? BorderSide.none
                      : const BorderSide(color: Colors.black),
                  right: col == 2
                      ? BorderSide.none
                      : const BorderSide(color: Colors.black),
                  bottom: row == 2
                      ? BorderSide.none
                      : const BorderSide(color: Colors.black),
                ),
              ),
              child: Center(
                child: Text(
                  gridState[index],
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isWinningCell ? Colors.red : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void checkWinner() async {
    // Define winning combinations (index positions for rows, columns, and diagonals)
    List<List<int>> winningCombinations = [
      [0, 1, 2], // Top row
      [3, 4, 5], // Middle row
      [6, 7, 8], // Bottom row
      [0, 3, 6], // Left column
      [1, 4, 7], // Middle column
      [2, 5, 8], // Right column
      [0, 4, 8], // Diagonal top-left to bottom-right
      [2, 4, 6], // Diagonal top-right to bottom-left
    ];

    // Check each winning combination
    for (var combination in winningCombinations) {
      String a = gridState[combination[0]];
      String b = gridState[combination[1]];
      String c = gridState[combination[2]];

      if (a == b && b == c && a != '') {
        // We have a winner!
        setState(() {
          winner = a; // Set the winner as "X" or "O"
          winningCombination = combination;
        });

        // Determine the winning player based on the winner ('X' or 'O')
        String winningPlayer = (winner == 'X') ? widget.player1 : widget.player2;

        // Increment the score of the winning player
        try {
          await leaderboardRepository.addPlayerWinById(winningPlayer);
          print("Score updated successfully for $winningPlayer");
        } catch (e) {
          print("Error updating score for $winningPlayer: $e");
        }

        return;
      }
    }

    // Check if the grid is full (draw)
    if (!gridState.contains('')) {
      setState(() {
        winner = 'Draw'; // Mark the game as a draw
      });
    }
  }
}