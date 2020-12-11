import 'package:flutter/material.dart';
import 'package:spot_hot/models/user.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:spot_hot/screens/searched_user_profile.dart';

class FollowList extends StatefulWidget {
  List<User> followingList = [];

  FollowList(this.followingList);

  @override
  _FollowListState createState() => _FollowListState();
}

class _FollowListState extends State<FollowList> {
  Widget followerTile(User user) {
    return Row(
      children: [
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black26,
              width: 1.0,
            ),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: FirebaseImage(user.userProfilePictureLocation),
            ),
          ),
          child: null,
        ),
        Text(user.userName)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<User> followList = widget.followingList;

    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
        title: Text('SpotHot'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: followList.length,
          padding: EdgeInsets.all(3.0),
          itemBuilder: (context, index) => ListTile(
            onTap: () {
              //open the user's profile
              var route = new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new SearchedUserProfile(followList[index].uuid),
              );

              Navigator.of(context).push(route);
            },
            leading: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black26,
                  width: 1.0,
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FirebaseImage(
                      followList[index].userProfilePictureLocation),
                ),
              ),
            ),
            title: Text(followList[index].userName),
          ),
        ),
      ),
    );
  }
}
