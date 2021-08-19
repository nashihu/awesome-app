import 'package:awesome_app/controller/view-mode-controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("unit test view mode controller", () {
    var controller = ViewModeController();

    controller.toggleView(false);
    expect(false, controller.isListMode());

    controller.toggleView(true);
    expect(true, controller.isListMode());

  });

}