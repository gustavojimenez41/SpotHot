import 'package:flutter/material.dart';
import 'package:spot_hot/constants.dart';

class SearchInput extends StatefulWidget {
  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  String search;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
          keyboardType: TextInputType.emailAddress,
          textAlign: TextAlign.start,
          onChanged: (value) {
            search = value;
          },
          decoration: kTextFieldDecoration.copyWith(hintText: "Search")),
    );
  }
}
