import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  static const ID = "id";
  static const NAME = "name";
  static const AVG_PRICE = "avgPrice";
  static const RATING = "rating";
  static const RATES = "rates";
  static const IMAGE = "image";
  static const POPULAR = "popular";
  static const USER_LIKES = "userLikes";

  String _id;
  String _name;
  String _image;
  List<String> _userLikes;
  double _rating;
  var _avgPrice;
  bool _popular;
  int _rates;

//  getters
  String get id => _id;

  String get name => _name;

  String get image => _image;

  List<String> get userLikes => _userLikes;

  get avgPrice => _avgPrice;

  double get rating => _rating;

  bool get popular => _popular;

  int get rates => _rates;

  // public variable
  bool liked = false;

  RestaurantModel.fromSnapshot(dynamic snapshot) {
    _id = snapshot['id'];
    _name = snapshot['name'];
    _image = snapshot['image'];
    _avgPrice = snapshot['avgPrice'];
    _rating = snapshot['rating'];
    _popular = snapshot['popular'];
    _rates = snapshot['rates'];
  }
}
