import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:spot_hot/models/user.dart';
import 'package:spot_hot/proxy/firestore_proxy.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_image/firebase_image.dart';
import 'package:spot_hot/screens/follow_list.dart';
import 'package:spot_hot/screens/search_users.dart';
import 'edit_profile.dart';
import 'new_post.dart';
import 'package:spot_hot/components/post_tile.dart';
import 'search_users.dart';

final _firestore = FirebaseFirestore.instance;
User currentUser;
int totalPosts = 0;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _auth = auth.FirebaseAuth.instance;
  String _fullname = "John Doe";

  Widget _buildProfileImage(User currentUser) {
    //pull the image from the storage using the user's id
    //use the ternary operator if the path exists in firebase serve the image if not use the default profile image.
    print('Users profile url: ${currentUser.userProfilePictureLocation}');

    return Column(
      children: [
        Divider(
          height: 10.0,
        ),
        Center(
          child: Container(
            width: 140.0,
            height: 140.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FirebaseImage(currentUser.userProfilePictureLocation,
                    shouldCache: false),
              ),
              borderRadius: BorderRadius.circular(80.0),
              border: Border.all(
                color: Color(0xFFFFBE8F),
                width: .75,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullName(User currentUser) {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'BarlowCondensed',
      color: Colors.white,
      fontSize: 40.0,
      fontWeight: FontWeight.w700,
    );
    String fname = currentUser.firstName;
    String lname = currentUser.lastName;
    _fullname = "$fname $lname";
    return Text(
      '$fname $lname',
      style: _nameTextStyle,
    );
  }

  Widget _buildBio(BuildContext context, User currentUser) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        currentUser.bio,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'BarlowCondensed',
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      children: [
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _buildStatContainer(User currentUser) {
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFFFBE8F),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            child: _buildStatItem(
                "Following", currentUser.following.length.toString()),
            onTap: () async {
              print(
                  "//show the list of users the current logged in user is following");
              if (currentUser.following.length > 0) {
                List<User> followingList = [];

                //get the list of users current user is following
                for (var userId in currentUser.following) {
                  print(userId);

                  User userFollowing = await getUserByUUID(userId);
                  followingList.add(userFollowing);
                }

                //call the navigator to take the post's page
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new FollowList(followingList),
                );

                Navigator.of(context).push(route);
              }

              //pass this list to the list screen, push the list screen route on the navigator.
            },
          ),
          GestureDetector(
            child: _buildStatItem(
              "Followers",
              currentUser.followers.length.toString(),
            ),
            onTap: () async {
              print(
                  "//show the list of followers the current logged in user has");

              if (currentUser.followers.length > 0) {
                List<User> followingList = [];

                for (var userId in currentUser.followers) {
                  print(userId);

                  User userFollowing = await getUserByUUID(userId);
                  followingList.add(userFollowing);
                }

                //call the navigator to take the post's page
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new FollowList(followingList),
                );

                Navigator.of(context).push(route);
              }
            },
          ),
          _buildStatItem("Posts", totalPosts.toString()),
        ],
      ),
    );
  }

  Widget _buildEditProfile(User currentUser) {
    return OutlineButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: editProfile(
                  userProfileImageLocation:
                      currentUser.userProfilePictureLocation),
            ),
          ),
        );
      },
      child: Text(
        'Edit Profile',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                //fetch the user lists to search

                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new SearchUsers(),
                );

                Navigator.of(context).push(route);
              },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Message",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserByUUID(_auth.currentUser.uid),
        builder: (context, snapshot) {
          Size screenSize = MediaQuery.of(context).size;
          if (snapshot.connectionState == ConnectionState.done) {
            currentUser = snapshot.data;
            return Scaffold(
              backgroundColor: Color(0xFF935252),
              body: Stack(
                children: [
                  //_buildCoverImage(screenSize),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //SizedBox(height: screenSize.height / 6.4),
                          _buildProfileImage(currentUser),
                          _buildFullName(currentUser),
                          _buildBio(context, currentUser),
                          _buildStatContainer(currentUser),
                          _buildEditProfile(currentUser),
                          _buildButtons(),
                          UserPostStream(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Handler to create a new post
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: NewPost(),
                      ),
                    ),
                  );
                },
                child: Icon(Icons.create),
                backgroundColor: Color(0xFFFFBE8F),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

class UserPostStream extends StatefulWidget {
  @override
  _UserPostStreamState createState() => _UserPostStreamState();
}

class _UserPostStreamState extends State<UserPostStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('user_posts').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else {
          List<PostTile> userPosts = [];
          int currentUserPosts = 0;

          //get all the posts - iterate and only get the ones that contain the user's id
          var posts = snapshot.data.documents.reversed;

          for (var post in posts) {
            final user_id = post.get('user_id');

            //get all the posts created by the current logged on user
            if (user_id == currentUser.uuid) {
              print(
                  "obtained post with user_id: ${post.get('user_id')} date: ${post.get('date')},"
                  " desc: ${post.get('description')}, image: ${post.get('image')}");
              print("The id is: ${post.id}");

              //create a postTile with the user's info
              final pTile = PostTile(
                postCreator: currentUser,
                postDescription: post.get('description'),
                postImageLocation: post.get('image'),
                documentId: post.id,
                favs: post.get('likes'),
                //comments: post.get('comments'),
              );

              //append the postTile to the list of userPosts
              userPosts.add(pTile);

              //increment the amount of user posts for the current user
              currentUserPosts++;
            }
          }
          print("Total user posts: ${userPosts.length}");

          totalPosts = currentUserPosts;

          return ListView(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            children: userPosts,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            reverse: true,
          );
        }
      },
    );
  }
}
