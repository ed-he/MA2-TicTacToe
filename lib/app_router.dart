import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'views/home_view.dart';
import 'views/leaderboard_view.dart';
import 'views/settings_view.dart';
import 'views/game_view.dart';
import 'views/bottom_nav_view.dart';


class AppRouter {
  /*
  static final GlobalKey<NavigatorState> _navigatorKeyDefault = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _navigatorKeyHome = GlobalKey<NavigatorState>(debugLabel: 'Home');
  static final GlobalKey<NavigatorState> _navigatorKeyLeaderboard = GlobalKey<NavigatorState>(debugLabel: 'Leaderboard');
  static final GlobalKey<NavigatorState> _navigatorKeySettings = GlobalKey<NavigatorState>(debugLabel: 'Settings');
  static final GlobalKey<NavigatorState> _navigatorKeyGame = GlobalKey<NavigatorState>(debugLabel: 'Game');// */

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: "home",
        path: '/',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        name: "game",
        //path: '/game',
        //builder: (context, state) => GameScreen(),
        path: '/game',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>? ?? {};
          return GameScreen(
            player1: extra['player1'] ?? "Player 1",
            player2: extra['player2'] ?? "Player 2",
          );
        },
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