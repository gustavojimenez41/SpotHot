import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class editProfile extends StatefulWidget {
  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  String ImageUrl;
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
                fontSize: 30.0,
                color: Color(0xFFFFBE8F),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 110.0, left: 110.0, bottom: 8.0),
              child: FlatButton(
                color: Colors.grey,
                textColor: Colors.white,
                onPressed: () => uploadImage(),
                child: Text('upload'),
              ),
            ),
            Text(
              'Edit Bio',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Color(0xFFFFBE8F),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, right: 35.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Color(0xFFFFBE8F),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFFBE8F),
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFFBE8F),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFFBE8F))),
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
                    //save the bio text
                    print('current user id: ${auth.currentUser.uid}');
                    try {
                      updateUserBio(auth.currentUser.uid, bioText);
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }

                    //Navigator.pop(context);
                  },
                  child: Text('Save')),
            )
          ],
        ),
      ),
    );
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //check permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //proceed with picking image from device
      //select image
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);

      if (image != null) {
        //upload to firebase
        var snapshot = await _storage
            .ref()
            .child('user_profile_picture/${auth.currentUser.uid}')
            .putFile(file)
            .onComplete;

        var downloadURL = await snapshot.ref.getDownloadURL();

        setState(() {
          ImageUrl = downloadURL;
        });
      } else {
        print('No path received!');
      }
    } else {
      print('Permissions not granted.');
    }
  }
}
