import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:spot_hot/models/comment.dart';
import 'package:spot_hot/proxy/firestore_proxy.dart';
import 'package:spot_hot/components/comment_tile.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:spot_hot/models/user.dart';

User currentUser;

class PropertyScreen extends StatefulWidget {
  static const id = "property_screen";
  @override
  _PropertyScreenState createState() => _PropertyScreenState();
}

class _PropertyScreenState extends State<PropertyScreen> {
  final _auth = auth.FirebaseAuth.instance;
  Widget allComments;

  Future<Widget> buildCommentList() async {
    List<CommentTile> commentThread = [];
    List<Map> comments = [];
    currentUser = await getUserByUUID(_auth.currentUser.uid);

    for (var comment in comments) {
      var commentData = {};
      commentData = comment;
      String commentUserId = commentData.keys.first;
      String userComment = commentData.values.first;

      //get the create a user object with the user's uid

      //create a comment tile
      final cTile =
          CommentTile(commentCreator: currentUser, comment: userComment);

      commentThread.add(cTile);
    }

    //then create a list view and return it to the screen
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      children: commentThread,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      reverse: false,
    );
  }

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
        future: buildCommentList(),
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
              ),
            ];
            columnValues.add(allComments);
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
