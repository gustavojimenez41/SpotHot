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
  List allComments;
  User currentUser;
  Future<void> blehss() async {
    // allComments = await getCommentsOnPropertyOrPost('property', 'BC7bCPBGIksnfXJon378');
    // currentUser = await getUserByUUID(_auth.currentUser.uid);
    allComments = [
      {'user': 'fdlsh', 'value': 'this is comment2'},
      {'user': 'fdlsh', 'value': 'this is comment3'},
      {'user': 'fdlsh', 'value': 'this is comment4'},
      {'user': 'fdlsh', 'value': 'this is comment5'},
    ];
    currentUser = User('gustavo', "Jimenez", "bio", "uuid", "stavo41", [], [],
        "profileLocation");
    return;
  }

  Widget buildCommentList(List curComments) {
    List<CommentTile> commentThread = [];

    for (var comment in curComments) {
      String commentUserId = comment['user'];
      String userComment = comment['value'];

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
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'BarlowCondensed',
      color: Colors.white,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );
    return FutureBuilder(
        future: blehss(),
        builder: (context, snapshot) {
          Size screenSize = MediaQuery.of(context).size;
          if (snapshot.connectionState == ConnectionState.done) {
            // allComments = snapshot.data;
            Widget commentToShow = buildCommentList(allComments);
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
                          decoration: BoxDecoration(color: Color(0xFFFFBE8F)),
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
                textAlign: TextAlign.center,
                style: _nameTextStyle,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                  Text(
                    "(4.1/5)",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Divider(
                height: 10,
                thickness: 2,
                indent: 25,
                endIndent: 25,
              ),
            ];
            columnValues.add(commentToShow);
            return Scaffold(
              backgroundColor: Color(0xFF935252),
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
