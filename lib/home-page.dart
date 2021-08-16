import 'package:awesome_app/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    _generateHardCodedImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text("Awesome App"),
            expandedHeight: 250,
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.grid_view)
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.view_list),
              ),
              SizedBox(width: 10,),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(RANDOM_IMAGE_URL_HEADER),
            ),
          ),
          true ? SliverGrid(
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
          ) :
          SliverList(
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
          ),
        ],
      ),
    );
  }
}
