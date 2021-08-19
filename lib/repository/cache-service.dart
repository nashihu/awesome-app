import 'dart:convert';

import 'package:awesome_app/model/curated.dart';
import 'package:awesome_app/repository/local-preference.dart';
import 'package:get/get.dart';

class CacheService {

  late LocalPreference _pref;

  CacheService() {
    _pref = Get.find();
  }

  Future<Curated> getCurated(String url) async {
    String cached = await _pref.getString(url) ?? "";
    return Curated.fromJson(jsonDecode(cached));
  }

}