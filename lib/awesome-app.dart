
import 'package:awesome_app/home-page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Awesome App",
      home: HomePage())
  );
}