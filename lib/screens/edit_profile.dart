import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:spot_hot/constants.dart';
import 'package:path/path.dart';
import 'package:firebase_image/firebase_image.dart';

class editProfile extends StatefulWidget {
  String userProfileImageLocation;

  editProfile({this.userProfileImageLocation});

  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  FirebaseAuth auth;
  File imageSelected;
  String imageName;
  String bioText;

  @override
  Widget build(BuildContext context) {
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

    Future<String> updateUserProfilePicture() async {
      final _storage = FirebaseStorage.instance;

      //get the image filename of current profile picture
      var imagePath = widget.userProfileImageLocation.split('/');
      var imageFileName = imagePath.last;
      print("Current user profile file name: $imageFileName");

      //remove the old profile picture
      var snapshot = await _storage
          .ref()
          .child('user_profile_picture/$imageFileName')
          .delete();

      //upload the new profile picture
      var snapshotUpload = await _storage
          .ref()
          .child('user_profile_picture/$imageName')
          .putFile(imageSelected)
          .onComplete;

      //get image location
      String pictureName, pictureStorageLocation;
      pictureName = snapshotUpload.storageMetadata.path;
      pictureStorageLocation = StoragePath + pictureName;

      print("path url: $pictureStorageLocation");
      return pictureStorageLocation;
    }

    return Container(
      color: Color(0xFF757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Color(0xFF935252),
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
                fontFamily: 'BarlowCondensed',
                fontSize: 35.0,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                width: 60.0,
                height: 60.0,
                child: IconButton(
                  icon: Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    print("Icon changed.");

                    //open the image selector
                    final _picker = ImagePicker();
                    PickedFile image;

                    await Permission.photos.request();
                    var permissionStatus = await Permission.photos.status;

                    if (permissionStatus.isGranted) {
                      image =
                          await _picker.getImage(source: ImageSource.gallery);
                      imageSelected = File(image.path);
                      imageName = basename(imageSelected.path);
                      print("Image name: $imageName");
                    }

                    // this is used to update the icon next the the choose image button.
                    if (imageSelected != null) {
                      setState(() {});
                    }
                  },
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageSelected == null
                        ? FirebaseImage(widget.userProfileImageLocation)
                        : FileImage(imageSelected),
                  ),
                ),
              ),
            ),
            Text(
              'Edit Bio',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BarlowCondensed',
                fontSize: 35.0,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, right: 35.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Color(0xFFFFBE8F),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFFFBE8F), width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFFFBE8F), width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
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
                  color: Color(0xFFFFBE8F),
                  textColor: Colors.white,
                  onPressed: () async {
                    //if the user did not choose an image just update the bio.
                    if (imageSelected == null && bioText != null) {
                      print('current user id: ${auth.currentUser.uid}');
                      try {
                        updateUserBio(auth.currentUser.uid, bioText);
                        Navigator.pop(context);
                      } catch (e) {
                        print(e);
                      }
                    } //if the user is updating the image and the text
                    else if (imageSelected != null && bioText != null) {
                      String pictureStorageLocation =
                          await updateUserProfilePicture();

                      //update the user's profile image with the image location
                      updateUserProfile(
                          auth.currentUser.uid, pictureStorageLocation);

                      //update the bio
                      try {
                        updateUserBio(auth.currentUser.uid, bioText);
                        Navigator.pop(context);
                      } catch (e) {
                        print(e);
                      }
                    } //if the user wants to update their profile picture only
                    else if (imageSelected != null && bioText == null) {
                      String pictureStorageLocation =
                          await updateUserProfilePicture();

                      //update the user's profile image with the image location
                      updateUserProfile(
                          auth.currentUser.uid, pictureStorageLocation);
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Save')),
            )
          ],
        ),
      ),
    );
  }
}
