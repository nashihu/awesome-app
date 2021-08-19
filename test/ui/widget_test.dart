// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:awesome_app/controller/curated-controller.dart';
import 'package:awesome_app/controller/view-mode-controller.dart';
import 'package:awesome_app/main.dart';
import 'package:awesome_app/model/curated.dart';
import 'package:awesome_app/page/detail-page.dart';
import 'package:awesome_app/repository/api-service.dart';
import 'package:awesome_app/repository/cache-service.dart';
import 'package:awesome_app/repository/local-preference.dart';
import 'package:awesome_app/repository/repository.dart';
import 'package:awesome_app/util/constants.dart';
import 'package:awesome_app/util/test-observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../integration/constants.dart';
import '../integration/integration-test.mocks.dart';

void main() {
  Get.put(LocalPreference());
  Get.put(CacheService());
  Get.put(ApiService());
  Get.put(PagingController<int,Photos>(firstPageKey: 0));
  Get.put(ViewModeController());

  var _http = MockClient();
  var repo = Repository(_http);
  Get.put(repo);

  var curatedCtrl = CuratedController();
  Get.put(curatedCtrl);

  var navigatorObserver = TestNavigatorObserver();
  Get.put(navigatorObserver);

  var baseUrl = "https://api.pexels.com/v1";
  String path = "$baseUrl/curated?page=1&per_page=20";
  Uri uri = Uri.parse(path);
  var _headers = {"Authorization": API_KEY};
  var curated = Curated.fromJson(jsonDecode(Const.firstPage));

  testWidgets('test home page', (WidgetTester tester) async {

    when(_http.get(uri, headers: _headers))
        .thenAnswer((_) async => http.Response(Const.firstPage, 200));

    await tester.pumpWidget(awesomeApp);
    expect(find.text('Awesome App'), findsOneWidget);
    expect(find.byKey(Key("Loading List")), findsOneWidget);

    curatedCtrl.addPhotos(curated.photos, 1);
    await tester.pump();
    expect(find.text('Awesome App'), findsOneWidget);
    expect(find.byKey(Key("Loading List")), findsNothing);
    expect(find.byKey(Key("List View")), findsOneWidget);
    expect(find.textContaining("Photo by"), findsNWidgets(4));
    expect(find.textContaining("Yasmin Nabilah"), findsOneWidget);

    curatedCtrl.setErrorMessage("404 Not Found");
    await tester.pump();
    expect(find.text('Awesome App'), findsOneWidget);
    expect(find.byKey(Key("Loading List")), findsNothing);
    expect(find.textContaining("Photo by"), findsNothing);
    expect(find.textContaining("Yasmin Nabilah"), findsNothing);
    expect(find.textContaining("Not Found"), findsOneWidget);

    curatedCtrl.resetState();
    await tester.pump();
    expect(find.text('Awesome App'), findsOneWidget);
    expect(find.byKey(Key("Loading List")), findsOneWidget);
    expect(find.textContaining("Photo by"), findsNothing);
    expect(find.textContaining("Yasmin Nabilah"), findsNothing);

    curatedCtrl.addPhotos(curated.photos, 1);
    await tester.tap(find.byIcon(Icons.grid_view));
    await tester.pump();
    expect(find.byKey(Key("Loading List")), findsNothing);
    expect(find.byKey(Key("List View")), findsNothing);
    expect(find.byKey(Key("Grid View")), findsOneWidget);

    curatedCtrl.resetState();
    curatedCtrl.addPhotos(curated.photos, 1);
    await tester.pump();
    await tester.tap(find.byIcon(Icons.view_list));
    await tester.pump();
    expect(find.byKey(Key("Photo List 0")), findsOneWidget);

    var isPushed = false;
    navigatorObserver.attachPushRouteObserver(
        "/DetailPage", () { isPushed = true; });
    await tester.tap(find.byKey(Key("Photo List 0")));
    expect(isPushed, true);
  });

  testWidgets("test page detail", (WidgetTester tester)  async {
    await tester.pumpWidget(new MaterialApp(home: DetailPage(curated.photos[0])));

    expect(find.text("Photo by Yasmin Nabilah"), findsOneWidget);
    expect(find.byKey(Key("Detail Page")), findsOneWidget);
  });
}
