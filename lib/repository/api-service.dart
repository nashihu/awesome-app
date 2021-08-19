import 'dart:convert';

import 'package:awesome_app/model/curated.dart';
import 'package:awesome_app/repository/local-preference.dart';
import 'package:awesome_app/util/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService {

  static Map<String,String> _headers = {"Authorization": API_KEY};

  late LocalPreference _pref;

  ApiService() {
    _pref = Get.find();
  }

  Future<Curated> getCurated(http.Client _http, String url) async {
    Uri uri = Uri.parse(url);
    var response = await _http.get(uri, headers: _headers);
    _pref.setString(url, response.body);
    if(response.statusCode == 200) {
      return Curated.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }
}