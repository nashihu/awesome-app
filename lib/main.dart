
import 'package:awesome_app/model/curated.dart';
import 'package:awesome_app/page/home-page.dart';
import 'package:awesome_app/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'controller/curated-controller.dart';
import 'controller/view-mode-controller.dart';
import 'package:http/http.dart' as http;

const awesomeApp = GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Awesome App",
    home: HomePage());

void injectObjects() {
  Get.lazyPut(() => http.Client());
  Get.lazyPut(() => (Repository(Get.find())));
  Get.lazyPut(() => (ViewModeController()));
  Get.lazyPut(() => (PagingController<int,Photos>(firstPageKey: 0)));
  Get.lazyPut(() => (CuratedController()));
}

void main() {
  injectObjects();
  runApp(awesomeApp);
}