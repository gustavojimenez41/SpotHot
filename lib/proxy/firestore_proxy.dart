import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:spot_hot/models/comment.dart';
import 'package:spot_hot/models/user.dart';
import 'package:spot_hot/models/property.dart';
import 'package:firebase_core/firebase_core.dart';

Future<User> getUserByUUID(String uuid) async {
  final _firestore = firestore.FirebaseFirestore.instance;
  Map<String, dynamic> userInfo = await _firestore
      .collection('users')
      .limit(1)
      .where('uuid', isEqualTo: uuid)
      .get()
      .then((value) => value.docs.first.data());
  User user = User(
      userInfo['first_name'],
      userInfo['last_name'],
      userInfo['bio'],
      userInfo['uuid'],
      userInfo['username'],
      List<String>.from(userInfo['following']),
      List<String>.from(userInfo['followers']),
      userInfo['user_profile_picture']);

  return user;
}

//TODO: fix this
Future<List<Property>> getNearestProperties() async {
  //currently mock db call
  List<Property> ans = [];
  Property prop =
      Property("Chamoy", PropertyType.foodAndDrinks, 35.11, 42.11, [], []);
  ans.add(prop);
  ans.add(prop);
  ans.add(prop);
  ans.add(prop);
  ans.add(prop);
  ans.add(prop);
  ans.add(prop);
  ans.add(prop);
  ans.add(prop);
  return ans;
}

Future<void> createUserPost(String userId, String description,
    String dateTimeStamp, String pictureStorageLocation) {
  firestore.FirebaseFirestore afirestore = firestore.FirebaseFirestore.instance;
  firestore.CollectionReference userPosts = afirestore.collection('user_posts');

  //create new user post
  return userPosts
      .doc()
      .set({
        'comments': [],
        'date': dateTimeStamp,
        'description': description,
        'image':
            pictureStorageLocation, // image location, updated after image is uploaded
        'likes': [], //list if user_ids length of array for likes
        'user_id': userId, //use id of the original poster
      })
      .then((value) => print("post uploaded"))
      .catchError((error) => print("Failed to upload post: $error"));
}

Future<void> createProperty(
    String propertyName, firestore.GeoPoint geoPoint, int propertyType) async {
  firestore.FirebaseFirestore afirestore = firestore.FirebaseFirestore.instance;
  firestore.CollectionReference property = afirestore.collection('property');

  //create new property
  property
      .doc()
      .set({
        'comments': [],
        'location': geoPoint,
        'name': propertyName,
        'property_type': propertyType,
      })
      .then((value) => print("property uploaded"))
      .catchError((error) => print("Failed to upload property: $error"));
}

Future<List> getCommentsOnPropertyOrPost(
    String collectionToRetrieve, String uuid) async {
  //collectionToRetrieve is either 'property' or 'user_posts'
  final _firestore = firestore.FirebaseFirestore.instance;
  Map<String, dynamic> allComments = await _firestore
      .collection(collectionToRetrieve)
      .doc(uuid)
      .get()
      .then((value) => value.data());
  print(allComments['comments']);
  return allComments['comments'];
}

//TODO: ensure function works
Future<void> uploadCommentToProperty(
    String propertyUUID, String userUUID, String comment) {
  //String commentToUpload, String postUUID, String userUUID
  firestore.CollectionReference posts =
      firestore.FirebaseFirestore.instance.collection('property');
  return posts
      .doc(propertyUUID)
      .update({
        'comments': firestore.FieldValue.arrayUnion([
          {
            'dateOfComment': DateTime.now().toString(),
            'upVoters': [],
            'user': userUUID,
            'value': comment,
          }
        ])
      })
      .then((value) => print("post replied!"))
      .catchError((error) => print("Failed to replied post: $error"));
}

Future<void> uploadCommentToPost(String postID, String userID, String comment) {
  //String commentToUpload, String postUUID, String userUUID
  firestore.CollectionReference posts =
      firestore.FirebaseFirestore.instance.collection('user_posts');
  return posts
      .doc(postID)
      .update({
        'comments': firestore.FieldValue.arrayUnion([
          {
            'dateOfComment': DateTime.now().toString(),
            'upVoters': [],
            'user': userID,
            'value': comment,
          }
        ])
      })
      .then((value) => print("post replied!"))
      .catchError((error) => print("Failed to replied post: $error"));
}

Future<void> likeComment() async {}

//method to like post - adds the user's id to the liked posts array. Increments the count.
Future<void> likePost(String documentUUID, String postCreatorUUID) {
  firestore.CollectionReference posts =
      firestore.FirebaseFirestore.instance.collection('user_posts');
  return posts
      .doc(documentUUID)
      .update({
        'likes': firestore.FieldValue.arrayUnion([postCreatorUUID])
      })
      .then((value) => print("post liked!"))
      .catchError((error) => print("Failed to like post: $error"));
}

// //method to unlike post - removes the user's id to the liked posts array. Decrements the count.
Future<void> unLikePost(String documentID, String postCreatorUUID) {
  firestore.CollectionReference posts =
      firestore.FirebaseFirestore.instance.collection('user_posts');
  return posts
      .doc(documentID)
      .update({
        'likes': firestore.FieldValue.arrayRemove([postCreatorUUID])
      })
      .then((value) => print("post unliked!"))
      .catchError((error) => print("Failed to unlike post: $error"));
}

//method to add searched user to current logged in user's following list
Future<void> followUser(String loggedinUserUUID, String followingUserUUID) {
  firestore.CollectionReference posts =
      firestore.FirebaseFirestore.instance.collection('users');

  return posts
      .doc(loggedinUserUUID)
      .update({
        'following': firestore.FieldValue.arrayUnion([followingUserUUID])
      })
      .then((value) => print("following user: $followingUserUUID!"))
      .catchError((error) => print("Failed to follow user: $error"));
}

//method to add current logged in user to the searched user's follower's list
Future<void> addFollower(String loggedinUserUUID, String followingUserUUID) {
  firestore.CollectionReference posts =
      firestore.FirebaseFirestore.instance.collection('users');

  return posts
      .doc(followingUserUUID)
      .update({
        'followers': firestore.FieldValue.arrayUnion([loggedinUserUUID])
      })
      .then((value) => print(
          "Current logged in user: $loggedinUserUUID added to user: $followingUserUUID's followers list!"))
      .catchError((error) => print(
          "Failed to add current logged on user to follower list: $error"));
}

//method to remove the searched user from the current logged in user's following list
Future<void> unfollowUser(String loggedinUserUUID, String followingUserUUID) {
  firestore.CollectionReference posts =
      firestore.FirebaseFirestore.instance.collection('users');

  return posts
      .doc(loggedinUserUUID)
      .update({
        'following': firestore.FieldValue.arrayRemove([followingUserUUID])
      })
      .then((value) => print(
          "User: $followingUserUUID removed from current user: $loggedinUserUUID's followers list!"))
      .catchError((error) => print(
          "Failed to remove $followingUserUUID from follower's list: $error"));
}

//method to remove the current logged in user from the searched user's followers list.
Future<void> removeFollower(String loggedinUserUUID, String followingUserUUID) {
  firestore.CollectionReference posts =
      firestore.FirebaseFirestore.instance.collection('users');

  return posts
      .doc(followingUserUUID)
      .update({
        'followers': firestore.FieldValue.arrayRemove([loggedinUserUUID])
      })
      .then((value) => print(
          "Current logged in user: $loggedinUserUUID removed from user: $followingUserUUID's followers list!"))
      .catchError((error) => print(
          "Failed to remove current logged on user from follower's list: $error"));
}

Future<List> getUsers() async {
  final _firestore = firestore.FirebaseFirestore.instance;

  List<User> listOfUsers = [];

  var Users = await _firestore.collection('users').get().then((value) => {
        value.docs.forEach((element) {
          //create user object with user data
          final user = User(
              element['first_name'],
              element['last_name'],
              element['bio'],
              element['uuid'],
              element['username'],
              List<String>.from(element['following']),
              List<String>.from(element['followers']),
              element['user_profile_picture']);

          //append user to the list of users
          listOfUsers.add(user);
        })
      });

  return listOfUsers;
}
