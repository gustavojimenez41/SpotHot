import 'package:flutter/material.dart';

class User {
  String firstName;
  String lastName;
  Image profilePicture;
  String bio;
  String uuid;
  List<String> following;
  List<String> followers;
  String user_profile_picture;

  User(this.firstName, this.lastName, this.bio, this.uuid, this.following,
      this.followers, this.user_profile_picture) {}
}
