import 'package:awesome_app/repository/cache-service.dart';
import 'package:awesome_app/repository/local-preference.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  print("running cache service test");
  test("test cache sevice", () async {
    final pref = LocalPreference();
    await Future.delayed(Duration(seconds: 3));
    Get.put(pref);
    final cacheService = CacheService();

    String url = "https://api.pexels.com/v1/curated?page=1&per_page=10";
    await pref.setString(url, "{}"); // no idea where to store any value yet
    expect(() => cacheService.getCurated(url), throwsA(isA<Exception>()));

  });
}