import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:spot_hot/models/user.dart';
import 'package:spot_hot/proxy/firestore_proxy.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_image/firebase_image.dart';
import 'edit_profile.dart';
import 'newpost.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _auth = auth.FirebaseAuth.instance;
  String _fullname = "John Doe";
  String _posts = "0";

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 3.3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/defaultwallpaper.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<bool> userProfilePictureExists() async {
    final snapShot = await FirebaseFirestore.instance
        .collection('user_profile_picture/')
        .doc(_auth.currentUser.uid)
        .get();

    if (snapShot == null || !snapShot.exists) {
      return true;
    } else {
      return false;
    }
  }

  Widget _buildProfileImage() {
    //pull the image from the storage using the user's id
    //use the ternary operator if the path exists in firebase serve the image if not use the default profile image.

    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: userProfilePictureExists() != null
                ? FirebaseImage(
                    'gs://senior-design-862c5.appspot.com/user_profile_picture/${_auth.currentUser.uid}',
                    shouldCache: true)
                : AssetImage('images/defaultprofile.png'),
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
      color: Colors.white,
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
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w300,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.white,
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
      decoration: BoxDecoration( border: Border(bottom: BorderSide(color: Color(0xFFFFBE8F),),),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Following", currentUser.following.length.toString()),
          _buildStatItem("Followers", currentUser.followers.length.toString()),
          _buildStatItem("Posts", _posts),
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
      child: Text('Edit Profile',
      style: TextStyle(color: Colors.white),),
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
                  border: Border.all(color: Color(0xFFFFBE8F)),
                  color: Color(0xFFFFBE8F),
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
                      style: TextStyle(fontWeight: FontWeight.w600,
                      color: Colors.white),
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
          color: Colors.white
        ),
      ),
    );
  }

  //14:20

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserByUUID(_auth.currentUser.uid),
        builder: (context, snapshot) {
          Size screenSize = MediaQuery.of(context).size;
          if (snapshot.connectionState == ConnectionState.done) {
            User currentUser = snapshot.data;
            return Scaffold(
              body: Stack(
                children: [
                  _buildCoverImage(screenSize),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: screenSize.height / 6.4),
                          _buildProfileImage(),
                          _buildFullName(currentUser),
                          _buildBio(context, currentUser),
                          _buildStatContainer(currentUser),
                          _buildEditProfile(),
                          _buildConnectWithUser(context),
                          _buildButtons(),
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
