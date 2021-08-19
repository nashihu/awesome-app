
import 'package:awesome_app/controller/curated-controller.dart';
import 'package:awesome_app/model/curated.dart';
import 'package:awesome_app/repository/api-service.dart';
import 'package:awesome_app/repository/cache-service.dart';
import 'package:awesome_app/repository/local-preference.dart';
import 'package:awesome_app/repository/repository.dart';
import 'package:awesome_app/util/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../util/constants.dart';
import '../util/mock-helper.mocks.dart';

void main() {
  print("running curated controller test");
  Get.put(LocalPreference());
  Get.put(CacheService());
  Get.put(ApiService());
  Get.put(PagingController<int,Photos>(firstPageKey: 0));

  var _http = MockClient();
  var repo = Repository(_http);

  Get.put(repo);
  var controller = CuratedController();

  var baseUrl = "https://api.pexels.com/v1";
  String path = "$baseUrl/curated?page=1&per_page=10";
  Uri uri = Uri.parse(path);
  var _headers = {"Authorization": API_KEY};

  group("integration test curated controller", () {
    test("initial object attribute test", () {

      expect(true, controller.isFetching());
      expect("", controller.errorMessage());

    });

    test("test first page", () async {
      when(_http.get(uri, headers: _headers))
          .thenAnswer((_) async => http.Response('{"photos": [${Const.singlePhoto}]}', 200));

      await controller.getPhotos(0,perPage: 10);

      expect(false, controller.isFetching());
      expect(Const.landscapeUrl, controller.getRandomPhotoHeaderUrl());

    });

    test("test reset state", () async {

      controller.resetState();

      expect(true, controller.isFetching());
      expect("", controller.errorMessage());
      expect(RANDOM_IMAGE_URL_HEADER, controller.getRandomPhotoHeaderUrl());

    });

    test("test exception", () async {
      when(_http.get(uri, headers: _headers))
          .thenThrow(Exception("404 Not Found"));

      await controller.getPhotos(1,perPage: 10);

      expect("Exception: 404 Not Found", controller.errorMessage());

    });

  });
}