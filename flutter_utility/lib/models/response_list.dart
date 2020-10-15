class ResponseList {
  final List<dynamic> id;

  ResponseList({this.id});

  factory ResponseList.fromJson(List<dynamic> json) {
    List<dynamic> routeList = [];

    routeList = json;
    //json.forEach((element) => routeList.add(element.toString()));

    return ResponseList(
      id: routeList,
    );
  }
}
