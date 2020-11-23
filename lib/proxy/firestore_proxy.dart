import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:spot_hot/models/user.dart';

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
