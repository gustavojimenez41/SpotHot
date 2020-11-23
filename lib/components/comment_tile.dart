import 'package:flutter/material.dart';
import 'package:spot_hot/models/user.dart';
import 'package:firebase_image/firebase_image.dart';

class CommentTile extends StatefulWidget {
  @override
  _CommentTileState createState() => _CommentTileState();
  final User commentCreator;
  String comment;

  CommentTile({this.commentCreator, this.comment}) {}
}

class _CommentTileState extends State<CommentTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
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
                            widget.commentCreator.user_profile_picture,
                            shouldCache: false),
                      ),
                      borderRadius: BorderRadius.circular(28.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    widget.commentCreator.userName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              children: [Text(widget.comment)],
            )
          ],
        ),
      ),
    );
  }
}
