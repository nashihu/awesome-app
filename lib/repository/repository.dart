import 'package:awesome_app/model/curated.dart';
import 'package:awesome_app/repository/api-service.dart';
import 'package:awesome_app/repository/cache-service.dart';
import 'package:awesome_app/util/static-helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Repository {

  var baseUrl = "https://api.pexels.com/v1";

  late http.Client _http;
  late CacheService _cacheService;
  late ApiService _apiService;

  Repository(http.Client client) {
    _http = client;
    _apiService = Get.find();
    _cacheService = Get.find();
  }

  Future<Curated> getCurated(int pageKey, int perPage) async {
    String path = "$baseUrl/curated?page=$pageKey&per_page=$perPage";
    print("url $path");
    if(await Helpers.hasNetworkConnection()) {
      return _apiService.getCurated(_http, path);
    } else {
      return _cacheService.getCurated(path);
    }

  }

}