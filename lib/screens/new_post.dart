import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:spot_hot/constants.dart';
import 'package:spot_hot/proxy/firestore_proxy.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  String newPostText;
  File imageSelected;
  String imageName;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
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
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlineButton(
                  borderSide: BorderSide(color: Colors.grey),
                  onPressed: () async {
                    //get the image from the user's phone and store it in the image variable
                    final _picker = ImagePicker();
                    PickedFile image;

                    await Permission.photos.request();
                    var permissionStatus = await Permission.photos.status;

                    if (permissionStatus.isGranted) {
                      image =
                          await _picker.getImage(source: ImageSource.gallery);
                      imageSelected = File(image.path);
                      imageName = basename(imageSelected.path);

                      if (imageSelected != null) {
                        // this is used to update the icon next the the choose image button.
                        setState(() {});
                      }
                    }
                  },
                  child: Icon(Icons.add_photo_alternate_sharp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                //display a small-view of the picture
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Container(
                    color: Colors.black12,
                    child: imageSelected == null
                        ? Icon(
                            Icons.add,
                            color: Colors.black38,
                            size: 40.0,
                          )
                        : Image.file(imageSelected, height: 40.0, width: 40),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: "What's happening?",
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
                onChanged: (newText) {
                  newPostText = newText;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, right: 75.0, left: 75.0),
              child: FlatButton(
                  color: Colors.lightBlueAccent,
                  textColor: Colors.white,
                  onPressed: () async {
                    //get the date and the time
                    final _storage = FirebaseStorage.instance;

                    //if no image is then just upload the text
                    if (imageSelected == null && newPostText != null) {
                      print('newPostText: $newPostText');

                      //call the function to upload the post to the database w/o picture

                    }

                    //if an image is selected then upload the image and the text
                    if (imageSelected != null && newPostText != null) {
                      //put the image into storage
                      var snapshot = await _storage
                          .ref()
                          .child('property/${(imageName)}')
                          .putFile(imageSelected)
                          .onComplete;

                      //get image location
                      String pictureName, pictureStorageLocation;
                      pictureName = snapshot.storageMetadata.path;
                      // StoragePath is a global constant stored in constants
                      pictureStorageLocation = StoragePath + pictureName;

                      //get the date
                      print("Datetime: ${DateTime.now()}");

                      //upload the post with the image storage location
                      createUserPost(auth.currentUser.uid, newPostText,
                          DateTime.now().toString(), pictureStorageLocation);
                    }

                    Navigator.pop(context);
                  },
                  child: Text('Post')),
            )
          ],
        ),
      ),
    );
  }
}
