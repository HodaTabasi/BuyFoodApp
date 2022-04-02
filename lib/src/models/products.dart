import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  static const ID = "id";
  static const NAME = "name";
  static const RATING = "rating";
  static const IMAGE = "image";
  static const PRICE = "price";
  static const RESTAURANT_ID = "restaurantId";
  static const RESTAURANT = "restaurant";
  static const DESCRIPTION = "description";
  static const CATEGORY = "category";
  static const FEATURED = "featured";
  static const RATES = "rates";
  static const USER_LIKES = "userLikes";

  var _id;
  String _name;
  String _restaurantId;
  String _restaurant;
  String _category;
  String _image;
  String _description;

  var _rating;
  var _price;
  var _rates;

  bool _featured;

  get id => _id;

  String get name => _name;

  String get restaurant => _restaurant;

  String get restaurantId => _restaurantId;

  String get category => _category;

  String get description => _description;

  String get image => _image;

  get rating => _rating;

  get price => _price;

  bool get featured => _featured;

  get rates => _rates;

  // public variable
  bool liked = false;

  ProductModel.fromSnapshot(dynamic snapshot) {
    _id = snapshot[ID];
    _image = snapshot[IMAGE];
    _restaurant = snapshot[RESTAURANT];
    _restaurantId = snapshot[RESTAURANT_ID];
    _description = snapshot[DESCRIPTION];
    // _id = snapshot.data()['ID'];
    // _featured = snapshot.data()['FEATURED'];
    _price = snapshot[PRICE];
    _category = snapshot[CATEGORY];
    _rating = snapshot[RATING];
    _rates = snapshot[RATES];
    _name = snapshot[NAME];
  }
}
