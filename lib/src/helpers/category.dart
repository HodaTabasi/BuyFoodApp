import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';

class CategoryServices {
  String collection = "categories";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<List<CategoryModel>> getCategories() async =>
  //     _firestore.collection(collection).getDocuments().then((result) {
  //       List<CategoryModel> categories = [];
  //       for (DocumentSnapshot category in result.documents) {
  //         categories.add(CategoryModel.fromSnapshot(category));
  //       }
  //       return categories;
  //     });

       Future<List<CategoryModel>> getCategories() async {
         List<CategoryModel> dd =[];
         QuerySnapshot query = await _firestore.collection(collection).get();

           if(query.docs.isNotEmpty){
             query.docs.forEach((element) {
               dd.add(CategoryModel.fromSnapshot(element.data()));
               print("gfh ${dd[0].name}");
             });
           }

           return dd;

         // _firestore.collection(collection).get().then((result) {
         //   print(result);

           // List<CategoryModel> categories = [];
           // for ( DocumentSnapshot category in result.get(collection)) {
           //   categories.add(CategoryModel.fromSnapshot(category));
           // }
           // return categories;
         // });
       }


  //     Future<List<CategoryModel>> getProductCategory(String category) async {
  //   QuerySnapshot query = await _firestore.collection(collection)
  //       .where("category", isEqualTo: category)
  //       .get();
    
  //   if(query.docs.isNotEmpty){
  //     query.docs.forEach((element) {
  //       Categories.add(CategoryModel.fromSnapshot(element.data()));
  //     });
  //   }
  //     return Categories;
  // }
}
