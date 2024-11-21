import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import './bottom_nav_view.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tic-Tac-Toe')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
            AssetImage('assets/background.jpg'), // Path to your image asset
            fit: BoxFit.cover, // Makes the image cover the entire screen
          ),
        ),
        child: Center(
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
                    Spacer(),
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
                            const SnackBar(
                                content: Text("Please enter both names")),
                          );
                        }
                      },
                      child: const Text("Start Game"),
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }
}
