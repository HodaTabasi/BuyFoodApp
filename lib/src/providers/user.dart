import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodapplication/src/helpers/order.dart';
import 'package:foodapplication/src/helpers/user.dart';
import 'package:foodapplication/src/models/cart_item.dart';
import 'package:foodapplication/src/models/order.dart';
import 'package:foodapplication/src/models/products.dart';
import 'package:foodapplication/src/models/user.dart';
import 'package:uuid/uuid.dart';

import '../helpers/shared_prefrences_helper.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseAuth _user;
  Status _status = Status.Uninitialized;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserServices _userServicse = UserServices();
  OrderServices _orderServices = OrderServices();
  UserModel _userModel;
  int total = 0;
  List<CartItemModel> myCart = [] ;

//  getter
  UserModel get userModel => _userModel;
  Status get status => _status;
  FirebaseAuth get user => _user;

  // public variables
  List<OrderModel> orders = [];

  void changeTotal(num value){
    total+=value;
    // notifyListeners();
  }

  final formkey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
  //_auth.authStateChanges().listen(_onStateChanged);
  }

  Future<bool> signIn() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim()).then((value) {
            print(value.user.uid);
        SharedPrefrencesHelper.sharedPrefrencesHelper.setData("token", value.user.uid);
            _firestore.collection('users').doc(value.user.uid).get().then((value){
              SharedPrefrencesHelper.sharedPrefrencesHelper.setData("name", value.data()['name']);
              SharedPrefrencesHelper.sharedPrefrencesHelper.setData("email", value.data()['email']);
            });

      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) {
            print(result.user.email);
        _firestore.collection('users').doc(result.user.uid).set({
          'name': name.text,
          'email': email.text,
          'uid': result.user.uid,
          "likedFood": [],
          "likedRestaurants": []
        }).then((value) {
          SharedPrefrencesHelper.sharedPrefrencesHelper.setData("token", result.user.uid);
          SharedPrefrencesHelper.sharedPrefrencesHelper.setData("name", name.text);
          SharedPrefrencesHelper.sharedPrefrencesHelper.setData("email", email.text);
        });
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void clearController() {
    name.text = "";
    password.text = "";
    email.text = "";
  }

  Future<void> reloadUserModel() async {
        //_userModel = await _userServicse.getUserById(user.uid);
    notifyListeners();
  }

  Future<void> _onStateChanged(FirebaseAuth firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
      //_userModel = await _userServicse.getUserById(user.uid);
    }
    notifyListeners();
  }

  Future<bool> addToCard({ProductModel product, int quantity,context}) async {
    print("THE PRODUC IS: ${product.toString()}");
    print("THE qty IS: ${quantity.toString()}");
    try {
      // var uuid = Uuid();
      // String cartItemId = uuid.v4();
      // List cart = _userModel.cart;
//      bool itemExists = false;

      DocumentReference ref = await _firestore.collection("cart").doc();
      Map<String,dynamic> cartItem = {
        "id": ref.id,
        "name": product.name,
        "image": product.image,
        "restaurantId": product.restaurantId,
        "totalRestaurantSale": int.parse(product.price) * quantity,
        "productId": product.id,
        "price": product.price,
        "quantity": quantity,
        "userId": SharedPrefrencesHelper.sharedPrefrencesHelper.getData("token")
    };
      print("ewprk ${cartItem}");
      var price = int.parse(cartItem['price'])*cartItem['quantity'];
      changeTotal(price);
      // CartItemModel item = CartItemModel.(cartItem);
    ref.set(cartItem).then((value) => true);



      return true;
      // CartItemModel item = CartItemModel.fromMap(cartItem);
//      if(!itemExists){
//       print("CART ITEMS ARE: ${cart.toString()}");
     // _userServicse.addToCart(userId: _user.uid, cartItem: item);
//      }

      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  getOrders() async {
   orders = await _orderServices.getUserOrders();

    notifyListeners();
  }

  Future<bool> removeFromCart({CartItemModel cartItem}) async {
    print("THE PRODUC IS: ${cartItem.toString()}");

    try {
     _userServicse.removeFromCart(cartItem: cartItem);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }
}
