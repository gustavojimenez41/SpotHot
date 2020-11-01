import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:spot_hot/constants.dart';

class editProfile extends StatefulWidget {
  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  FirebaseAuth auth;

  @override
  Widget build(BuildContext context) {
    String bioText;
    auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    Future<void> updateUserBio(String userID, String bioText) {
      return users
          .doc(userID)
          .update({'bio': bioText})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    Future<void> updateUserProfile(String userID, String profileUrl) {
      return users
          .doc(userID)
          .update({'user_profile_picture': profileUrl})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    return Container(
      color: Color(0xFF757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Edit Profile Picture',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 110.0, left: 110.0, bottom: 8.0),
              child: FlatButton(
                color: Colors.grey,
                textColor: Colors.white,
                onPressed: () async {
                  final _storage = FirebaseStorage.instance;
                  final _picker = ImagePicker();
                  PickedFile image;

                  await Permission.photos.request();

                  var permissionStatus = await Permission.photos.status;

                  if (permissionStatus.isGranted) {
                    image = await _picker.getImage(source: ImageSource.gallery);
                    File file = File(image.path);

                    if (image != null) {
                      //upload to firebase
                      var snapshot = await _storage
                          .ref()
                          .child(
                              'user_profile_picture/${file.hashCode}') //change this to be something else like the name of the file
                          .putFile(file)
                          .onComplete;

                      //create the path for the user's profile storage
                      String storagepath = StoragePath;
                      var userprofileURL = await snapshot.ref.getPath();
                      var pathURL = storagepath + userprofileURL;

                      print("PATH url: $pathURL");

                      updateUserProfile(auth.currentUser.uid, pathURL);
                    } else {
                      print('No path received!');
                    }
                  } else {
                    print('Permissions not granted.');
                  }
                  Navigator.pop(context);
                },
                child: Text('upload'),
              ),
            ),
            Text(
              'Edit Bio',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, right: 35.0),
              child: TextField(
                autofocus: true,
                textAlign: TextAlign.center,
                onChanged: (newText) {
                  bioText = newText;
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, right: 75.0, left: 75.0),
              child: FlatButton(
                  color: Colors.lightBlueAccent,
                  textColor: Colors.white,
                  onPressed: () async {
                    //save the bio text
                    print('current user id: ${auth.currentUser.uid}');
                    try {
                      updateUserBio(auth.currentUser.uid, bioText);
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text('Save')),
            )
          ],
        ),
      ),
    );
  }
}
