import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:foodapplication/src/helpers/shared_prefrences_helper.dart';
import 'package:foodapplication/src/models/cart_item.dart';
import 'package:foodapplication/src/models/user.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';

class UserServices {
  String collection = "users";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static double total = 0.0;

  void createUser(Map<String, dynamic> values) {
    String id = values["id"];
    _firestore.collection(collection).doc(id).set(values);
  }

  void updateUserData(Map<String, dynamic> values) {
    _firestore.collection(collection).doc(values['id']).update(values);
  }

  void addToCart({String userId, CartItemModel cartItem }) {
    print("THE USER ID IS: $userId");
    print("cart items are: ${cartItem.toString()}");
    _firestore.collection(collection).doc(userId).update({
      "cart": FieldValue.arrayUnion([cartItem.toMap()])
    });
  }

  void removeFromCart({String userId, CartItemModel cartItem}) {
    print("THE USER ID IS: $userId");
    print("cart items are: ${cartItem.toString()}");
    _firestore.collection("cart").doc(cartItem.id).delete();
  }

  Future<List<CartItemModel>> getCart(BuildContext context) async {
    List<CartItemModel> dd = [];
    QuerySnapshot query = await _firestore.collection("cart").where(
      "userId", isEqualTo: SharedPrefrencesHelper.sharedPrefrencesHelper.getData("token")).get();

    if (query.docs.isNotEmpty) {
      query.docs.forEach((element) {
        CartItemModel cart = CartItemModel.fromMap(element.data());
        dd.add(cart);
        print("gfh ${dd[0].name}");
        total +=(int.parse(cart.price)*cart.quantity);
        // Provider.of<UserProvider>(context).changeTotal(int.parse(cart.price)*cart.quantity);
      });

      // print("fffff ${total}");
    }

    return dd;
  }

  Future<UserModel> getUserById(String id) =>
      _firestore.collection(collection).doc(id).get().then((doc) {
        return UserModel.fromSnapshot(doc);
      });
}
