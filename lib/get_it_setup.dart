import 'package:get_it/get_it.dart';
import 'package:flutter_xoxo/repositories/leaderboard/leaderboard_repository_class.dart';
import 'repositories/leaderboard/leaderboard_repository.dart';

final getIt = GetIt.instance;

void setup() {
  GetIt.instance.registerSingleton<LeaderboardRepository>(LeaderboardRepositoryClass());
}