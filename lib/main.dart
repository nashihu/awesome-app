
import 'package:awesome_app/page/home-page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const awesomeApp = GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Awesome App",
    home: HomePage());

void main() {
  runApp(awesomeApp);
}