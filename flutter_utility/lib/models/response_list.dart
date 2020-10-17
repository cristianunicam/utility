class ResponseList {
  //final List<dynamic> routeList;
  final String id;
  final String difficulty;

  ResponseList({
    this.id,
    this.difficulty,
  });

  factory ResponseList.fromJson(Map<String, dynamic> json) {
    return ResponseList(
      id: json['id'],
      difficulty: json['difficulty'],
    );
  }
}
