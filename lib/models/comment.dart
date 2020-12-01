import 'user.dart';

class Comment {
  String user;
  String value;
  List<String> upvoters;
  String propertyName;
  int numOfLikes;
  User currentUser;
  DateTime dateOfComment;
  Comment(this.user, this.value, this.dateOfComment, this.numOfLikes);
}
