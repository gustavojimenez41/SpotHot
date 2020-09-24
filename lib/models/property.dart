import 'package:flutter/material.dart';
import 'comment.dart';

class Property {
  String name;
  PropertyType propertyType;
  double latitude;
  double longitude;
  List<Image> images;
  List<Comment> comments;

  Property() {}
}

enum PropertyType {
  boatsAndTours,
  funAndGames,
  nature,
  landmarks,
  foodAndDrinks,
  shopping,
  zoos,
  museums,
  outdoors,
  wellness,
  amusementParks,
  nightlife,
  casinos,
}
