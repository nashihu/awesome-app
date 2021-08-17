import 'package:awesome_app/controller/view-mode-controller.dart';
import 'package:awesome_app/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Widget> _generateHardCodedImages() {
    List<Widget> output = [];
    for (int i = 0; i < 50; i++) {
      output.add(Image.network(RANDOM_IMAGE_URL_HEADER));
    }
    return output;
  }

  late ViewModeController _viewModeController;

  _toggleViewMode(bool value) {
    _viewModeController.toggleView(value);
  }

  _isListMode() {
    return _viewModeController.listMode.value;
  }

  @override
  void initState() {
    _generateHardCodedImages();
    _viewModeController = Get.put(ViewModeController());

    super.initState();
  }

  _gridIcon(bool isListActive) {
    return Icon(Icons.grid_view,
      color: isListActive ?  Colors.grey : Colors.black
    );
  }

  _listIcon(bool isListActive) {
    return Icon(Icons.view_list,
        color: isListActive ? Colors.black : Colors.grey
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
              _toggleViewMode(false);
            },
            icon: Obx(() => _gridIcon(_isListMode()))
        ),
        IconButton(
          onPressed: () {
            _toggleViewMode(true);
          },
          icon: Obx(() => _listIcon(_isListMode()))
        ),
        SizedBox(width: 10,),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(RANDOM_IMAGE_URL_HEADER),
      ),
    );
  }

  _gridView() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 0.8,
      ),
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 4,
                    child: Container(
                        child: Image.network(RANDOM_IMAGE_URL_ITEM)
                    )
                ),
                Expanded(
                    flex: 1,
                    child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                      style: TextStyles.medium,
                      textAlign: TextAlign.center,
                    )
                )
              ],
            ),
          );
        },
        childCount: 30,
      ),
    );
  }

  _listView() {
    return SliverList(
      key: UniqueKey(),
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment.topLeft,
              // color: Colors.blue,
              // height: 150,
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Image.network(RANDOM_IMAGE_URL_ITEM)
                      )
                  ),
                  Expanded(
                    // width: 200,
                      flex: 2,
                      child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                        style: TextStyles.medium,
                      )
                  )
                ],
              ));
        },
        childCount: 50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _sliverHeader(),
          Obx(() => _isListMode() ?
          _listView() : _gridView()
          )
        ],
      ),
    );
  }
}
