import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:spot_hot/models/comment.dart';
import 'package:spot_hot/proxy/firestore_proxy.dart';

class PropertyScreen extends StatefulWidget {
  static const id = "property_screen";
  @override
  _PropertyScreenState createState() => _PropertyScreenState();
}

class _PropertyScreenState extends State<PropertyScreen> {
  List<Comment> allComments;
  @override
  Widget build(BuildContext context) {
    List<String> bleh = [
      "first comment",
      "second comment",
      "third comment",
      "fourth comment"
    ];
    List<Text> listTexts = [];
    for (String com in bleh) {
      Text curPropretyCard = Text('$com');
      listTexts.add(curPropretyCard);
    }
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );
    return FutureBuilder(
        future: getCommentsOnProperty(),
        builder: (context, snapshot) {
          Size screenSize = MediaQuery.of(context).size;
          if (snapshot.connectionState == ConnectionState.done) {
            allComments = snapshot.data;
            List<Widget> columnValues = [
              CarouselSlider(
                options: CarouselOptions(
                  height: 400,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                items: [1, 2, 3, 4, 5].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(color: Colors.amber),
                          child: Text(
                            'text $i',
                            style: TextStyle(fontSize: 16.0),
                          ));
                    },
                  );
                }).toList(),
              ),
              Text(
                'Chamoy Fruit Vendor and Dessert',
                style: _nameTextStyle,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.star),
                  Text("(4.1/5)"),
                ],
              ),
              Divider(
                height: 10,
                thickness: 2,
                indent: 25,
                endIndent: 25,
              )
            ];
            for (Comment com in allComments) {
              Text comText = Text('${com.value}');
              columnValues.add(comText);
            }
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: columnValues),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
