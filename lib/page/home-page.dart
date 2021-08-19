import 'dart:async';

import 'package:awesome_app/controller/curated-controller.dart';
import 'package:awesome_app/controller/view-mode-controller.dart';
import 'package:awesome_app/model/curated.dart';
import 'package:awesome_app/page/detail-page.dart';
import 'package:awesome_app/util/static-helper.dart';
import 'package:awesome_app/util/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ViewModeController _viewModeController;
  late CuratedController _photosController;

  late PagingController<int, Photos> _pagingController;

  late StreamSubscription<ConnectivityResult> subscription;

  BuildContext? _context;

  @override
  void initState() {
    _pagingController = Get.find();
    _viewModeController = Get.find();
    _photosController = Get.find();

    _photosController.getPhotos(0);
    _pagingController.addPageRequestListener((pageKey) {
      _photosController.getPhotos(pageKey);
    });

    initConnectivitySubscription();
    super.initState();
  }

  void initConnectivitySubscription() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (_context == null) {
        return;
      }

      var offlineNotifier = getOfflineSnackBar();
      var onlineNotifier = getOnlineSnackBar();

      if (result == ConnectivityResult.none) {
        showSnackBar(offlineNotifier);
        return;
      }

      if (Helpers.isFirstOpen) {
        Helpers.isFirstOpen = false;
        return;
      }

      hideSnackBar();
      showSnackBar(onlineNotifier);
    });
  }

  void showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(_context!).showSnackBar(snackBar);
  }

  void hideSnackBar() {
    ScaffoldMessenger.of(_context!).hideCurrentSnackBar();
  }

  SnackBar getOfflineSnackBar() {
    return SnackBar(
      content: Text("Anda sedang offline"),
      duration: Duration(minutes: 1),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () => hideSnackBar(),
      ),
    );
  }

  SnackBar getOnlineSnackBar() {
    return SnackBar(
      content: Text("Anda kembali online"),
      duration: Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _photosController.resetState(),
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
        background: Obx(() => !_photosController.isDataReceived()
            ? Center(
              child: Container(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                  height: 35,
                  width: 35,
                ),
            )
            : CachedNetworkImage(
                imageUrl: _photosController.getRandomPhotoHeaderUrl(),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                placeholder: (context, url) => Center(
                  child: Container(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    height: 35,
                    width: 35,
                  ),
                ),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              )),
        // background: Image.network(RANDOM_IMAGE_URL_HEADER),
      ),
    );
  }

  _listView() {
    return PagedSliverList<int, Photos>(
      key: Key("List View"),
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Photos>(
        itemBuilder: (context, item, index) => _containerItem(
            Key("Photo List $index"),item,
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
                            height: 70,
                            margin: EdgeInsets.only(right: 20),
                            child: CachedNetworkImage(
                              imageUrl: item.src.landscape,
                              placeholder: (context, url) => Center(
                                child: Container(
                                  child: CircularProgressIndicator(
                                    color: Colors.blue,
                                    strokeWidth: 3,
                                  ),
                                  height: 35,
                                  width: 35,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            ))),
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
      key: Key("Grid View"),
      pagingController: _pagingController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
      builderDelegate: PagedChildBuilderDelegate<Photos>(
        itemBuilder: (context, item, index) => _containerItem(
            Key("Photo Grid $index"),item,
            Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      flex: 4,
                      child: Container(
                          height: 70,
                          child: CachedNetworkImage(
                            imageUrl: item.src.medium,
                            placeholder: (context, url) => Center(
                              child: Container(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                  strokeWidth: 3,
                                ),
                                height: 35,
                                width: 35,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ))),
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Photo by ${item.photographer}",
                          style: TextStyles.medium,
                          textAlign: TextAlign.center,
                        ),
                      ))
                ],
              ),
            )),
      ),
    );
  }

  _containerItem(Key key, Photos photo, Widget child) {
    return InkWell(
      key: key,
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
        key: Key("Loading List"),
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
