import 'package:flutter/material.dart';
import 'package:spot_hot/models/user.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spot_hot/proxy/firestore_proxy.dart';
import 'package:spot_hot/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:spot_hot/components/comment_tile.dart';
import 'package:spot_hot/screens/post_page.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../screens/profile.dart';

class PostTile extends StatefulWidget {
  final User postCreator;
  final postDescription;
  final postImageLocation;
  final documentId;
  List favs = []; //this holds an array of all the user's id that fav the post
  int numberOfFavs;
  //var comments = []; //holds map of all the comments {"user_id":"comments"}
  int numberOfComments = 0;
  bool isFavorited = false;

  Color unFavColor = Colors.grey;
  Color favColor = Colors.redAccent;
  Icon unFavIcon = Icon(Icons.favorite_border_outlined);
  Icon favIcon = Icon(Icons.favorite);

  PostTile(
      {this.postCreator,
      this.postDescription,
      this.postImageLocation,
      this.documentId,
      this.favs}) {
    /*get the number of favs from the total length of the favs array
    this array holds all of the user's ids that Fav this post*/
    numberOfFavs = favs.length;
    //TODO fix comments
//    if (comments.length != 0) {
//      numberOfComments = comments.length;
//    }
    print('number of comments: $numberOfComments');

    /*if the current user's id is in the fav array then set the favorite
    icon to favorited to keep the state*/
    if (favs.contains(postCreator.uuid)) {
      isFavorited = true;
    }
  }

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  CollectionReference posts =
      FirebaseFirestore.instance.collection('user_posts');
  //get the post creator's information
  //get the post information from the database

  //add an event for touching the chat icon and the heart icon

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 30.0,
                height: 30.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FirebaseImage(
                          widget.postCreator.user_profile_picture,
                          shouldCache: false),
                    ),
                    borderRadius: BorderRadius.circular(28.0)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  widget.postCreator.userName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.black38,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: ConfirmDelete(
                          documentId: widget.documentId,
                          onPostPage: false,
                          imageLocation: widget.postImageLocation,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              //when the user taps on the image take to the post page
              var route = new MaterialPageRoute(
                builder: (BuildContext context) => new PostPage(widget),
              );

              Navigator.of(context).push(route);
            },
            child: Container(
              margin: EdgeInsets.all(2.0),
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: FirebaseImage(widget.postImageLocation),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  child: Expanded(
                    child: Text(
                      widget.postDescription, // post description
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: IconButton(
                  icon: Icon(Icons.chat, color: Colors.black45),
                  onPressed: () {
                    print("comments icon tapped.");

                    //call the navigator to take the post's page
                    var route = new MaterialPageRoute(
                      builder: (BuildContext context) => new PostPage(widget),
                    );

                    Navigator.of(context).push(route);
                  },
                ),
              ),
              Text(
                widget.numberOfComments.toString(), //number of comments
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: IconButton(
                  icon: widget.isFavorited ? widget.favIcon : widget.unFavIcon,
                  color:
                      widget.isFavorited ? widget.favColor : widget.unFavColor,
                  onPressed: () {
                    if (widget.isFavorited == false) {
                      setState(() {
                        //the post is liked by the user - set it to red - add user's uid to the like array
                        //update the count
                        widget.unFavColor = Colors.redAccent;
                        widget.favIcon = Icon(Icons.favorite);
                        widget.isFavorited = true;
                        likePost(widget.documentId, widget.postCreator.uuid);
                        //call firebase function to increment the number of posts
                      });
                    } else {
                      setState(() {
                        //the post is unliked by the user - set it to grey - remove user's uid from fav array
                        //decrement the count
                        widget.unFavColor = Colors.grey;
                        widget.unFavIcon = Icon(Icons.favorite_border_outlined);
                        widget.isFavorited = false;
                        unLikePost(widget.documentId, widget.postCreator.uuid);
                      });
                    }
                  },
                ),
              ),
              Text(
                widget.numberOfFavs.toString(), //number of favorites
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ConfirmDelete extends StatefulWidget {
  @override
  _ConfirmDeleteState createState() => _ConfirmDeleteState();
  String documentId;
  bool onPostPage;
  String imageLocation;

  ConfirmDelete({this.documentId, this.onPostPage, this.imageLocation});
}

class _ConfirmDeleteState extends State<ConfirmDelete> {
  CollectionReference posts =
      FirebaseFirestore.instance.collection('user_posts');
  String documentId;

  //create default constructor that gets the user's username, profile picture,
  Future<void> deletePost() {
    return posts
        .doc(widget.documentId)
        .delete()
        .then((value) => print("post deleted!"))
        .catchError((error) => print("Failed to delete post: $error"));
  }

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
          children: [
            Text('Do you want to delete this post?'),
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, right: 75.0, left: 75.0),
              child: FlatButton(
                  color: Colors.lightBlueAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('No')),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, right: 75.0, left: 75.0),
              child: FlatButton(
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  onPressed: () async {
                    //call the function to delete this
                    setState(() {
                      if (totalPosts < 0) {
                        totalPosts--;
                      }
                    });
                    //delete the post
                    deletePost();

                    //get the image filename
                    var imagePath = widget.imageLocation.split('/');
                    var imageFileName = imagePath.last;
                    print("The filename of the image is: $imageFileName");

                    //delete the image from the storage/property directory
                    final _storage = FirebaseStorage.instance;
                    var snapshot = await _storage
                        .ref()
                        .child('property/$imageFileName')
                        .delete();

                    //pop the confirm delete screen
                    Navigator.pop(context);

                    // if the user is on the post page, pop the page again to go back to user's profile.
                    if (widget.onPostPage == true) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Yes')),
            )
          ],
        ),
      ),
    );
  }
}
