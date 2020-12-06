import 'package:flutter/material.dart';
import 'package:spot_hot/models/user.dart';
import 'package:firebase_image/firebase_image.dart';

class CommentTile extends StatefulWidget {
  @override
  _CommentTileState createState() => _CommentTileState();
  final User commentCreator;
  final String comment;

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
