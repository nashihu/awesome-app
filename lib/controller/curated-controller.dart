import 'dart:math';

import 'package:awesome_app/model/curated.dart';
import 'package:awesome_app/repository/repository.dart';
import 'package:awesome_app/util/constants.dart';
import 'package:flutter/material.dart';
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
        addPhotos(newItems, page+1);
      }

    } catch (e,x) {
      setErrorMessage(e.toString());
      _pagingController.error = e.toString();
      e.printError();
      x.printError();
    }

    _isLoading.value = false;

  }

  @visibleForTesting
  void setErrorMessage(String msg) {
    _errorMessage.value = msg;
    _isLoading.value = false;
  }

  @visibleForTesting
  void addPhotos(List<Photos> newItems, int nextPage) {
    _isLoading.value = false;
    _pagingController.appendPage(newItems, nextPage);
  }

  void resetState() {
    _errorMessage.value = "";
    _isLoading.value = true;
    _pagingController.refresh();
  }
  
  String getRandomPhotoHeaderUrl() {
    if(_pagingController.itemList == null) {
      return RANDOM_IMAGE_URL_HEADER;
    }

    int size = _pagingController.itemList!.length;
    int randomIdx = Random().nextInt(size);
    
    return _pagingController.itemList![randomIdx].src.landscape;
  }

  String errorMessage() => _errorMessage.value;

  bool isFetching() => _isLoading.value;

  bool isDataReceived() => !isFetching() && errorMessage().isEmpty;
}