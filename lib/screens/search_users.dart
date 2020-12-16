import 'package:flutter/material.dart';
import 'package:spot_hot/proxy/firestore_proxy.dart';
import 'package:spot_hot/models/user.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:spot_hot/screens/searched_user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class SearchUsers extends StatefulWidget {
  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  var allUsers = [];
  final _auth = auth.FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF935252),
      appBar: AppBar(
        backgroundColor: Color(0xFF935252),
        title: Text("Search Users"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              List<User> users = await getUsers();
              //remove the current logged on user's name from the list of users to search
              users.removeWhere(
                  (element) => element.uuid == _auth.currentUser.uid);
              allUsers = users;
              showSearch(context: context, delegate: DataSearch(allUsers));
            },
          ),
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  List<User> allUsers = [];

  DataSearch(this.allUsers) {
    print("all users:");
    for (var u in allUsers) {
      print(u.userName);
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    //actions for app bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    //leading icon on the left of the appbar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    //leading icon on the left of the appbar
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    List<User> suggestionList = allUsers
        .where((element) => element.userName.toLowerCase().startsWith(query))
        .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          //TODO handle when a user clicks on a user they searched for (take to other user's profile)
          print(
              "You tapped on : ${suggestionList[index].userName} with userId: ${suggestionList[index].uuid}");

          //open the user's profile
          var route = new MaterialPageRoute(
            builder: (BuildContext context) =>
                new SearchedUserProfile(suggestionList[index].uuid),
          );

          Navigator.of(context).push(route);
        },
        leading: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black26,
              width: 1.0,
            ),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: FirebaseImage(
                  suggestionList[index].userProfilePictureLocation),
            ),
          ),
        ),
        title: Text(suggestionList[index].userName),
      ),
      itemCount: suggestionList.length,
    );
  }
}
