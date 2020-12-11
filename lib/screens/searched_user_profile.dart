import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:spot_hot/models/user.dart';
import 'package:spot_hot/proxy/firestore_proxy.dart';
import 'package:firebase_image/firebase_image.dart';
import 'edit_profile.dart';
import 'new_post.dart';
import 'package:spot_hot/components/post_tile.dart';
import 'package:spot_hot/screens/profile.dart';
import 'package:spot_hot/proxy/firestore_proxy.dart';

final _firestore = FirebaseFirestore.instance;
User searchedUser;
int totalPosts = 0;

class SearchedUserProfile extends StatefulWidget {
  String userUUID;

  SearchedUserProfile(this.userUUID);

  @override
  _SearchedUserProfileState createState() => _SearchedUserProfileState();
}

class _SearchedUserProfileState extends State<SearchedUserProfile> {
  String _fullname = "John Doe";
  bool currentlyFollowing;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentlyFollowing = checkFollowing();
    });
  }

  bool checkFollowing() {
    //for debugging
    for (var u in currentUser.following) {
      print("current user is following: $u");
    }

    if (currentUser.following.contains(searchedUser.uuid)) {
      print("The current logged on user IS following this user!");
    } else {
      print("The current logged on user is NOT following this user!");
    }

    return currentUser.following.contains(searchedUser.uuid);
  }

  Widget _buildProfileImage(User searchedUser) {
    //pull the image from the storage using the user's id
    //use the ternary operator if the path exists in firebase serve the image if not use the default profile image.
    print('Users profile url: ${searchedUser.userProfilePictureLocation}');

    //check if the current logged on user is following searched user

    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FirebaseImage(searchedUser.userProfilePictureLocation,
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

  Widget _buildFullName(User searchedUser) {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );
    String fname = searchedUser.firstName;
    String lname = searchedUser.lastName;
    _fullname = "$fname $lname";
    return Text(
      '$fname $lname',
      style: _nameTextStyle,
    );
  }

  Widget _buildBio(BuildContext context, User searchedUser) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        searchedUser.bio,
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

  Widget _buildStatContainer(User searchedUser) {
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Following", searchedUser.following.length.toString()),
          _buildStatItem("Followers", searchedUser.followers.length.toString()),
          _buildStatItem("Posts", totalPosts.toString()),
        ],
      ),
    );
  }

  Widget _buildEditProfile(User searchedUser) {
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
                      searchedUser.userProfilePictureLocation),
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
              onTap: () async {
                //unfollow the user
                if (currentlyFollowing == true) {
                  removeFollower(currentUser.uuid, searchedUser.uuid);
                  unfollowUser(currentUser.uuid, searchedUser.uuid);
                  currentlyFollowing = false;
                  setState(() {});
                } else {
                  //follow the user
                  followUser(currentUser.uuid, searchedUser.uuid);
                  addFollower(currentUser.uuid, searchedUser.uuid);
                  currentlyFollowing = true;
                  setState(() {});
                }
              },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: currentlyFollowing == true
                      ? Colors.grey
                      : Colors.lightBlueAccent,
                ),
                child: Center(
                  child: Text(
                    currentlyFollowing == true ? "Unfollow" : "Follow",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
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

  //14:20

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserByUUID(widget.userUUID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            searchedUser = snapshot.data;
            return Scaffold(
              body: Stack(
                children: [
                  //_buildCoverImage(screenSize),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //SizedBox(height: screenSize.height / 6.4),
                          _buildProfileImage(searchedUser),
                          _buildFullName(searchedUser),
                          _buildBio(context, searchedUser),
                          _buildStatContainer(searchedUser),
                          _buildEditProfile(searchedUser),
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
            if (user_id == searchedUser.uuid) {
              //create a postTile with the user's info
              final pTile = PostTile(
                postCreator: searchedUser,
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
