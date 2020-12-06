import 'package:flutter/material.dart';
import 'package:spot_hot/components/search_input.dart';

class SearchNew extends StatefulWidget {
  static const id = "new_search";
  @override
  _SearchNewState createState() => _SearchNewState();
}

class _SearchNewState extends State<SearchNew> {
  @override
  Widget build(BuildContext context) {
    // search
    // "Accounts", "Places"
    //appropriate section
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          children: [
            SearchInput(),
            Text('Cancel'),
          ],
        ),
      ),
    );
  }
}
