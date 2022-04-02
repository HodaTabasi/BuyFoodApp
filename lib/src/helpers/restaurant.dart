import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant.dart';

class RestaurantServices {
  String collection = "restaurants";
 FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RestaurantModel>> getRestaurants() async {
    List<RestaurantModel> dd =[];
    QuerySnapshot query = await _firestore.collection(collection).get();

    if(query.docs.isNotEmpty){
      query.docs.forEach((element) {
        dd.add(RestaurantModel.fromSnapshot(element.data()));
        print("gfhxcs ${dd[0].name}");
      });
    }

    return dd;
    //_firestore.collection(collection).doc().get().then((result) {
      //   List<RestaurantModel> restaurants = [];
      //   for (DocumentSnapshot restaurant in result.get(collection)) {
      //     restaurants.add(RestaurantModel.fromSnapshot(restaurant));
      //   }
      //   return restaurants;
      // });
  }

  Future<RestaurantModel> getRestaurantById({String id}){
    print(id);
    _firestore
        .collection(collection)
        .doc(id.toString())
        .get()
        .then((doc) {
      return RestaurantModel.fromSnapshot(doc);
    });
  }

  Future<List<RestaurantModel>> searchRestaurant({String restaurantName}) {
    // code to convert the first character to uppercase
    String searchKey =
        restaurantName[0].toUpperCase() + restaurantName.substring(1);
    return _firestore
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .get()
        .then((result) {
          List<RestaurantModel> restaurants = [];
          for (DocumentSnapshot product in result.docs) {
            restaurants.add(RestaurantModel.fromSnapshot(product));
          }
          return restaurants;
        });
  }
}
