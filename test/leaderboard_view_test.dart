import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_xoxo/views/leaderboard_view.dart';
import 'package:flutter_xoxo/repositories/leaderboard/leaderboard_repository.dart';
import 'package:flutter_xoxo/models/player.dart';
import 'leaderboard_view_test.mocks.dart';

void main() {
  late MockLeaderboardRepository mockLeaderboardRepository;
  final getIt = GetIt.instance;

  setUp(() {
    mockLeaderboardRepository = MockLeaderboardRepository();
    getIt.registerSingleton<LeaderboardRepository>(mockLeaderboardRepository);
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('Displays loading indicator while data is loading', (WidgetTester tester) async {
    // Simulate the loading state by returning a delayed future
    when(mockLeaderboardRepository.getAllPlayers())
        .thenAnswer((_) => Future.delayed(const Duration(seconds: 5), () => []));

    await tester.pumpWidget(MaterialApp(home: LeaderboardScreen()));

    // Expect CircularProgressIndicator to be shown while waiting for data
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the future to settle
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Check that the loading indicator is no longer visible
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Displays players in leaderboard when data is loaded', (WidgetTester tester) async {
    // Sample players data
    final players = [
      Player(name: 'Charlie', score: 80),
      Player(name: 'Alice', score: 120),
      Player(name: 'Bob', score: 100),
    ];

    // Mock the repository to return the player list
    when(mockLeaderboardRepository.getAllPlayers()).thenAnswer((_) async => players);

    await tester.pumpWidget(MaterialApp(home: LeaderboardScreen()));
    await tester.pumpAndSettle();

    // Check that player names and scores are displayed
    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Charlie'), findsOneWidget);

    final playersItem = tester.widgetList<Text>(find.byType(Text)).map((e) => e.data).whereType<String>().toList();
    expect(playersItem, containsAllInOrder(['Alice', 'Bob', 'Charlie']));
  });

  testWidgets('Handles error when data loading fails', (WidgetTester tester) async {
    // Simulate an error in the repository
    when(mockLeaderboardRepository.getAllPlayers()).thenAnswer((_) async {
      throw Exception('Failed to load players');
    });

    await tester.pumpWidget(MaterialApp(home: LeaderboardScreen()));
    await tester.pumpAndSettle();

    // Expect an error message to be shown
    expect(find.text('Error: Exception: Failed to load players'), findsOneWidget);
  });

}