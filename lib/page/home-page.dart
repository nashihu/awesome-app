import 'package:awesome_app/controller/curated-controller.dart';
import 'package:awesome_app/controller/view-mode-controller.dart';
import 'package:awesome_app/page/detail-page.dart';
import 'package:awesome_app/util/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../util/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late ViewModeController _viewModeController;
  late CuratedController _curatedController;

  @override
  void initState() {
    _viewModeController = Get.find();
    _curatedController = Get.find();
    _curatedController.getCuratedItems(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _sliverHeader(),
          Obx(() => _curatedController.isDataReceived()
              ? _viewModeController.isListMode()
              ? _listView()
              : _gridView()
              : _handleDataOnHold())
        ],
      ),
    );
  }

  _sliverHeader() {
    return SliverAppBar(
      pinned: true,
      title: Text("Awesome App"),
      expandedHeight: 250,
      actions: [
        IconButton(
            onPressed: () {
              _viewModeController.toggleView(false);
            },
            icon: Obx(() => _gridIcon(_viewModeController.isListMode()))),
        IconButton(
            onPressed: () {
              _viewModeController.toggleView(true);
            },
            icon: Obx(() => _listIcon(_viewModeController.isListMode()))),
        SizedBox(
          width: 10,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(RANDOM_IMAGE_URL_HEADER),
      ),
    );
  }

  _listView() {
    return Obx(() => SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return _containerItem(
              index,
              Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                              margin: EdgeInsets.only(right: 20),
                              child: Image.network(_curatedController.curatedValue()
                                  .photos[index]
                                  .src
                                  .landscape))),
                      Expanded(
                          flex: 2,
                          child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            style: TextStyles.medium,
                          ))
                    ],
                  )));
        },
        childCount: _curatedController.curatedValue().photos.length,
      ),
    ));
  }

  _gridView() {
    return Obx(() {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return _containerItem(
                index,
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 4,
                          child: Container(
                              child: Image.network(
                                  _curatedController.curatedValue().photos[index].src.medium))),
                      Expanded(
                          flex: 1,
                          child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            style: TextStyles.medium,
                            textAlign: TextAlign.center,
                          ))
                    ],
                  ),
                ));
          },
          childCount: _curatedController.curatedValue().photos.length,
        ),
      );
    });
  }

  _containerItem(int index, Widget child) {
    var imgUrl = _curatedController.curatedValue().photos[index].src.medium;
    return InkWell(
      child: child,
      onTap: () {
        var target = DetailPage(imgUrl: imgUrl);
        Get.to(() => target);
      },
    );
  }

  _gridIcon(bool isListActive) {
    return Icon(Icons.grid_view,
        color: isListActive ? Colors.grey : Colors.black);
  }

  _listIcon(bool isListActive) {
    return Icon(Icons.view_list,
        color: isListActive ? Colors.black : Colors.grey);
  }

  Widget _handleDataOnHold() {
    if (_curatedController.isFetching()) {
      return SliverGrid.count(
        crossAxisCount: 1,
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.width * 0.3,
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      );
    }

    return SliverGrid.count(
      crossAxisCount: 1,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Center(
            child: Text(_curatedController.errorMessage()),
          ),
        ),
      ],
    );
  }
}
