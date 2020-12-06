import 'package:flutter/material.dart';

class User {
  String firstName;
  String lastName;
  Image profilePicture;
  String bio;
  String uuid;
  List<String> following;
  List<String> followers;
  String userName;
  String userProfilePictureLocation;

  User(this.firstName, this.lastName, this.bio, this.uuid, this.userName,
      this.following, this.followers, this.userProfilePictureLocation) {}
}
