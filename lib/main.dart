
import 'package:awesome_app/page/home-page.dart';
import 'package:awesome_app/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/curated-controller.dart';
import 'controller/view-mode-controller.dart';
import 'package:http/http.dart' as http;

const awesomeApp = GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Awesome App",
    home: HomePage());

void injectObjects() {
  Get.put(http.Client());
  Get.put(Repository(Get.find()));
  Get.put(ViewModeController());
  Get.put(CuratedController());
}

void main() {
  injectObjects();
  runApp(awesomeApp);
}