import '../../models/player.dart';

abstract class LeaderboardRepository {
  Future<List<Player>> getAllPlayers();

  Future<Player> getPlayerById(String id);

  Future<void> addPlayerById(String id);

  Future<void> addPlayerWinById(String id);
}