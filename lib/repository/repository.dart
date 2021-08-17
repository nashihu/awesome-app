import 'package:awesome_app/model/curated.dart';
import 'package:awesome_app/util/constants.dart';
import 'package:get/get.dart';

class Repository extends GetConnect {

  Map<String, String> headers = {};

  @override
  void onInit() {
    httpClient.baseUrl = "https://api.pexels.com/v1";
    headers = {"Authorization": API_KEY};
    super.onInit();
  }

  Future<Curated> getCurated(int page, int perPage) async {
    String path = "/curated?page=$page&per_page=$perPage";
    var response = await get(path, headers: headers);
    if(response.statusCode == 200) {
      return Curated.fromJson(response.body);
    } else {
      throw Exception(response.statusCode);
    }
  }

}