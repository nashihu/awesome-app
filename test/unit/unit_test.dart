import 'dart:convert';

import 'package:awesome_app/controller/view-mode-controller.dart';
import 'package:awesome_app/model/curated.dart';
import 'package:awesome_app/util/static-helper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../util/constants.dart';

void main() {
  print("running unit test");
  test("unit test view mode controller", () {
    var controller = ViewModeController();

    controller.toggleView(false);
    expect(false, controller.isListMode());

    controller.toggleView(true);
    expect(true, controller.isListMode());
  });

  test("test method isBrightColor", () async {
    expect(true, Helpers.isBrightColor("#FF4499"));
    expect(false, Helpers.isBrightColor("#004499"));
  });

  test("test model fromJson", () {
    final curatedFirstPage = Curated.fromJson(jsonDecode(Const.firstPage));
    final curr = Curated();
    curr.page = 1;
    expect(curr.page, curatedFirstPage.page);
    final curatedSinglePhoto = Curated.fromJson(jsonDecode(Const.pageSinglePhoto));
    curr.photos = [Photos.fromJson(jsonDecode(Const.singlePhoto))];
    curr.perPage = 1;
    expect(curr.photos.toString(), curatedSinglePhoto.photos.toString());
    expect(curr.perPage, curatedSinglePhoto.perPage);
  });

}