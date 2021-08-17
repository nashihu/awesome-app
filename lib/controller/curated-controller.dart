import 'package:awesome_app/model/curated.dart';
import 'package:awesome_app/repository/repository.dart';
import 'package:get/get.dart';

class CuratedController extends GetxController {
  var listItem = Curated().obs;
  var isLoading = true.obs;
  var errorMessage = "".obs;

  Repository? _repository;

  void getCuratedItems(int page, {int perPage = 10}) async {
    if(_repository == null) {
      _repository = Get.put(Repository());
    }

    Curated? _value;

    try {
      _value = await _repository?.getCurated(page, perPage);
    } catch (e,x) {
      errorMessage.value = x.toString();
      e.printError();
      x.printError();
    }

    isLoading.value = false;

    if(_value != null) {
      listItem.value = _value;
    }

  }
}