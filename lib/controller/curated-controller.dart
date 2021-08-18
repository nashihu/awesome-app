import 'package:awesome_app/model/curated.dart';
import 'package:awesome_app/repository/repository.dart';
import 'package:get/get.dart';

class CuratedController extends GetxController {
  var _listItem = Curated().obs;
  var _isLoading = true.obs;
  var _errorMessage = "".obs;

  late Repository _repository;

  CuratedController() {
    _repository = Get.find();
  }

  Future<void> getCuratedItems(int page, {int perPage = 10}) async {
    Curated? _value;

    try {
      _value = await _repository.getCurated(page, perPage);
    } catch (e,x) {
      _errorMessage.value = x.toString();
      e.printError();
      x.printError();
    }

    _isLoading.value = false;

    if(_value != null) {
      _listItem.value = _value;
    }

  }

  Curated curatedValue() => _listItem.value;

  String errorMessage() => _errorMessage.value;

  bool isFetching() => _isLoading.value;

  bool isDataReceived() => !isFetching() && errorMessage().isEmpty;
}