import 'package:http/http.dart' as http;
import '../models/place_model.dart';
import 'dart:async';
import 'dart:convert';

class LocationService {
  static final _locationService = new LocationService();

  static LocationService get() {
    return _locationService;
  }

  final String url =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=32.7297,-97.1129&radius=1500&key=AIzaSyBUILBxCa5yyQZawAAOpD6HII48R3haimM";

//  Future<List<Place>> getNearbyPlaces() async {
//    var reponse = await http.get(url, headers: {"Accept": "application/json"});
//    var places = <Place>[];
//
//    List data = json.decode(reponse.body)["results"];
//
//    data.forEach((f) => places.add(new Place(f["place_id"], f["name"],
//        f["icon"], f["rating"].toString(), f["vicinity"])));
//    return places;
//  }

//  Future getPlace(String place_id) async {
//    var response = await http
//        .get(detailUrl + place_id, headers: {"Accept": "application/json"});
//    var result = json.decode(response.body)["result"];
//
//    List<String> weekdays = [];
//    if (result["opening_hours"] != null)
//      weekdays = result["opening_hours"]["weekday_text"];
//    return new PlaceDetail(
//        result["place_id"],
//        result["name"],
//        result["icon"],
//        result["rating"].toString(),
//        result["vicinity"],
//        result["formatted_address"],
//        result["international_phone_number"],
//        weekdays);
//  }
//reviews.map((f)=> new Review.fromMap(f)).toList()
}
