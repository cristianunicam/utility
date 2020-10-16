class ResponseList {
  final List<dynamic> routeList;

  ResponseList({this.routeList});

  factory ResponseList.fromJson(List<dynamic> json) {
    return ResponseList(
      routeList: json,
    );
  }
}
