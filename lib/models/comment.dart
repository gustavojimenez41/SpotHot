import 'user.dart';

class Comment {
  String value;
  List<String> upvoters;
  String user;
  String propertyName;
  bool isLiked;
  User currentUser;
  DateTime dateOfComment;
  Comment(this.user, this.value, this.dateOfComment, this.isLiked);
}
