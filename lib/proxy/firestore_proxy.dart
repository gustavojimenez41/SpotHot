import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:spot_hot/models/user.dart';
import 'package:spot_hot/models/property.dart';

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
      List<String>.from(userInfo['following']),
      List<String>.from(userInfo['followers']));
  return user;
}

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
