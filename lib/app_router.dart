import 'package:flutter/material.dart';
import 'package:flutter_xoxo/views/bottom_nav_view.dart';
import 'package:go_router/go_router.dart';
import 'views/home_view.dart';
import 'views/leaderboard_view.dart';
import 'views/settings_view.dart';
import 'views/game_view.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: _rootNavigatorKey,
        builder: (context, state, child) {
          // This ensures the AppBottomNavigationBar is always displayed
          return Scaffold(
            body: child,
            bottomNavigationBar: AppBottomNavigationBar(),
          );
        },
        routes: [
          GoRoute(
            name: "home",
            path: '/',
            builder: (context, state) => HomeScreen(),
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
      ),
      GoRoute(
        name: "game",
        path: '/game',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>? ?? {};
          return GameScreen(
            player1: extra['player1'] ?? "Player 1",
            player2: extra['player2'] ?? "Player 2",
          );
        },
      ),
    ],
  );
}