
import 'package:awesome_app/controller/curated-controller.dart';
import 'package:awesome_app/model/curated.dart';
import 'package:awesome_app/repository/repository.dart';
import 'package:awesome_app/util/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'integration-test.mocks.dart';
import 'integration/constants.dart';

@GenerateMocks([http.Client])
void main() {
  test("integration test curated controller", () async {
    var _http = MockClient();
    var repo = Repository(_http);
    Get.put(repo);
    Get.put(PagingController<int,Photos>(firstPageKey: 0));
    var controller = CuratedController();

    var baseUrl = "https://api.pexels.com/v1";
    String path = "$baseUrl/curated?page=1&per_page=10";
    Uri uri = Uri.parse(path);
    var _headers = {"Authorization": API_KEY};

    when(_http.get(uri, headers: _headers))
        .thenAnswer((_) async => http.Response('{"photos": [${Const.singlePhoto}]}', 200));

    await controller.getPhotos(1,perPage: 10);
    // expect(1, controller.curatedValue().photos.length);

    when(_http.get(uri, headers: _headers))
        .thenAnswer((_) async => http.Response('{}', 200));

    await controller.getPhotos(1,perPage: 10);
    // expect(1, controller.curatedValue().photos.length);

    when(_http.get(uri, headers: _headers))
        .thenAnswer((_) async => http.Response('{"photos": [${Const.singlePhoto}]}', 200));

    await controller.getPhotos(1,perPage: 10);
    // expect(2, controller.curatedValue().photos.length);

  });
}