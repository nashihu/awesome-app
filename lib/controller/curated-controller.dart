import 'package:awesome_app/model/curated.dart';
import 'package:awesome_app/repository/repository.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CuratedController extends GetxController {
  var _isLoading = true.obs;
  var _errorMessage = "".obs;
  static const _pageSize = 20;

  late Repository _repository;
  late PagingController<int, Photos> _pagingController;

  CuratedController() {
    _repository = Get.find();
    _pagingController = Get.find();
  }

  Future<void> getPhotos(int page, {int perPage = _pageSize}) async {
    Curated? _value;
    if(page==0) {
      page = 1;
    }

    try {
      _value = await _repository.getCurated(page, perPage);
      var newItems = _value.photos;

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        _pagingController.appendPage(newItems, page+1);
      }

    } catch (e,x) {
      _errorMessage.value = e.toString();
      _pagingController.error = e.toString();
      e.printError();
      x.printError();
    }

    _isLoading.value = false;

  }

  String errorMessage() => _errorMessage.value;

  bool isFetching() => _isLoading.value;

  bool isDataReceived() => !isFetching() && errorMessage().isEmpty;
}