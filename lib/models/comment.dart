class Comment {
  String user;
  String value;
  List<String> upvoters;
  int numOfLikes;
  DateTime dateOfComment;
  Comment(this.user, this.value, this.dateOfComment, this.numOfLikes);
}
