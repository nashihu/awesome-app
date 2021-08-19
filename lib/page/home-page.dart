import 'package:awesome_app/controller/curated-controller.dart';
import 'package:awesome_app/controller/view-mode-controller.dart';
import 'package:awesome_app/model/curated.dart';
import 'package:awesome_app/page/detail-page.dart';
import 'package:awesome_app/util/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../util/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ViewModeController _viewModeController;
  late CuratedController _photosController;

  late PagingController<int, Photos> _pagingController;

  @override
  void initState() {
    _pagingController = Get.find();
    _viewModeController = Get.find();
    _photosController = Get.find();
    _photosController.getPhotos(0);
    _pagingController.addPageRequestListener((pageKey) {
      _photosController.getPhotos(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
              () => _pagingController.refresh(),
        ),
        child: CustomScrollView(
          slivers: [
            _sliverHeader(),
            Obx(() => _photosController.isDataReceived()
                ? _viewModeController.isListMode()
                    ? _listView()
                    : _gridView()
                : _handleDataOnHold())
          ],
        ),
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
    return PagedSliverList<int, Photos>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Photos>(
        itemBuilder: (context, item, index) => _containerItem(
            item,
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
                            child: Image.network(item.src.landscape))),
                    Expanded(
                        flex: 2,
                        child: Text(
                          "Photo by ${item.photographer}",
                          style: TextStyles.medium,
                        ))
                  ],
                ))),
      ),
    );
  }

  _gridView() {
    return PagedSliverGrid<int, Photos>(
      pagingController: _pagingController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 0.8,
      ),
      builderDelegate: PagedChildBuilderDelegate<Photos>(
        itemBuilder: (context, item, index) => _containerItem(
            item,
            Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 4,
                      child: Container(
                        child: Image.network(item.src.medium),
                      )),
                  Expanded(
                      flex: 1,
                      child: Text(
                        "Photo by ${item.photographer}",
                        style: TextStyles.medium,
                        textAlign: TextAlign.center,
                      ))
                ],
              ),
            )),
      ),
    );
  }

  _containerItem(Photos photo, Widget child) {
    return InkWell(
      child: child,
      onTap: () {
        var target = DetailPage(photo);
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
    if (_photosController.isFetching()) {
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
            child: Text(_photosController.errorMessage()),
          ),
        ),
      ],
    );
  }
}
