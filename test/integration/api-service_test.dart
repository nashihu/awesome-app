import 'package:awesome_app/repository/api-service.dart';
import 'package:awesome_app/repository/local-preference.dart';
import 'package:awesome_app/util/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../util/constants.dart';
import '../util/mock-helper.mocks.dart';

void main() {
  print("running api service test");
  test("test api service", () async {
    Get.put(LocalPreference());

    final url = "https://api.pexels.com/v1/curated?page=1&per_page=10";
    final uri = Uri.parse(url);
    final _headers = {"Authorization": API_KEY};

    final client = MockClient();
    when(client.get(uri, headers: _headers))
        .thenAnswer((_) async => http.Response('{"photos": [${Const.singlePhoto}]}', 200));

    final apiService = ApiService();

    final curated = await apiService.getCurated(client, url);
    expect(0, curated.page);
    expect(1, curated.photos.length);


  });
}