import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(TicTacToeApp());

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: "home",
        path: '/',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        name: "game",
        path: '/game',
        builder: (context, state) => GameScreen(),
      ),
      GoRoute(
        name: "leaderboard",
        path: '/leaderboard',
        builder: (context, state) => LeaderboardScreen(),
      ),
      GoRoute(
        name: "settings",
        path: '/settings',
        builder: (context, state) => SettingsScreen(),
      ),
    ],
  );
}

class HomeScreen extends StatelessWidget {
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter Player Names",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: player1Controller,
                decoration: const InputDecoration(
                  labelText: "Player 1",
                  prefixIcon: Icon(Icons.close, color: Colors.blue),
                ),
              ),
              TextField(
                controller: player2Controller,
                decoration: const InputDecoration(
                  labelText: "Player 2",
                  prefixIcon: Icon(Icons.circle_outlined, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      player1Controller.clear();
                      player2Controller.clear();
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (player1Controller.text.isNotEmpty &&
                          player2Controller.text.isNotEmpty) {
                        context.go('/game', extra: {
                          'player1': player1Controller.text,
                          'player2': player2Controller.text,
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter both names")),
                        );
                      }
                    },
                    child: const Text("Start Game"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> gridState = ['', '', '', '', '', '', '', '', ''];
  bool isXTurn = true; // To track whose turn it is
  String player1 = "Player 1"; // You can update these names as needed
  String player2 = "Player 2";
  String winner = ''; // Variable to store the winner ("X" or "O")
  List<int> winningCombination = []; // To store the indices of the winning combination

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              winner.isEmpty
                  ? '${isXTurn ? player1 : player2}\'s Turn'
                  : winner == "Draw"
                  ? "Draw!"
                  : '${winner == 'X' ? player1 : player2} Wins!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 64), // Spacer between text and grid
            Container(
              height: MediaQuery.of(context).size.width * 0.9,
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,  // 9 cells in the grid
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  bool isWinningCell = winningCombination.contains(index);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (gridState[index] == '' && winner.isEmpty) {
                          // Update the cell if it's empty
                          gridState[index] = isXTurn ? 'X' : 'O';
                          isXTurn = !isXTurn; // Toggle the turn
                          checkWinner();
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: row == 0 ? BorderSide.none : const BorderSide(color: Colors.black), // No top border for the first row
                          left: col == 0 ? BorderSide.none : const BorderSide(color: Colors.black), // No left border for the first column
                          right: col == 2 ? BorderSide.none : const BorderSide(color: Colors.black), // No right border for the last column
                          bottom: row == 2 ? BorderSide.none : const BorderSide(color: Colors.black), // No bottom border for the last row
                        ),
                        //color: isWinningCell ? Colors.red : Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          gridState[index],
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: isWinningCell ? Colors.red : Colors.black,),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 64),
            Text("This is where the ending Buttons will go....")
          ]
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }

  // Method to check if there is a winner
  void checkWinner() {
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

class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("Leaderboard")),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("Settings")),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }
}

class AppBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/leaderboard');
            break;
          case 2:
            context.go('/settings');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      currentIndex: _getSelectedIndex(context),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouter.of(context).location;
    if (location == '/') {
      return 0;
    } else if (location == '/leaderboard') {
      return 1;
    } else if (location == '/settings') {
      return 2;
    }
    return 0;
  }
}