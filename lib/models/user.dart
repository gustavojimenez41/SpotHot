import 'package:flutter/material.dart';

class User {
  String firstName;
  String lastName;
  Image profilePicture;
  String bio;
  String uuid;
  List<String> following;
  List<String> followers;

  User(this.firstName, this.lastName, this.bio, this.uuid, this.following,
      this.followers);
}
