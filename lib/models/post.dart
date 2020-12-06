import 'user.dart';
import 'comment.dart';
import 'dart:io';

class Post {
  File image;
  String description;
  String userId;
  List<User> likes;
  List<Comment> comments;
  DateTime date;
  bool isLiked;

  Post(
      this.image,
      this.userId,
      this.description,
      this.date,
      );
}
