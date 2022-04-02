import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodapplication/src/helpers/shared_prefrences_helper.dart';
import 'package:foodapplication/src/models/cart_item.dart';
import 'package:foodapplication/src/models/order.dart';

class OrderServices {
  String collection = "orders";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createOrder(
      {String userId,
      String id,
      String description,
      String status,
      List<CartItemModel> cart,
      int totalPrice}) {
    List<Map> convertedCart = [];
    List<String> restaurantIds = [];

    for (CartItemModel item in cart) {
      convertedCart.add(item.toMap());
      restaurantIds.add(item.restaurantId);
    }
    DocumentReference ref = _firestore.collection(collection).doc();
    var tid = ref.id;
    ref.set({
      "userId": userId,
      "id": tid,
      "restaurantIds": restaurantIds,
      "cart": convertedCart,
      "total": totalPrice,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "description": description,
      "status": status
    });
  }

  Future<List<OrderModel>> getUserOrders({String userId}) async {
    print(SharedPrefrencesHelper.sharedPrefrencesHelper.getData("token"));
    List<OrderModel> dd = [];
    QuerySnapshot query = await _firestore.collection("orders").where(
        "userId", isEqualTo: SharedPrefrencesHelper.sharedPrefrencesHelper.getData("token")).get();

    if (query.docs.isNotEmpty) {
      query.docs.forEach((element) {
        dd.add(OrderModel.fromSnapshot(element.data()));
        print("gfh ${dd[0].total}");
      });
    }

    return dd;

  }
  // _firestore
  //         .collection(collection)
  //         .where("userId", isEqualTo: userId)
  //         .get()
  //         .then((result) {
  //       List<OrderModel> orders = [];
  //       for (DocumentSnapshot order in result.docs) {
  //         orders.add(OrderModel.fromSnapshot(order));
  //       }
  //       return orders;
  //     });
}
