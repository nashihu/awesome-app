import 'dart:convert';

import 'package:awesome_app/model/curated.dart';
import 'package:awesome_app/util/constants.dart';
import 'package:http/http.dart' as http;

class Repository {

  var baseUrl = "https://api.pexels.com/v1";
  var _headers = {"Authorization": API_KEY};

  late http.Client _http;

  Repository(http.Client client) {
    _http = client;
  }

  Future<Curated> getCurated(int pageKey, int perPage) async {
    int page = 1;
    if(pageKey != 1) {
      page = ((pageKey - 1)~/perPage)+1;
    }
    // print("next pageKey: $pageKey next page $page");
    String path = "$baseUrl/curated?page=$page&per_page=$perPage";
    print("url: $path");
    Uri uri = Uri.parse(path);
    var response = await _http.get(uri, headers: _headers);
    // print("got: ${response.body}");
    if(response.statusCode == 200) {
      return Curated.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }

}