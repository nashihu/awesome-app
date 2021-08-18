import 'package:get/get.dart';

class ViewModeController extends GetxController {
  var _listMode = true.obs;

  void toggleView(bool value) => _listMode.value = value;

  bool isListMode() => _listMode.value;
}