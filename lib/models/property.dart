import 'package:flutter/material.dart';
import 'comment.dart';

class Property {
  String name;
  PropertyType propertyType;
  double latitude;
  double longitude;
  List<Image> images;
  List<Comment> comments;

  Property(this.name, this.propertyType, this.latitude, this.longitude,
      this.images, this.comments) {}
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
