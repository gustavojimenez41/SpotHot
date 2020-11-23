import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:spot_hot/models/user.dart';
import 'package:spot_hot/proxy/firestore_proxy.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_image/firebase_image.dart';
import 'edit_profile.dart';
import 'new_post.dart';
import 'package:spot_hot/components/post_tile.dart';

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
    print('Users profile url: ${currentUser.user_profile_picture}');

    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FirebaseImage(currentUser.user_profile_picture,
                shouldCache: false),
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 8.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName(User currentUser) {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
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
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        currentUser.bio,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
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
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Following", currentUser.following.length.toString()),
          _buildStatItem("Followers", currentUser.followers.length.toString()),
          _buildStatItem("Posts", totalPosts.toString()),
        ],
      ),
    );
  }

  Widget _buildEditProfile() {
    return OutlineButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: editProfile(),
            ),
          ),
        );
      },
      child: Text('Edit Profile'),
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
                //handle the follow button functionality
                print("followed");
              },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlueAccent.shade200),
                  color: Colors.lightBlueAccent,
                ),
                child: Center(
                  child: Text(
                    "Follow",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: InkWell(
              onTap: () => print("Message"),
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
                      style: TextStyle(fontWeight: FontWeight.w600),
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

  Widget _buildConnectWithUser(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        'Connect with ${_fullname.split(" ")[0]}',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16.0,
        ),
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
                          _buildEditProfile(),
                          _buildConnectWithUser(context),
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
                backgroundColor: Colors.lightBlueAccent,
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
