import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  static const ID = "id";
  static const NAME = "name";
  static const IMAGE = "image";

  String _id;
  String _name;
  String _image;

  //  getters
  String get id => _id;

  String get name => _name;

  String get image => _image;

  CategoryModel.fromSnapshot(dynamic snapshot) {
    _id = snapshot['id'];
    _name = snapshot['name'];
    _image = snapshot['image'];
  }
}
