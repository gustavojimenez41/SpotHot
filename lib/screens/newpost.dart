import 'package:flutter/material.dart';

class NewPost extends StatelessWidget {
  String newPostText;

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
                  onPressed: () {
                    //add the task to the list
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
