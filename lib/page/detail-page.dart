import 'package:awesome_app/util/styles.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {

  final imgUrl;

  const DetailPage({Key? key, @required this.imgUrl}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  late String imgUrl;

  @override
  void initState() {
    imgUrl = widget.imgUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("Detail Lorem Ipsum"),
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(imgUrl),
            ),
          ),
          SliverGrid.count(
            crossAxisCount: 1,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                  style: TextStyles.large,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
