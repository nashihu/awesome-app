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

  Future<Curated> getCurated(int page, int perPage) async {
    String path = "$baseUrl/curated?page=$page&per_page=$perPage";
    Uri uri = Uri.parse(path);
    var response = await _http.get(uri, headers: _headers);
    if(response.statusCode == 200) {
      return Curated.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }

}