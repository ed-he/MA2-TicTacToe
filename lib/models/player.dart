class Player {
  final String name;
  final int score;

  Player({required this.name, required this.score});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['id'] ?? 'n.a.',
      score: json['score'] ?? 0,
    );
  }

}
