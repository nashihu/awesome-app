import 'package:get/get.dart';

class ViewModeController extends GetxController {
  var listMode = true.obs;
  toggleView(bool value) => listMode.value = value;
}