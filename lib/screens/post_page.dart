import 'package:flutter/material.dart';
import 'package:spot_hot/components/post_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spot_hot/proxy/firestore_proxy.dart';
import 'package:spot_hot/components/comment_tile.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class PostPage extends StatefulWidget {
  PostTile postInformation;

  PostPage(this.postInformation) {
    print("PostPage");
  }

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  CollectionReference posts =
      FirebaseFirestore.instance.collection('user_posts');

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Widget buildCommentList(List comments) {
    List<CommentTile> commentThread = [];

    for (var comment in comments) {
      var commentData = {};
      commentData = comment;
      print("username: ${commentData.keys.first}");
      print("comment: ${commentData.values.first}");

      String commentUserId = commentData.keys.first;
      String userComment = commentData.values.first;

      //get the create a user object with the user's uid

      //create a comment tile
//      final cTile =
//          CommentTile(commentCreator: commenter, comment: userComment);
//
//      commentThread.add(cTile);
    }

    //then create a list view and return it to the screen
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      children: commentThread,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      reverse: false,
    );
  }

  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore
          .collection('user_posts')
          .doc(widget.postInformation.documentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              leading: null,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
              backgroundColor: Colors.lightBlueAccent,
            ),
            body: Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                      child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [Text("ERROR! POST NOT FOUND!")],
                    ),
                  )),
                )
              ],
            ),
          );
        } else {
          //if the post is found get the stream data

          var post = snapshot.data;
          List favs = post.get('likes');
          int numberofFavs = favs.length;
          String newCommentText;
          final _auth = auth.FirebaseAuth.instance;
          final commentField = TextEditingController();

          //TODO make a for loop to get all the comments for the post using the stream builder
          //TODO make a map for all the comments in the for loop
          //ListView commentThread = buildCommentList(widget.postInformation.comments);

          return Scaffold(
              appBar: AppBar(
                leading: null,
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
                backgroundColor: Colors.lightBlueAccent,
              ),
              body: Stack(
                children: [
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Container(
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
                                            widget.postInformation.postCreator
                                                .userProfilePictureLocation,
                                            shouldCache: false),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(28.0)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    widget.postInformation.postCreator.userName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
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
                                      builder: (BuildContext context) =>
                                          SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: ConfirmDelete(
                                              documentId: widget
                                                  .postInformation.documentId,
                                              onPostPage: true,
                                              imageLocation: widget
                                                  .postInformation
                                                  .postImageLocation),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.all(2.0),
                              height: 250,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FirebaseImage(widget
                                        .postInformation.postImageLocation),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    child: Expanded(
                                      child: Text(
                                        widget.postInformation
                                            .postDescription, // post description
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.chat,
                                      color: Colors.black45,
                                    ),
                                    onPressed: () {
                                      print(
                                          "comments icon tapped on post page.");
                                      // TODO when the user hits this icon then it will bring up the post a comment input field
                                    },
                                  ),
                                ),
                                Text(
                                  widget.postInformation.numberOfComments
                                      .toString(), //number of comments
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: IconButton(
                                    icon: widget.postInformation.isFavorited
                                        ? widget.postInformation.favIcon
                                        : widget.postInformation.unFavIcon,
                                    color: widget.postInformation.isFavorited
                                        ? widget.postInformation.favColor
                                        : widget.postInformation.unFavColor,
                                    onPressed: () {
                                      if (widget.postInformation.isFavorited ==
                                          false) {
                                        setState(() {
                                          //the post is liked by the user - set it to red - add user's uid to the like array
                                          //update the count
                                          widget.postInformation.unFavColor =
                                              Colors.redAccent;
                                          widget.postInformation.favIcon =
                                              Icon(Icons.favorite);
                                          widget.postInformation.isFavorited =
                                              true;
                                          likePost(
                                              widget.postInformation.documentId,
                                              widget.postInformation.postCreator
                                                  .uuid);
                                          //call firebase function to increment the number of posts
                                        });
                                      } else {
                                        setState(() {
                                          //the post is unliked by the user - set it to grey - remove user's uid from fav array
                                          //decrement the count
                                          widget.postInformation.unFavColor =
                                              Colors.grey;
                                          widget.postInformation.unFavIcon =
                                              Icon(Icons
                                                  .favorite_border_outlined);
                                          widget.postInformation.isFavorited =
                                              false;
                                          unLikePost(
                                              widget.postInformation.documentId,
                                              widget.postInformation.postCreator
                                                  .uuid);
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Text(
                                  numberofFavs.toString(), //number of favorites
                                ),
                              ],
                            ),
                            TextField(
                              autofocus: false,
                              controller: commentField,
                              textAlign: TextAlign.left,
                              onChanged: (newText) {
                                newCommentText = newText;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Create your reply...'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FlatButton(
                                  onPressed: () {
                                    //submit the comment to firebase
                                    print('submit the comment to firebase');

                                    //increment the comment count
                                    widget.postInformation.numberOfComments++;

                                    //if the comment text is not null submit the comment
                                    if (newCommentText != null) {
                                      uploadCommentToPost(
                                          widget.postInformation.documentId,
                                          _auth.currentUser.uid,
                                          newCommentText);
                                    }

                                    //after the comments is posted clear the text field
                                    commentField.clear();
                                  },
                                  child: Text('reply'),
                                  color: Colors.blueAccent,
                                  textColor: Colors.white,
                                ),
                              ],
                            ),
                            //TODO put all the comments here in a listview,
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ));
        }
      },
    );
  }
}
