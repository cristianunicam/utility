import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:utility/util/response_structure.dart';

//Url 10.0.2.2 is used by AVD as loopback url
String url = 'http://10.0.2.2:3000/path/';

Future<Response> fetchData(String id) async {
  final response = await http.get(url + id);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Response.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load gpx');
  }
}
