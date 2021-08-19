import 'package:awesome_app/model/curated.dart';
import 'package:awesome_app/util/static-helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {

  final Photos photo;

  const DetailPage(this.photo, {Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  late String imgUrl;
  late Photos photo;
  late double height;
  late bool isBrightPhoto;


  @override
  void initState() {
    photo = widget.photo;
    imgUrl = photo.src.portrait;
    isBrightPhoto = Helpers.isBrightColor(photo.avgColor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height * 0.7;
    return Scaffold(
      body: CustomScrollView(
        key: Key("Detail Page"),
        slivers: [
          SliverAppBar(
            title: Text("Photo by ${photo.photographer}",
              style: TextStyle(
                color: isBrightPhoto ? Colors.black : Colors.white
              ),
            ),
            expandedHeight: height,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: imgUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                placeholder: (context, url) => Center(
                  child: Container(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    height: 100,
                    width: 100,
                  ),
                ),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
              // background: Image.network(imgUrl,fit: BoxFit.fill),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(10),
              child: MaterialButton(
                height: 50,
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  await canLaunch(photo.photographerUrl) ?
                  await launch(photo.photographerUrl) :
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                      SnackBar(content: Text('Terjadi kesalahan'))
                  );
                },
                child: Text("Photographer Page",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
