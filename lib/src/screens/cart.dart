import 'package:flutter/material.dart';
import 'package:foodapplication/src/helpers/order.dart';
import 'package:foodapplication/src/helpers/style.dart';
import 'package:foodapplication/src/helpers/user.dart';
import 'package:foodapplication/src/models/cart_item.dart';
import 'package:foodapplication/src/providers/app.dart';
import 'package:foodapplication/src/providers/user.dart';
import 'package:foodapplication/src/screens/payment.dart';
import 'package:foodapplication/src/widgets/custom_text.dart';
import 'package:foodapplication/src/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../helpers/screen_navigation.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();


  @override
  void initState() {
    // TODO: implement initState
    // getData();
    super.initState();
  }

  getData() async {
    // await UserServices().getCart();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "Shopping Cart"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              user.changeTotal(0);
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: FutureBuilder<List<CartItemModel>>(
          future: UserServices().getCart(context),
          builder: (BuildContext context, AsyncSnapshot<List<CartItemModel>> snapshot) {

            // user.myCart.addAll(snapshot.data);

            // if(snapshot.data.isNotEmpty){
            //   snapshot.data.forEach((element) {
            //     user.changeTotal(int.parse(element.price)*element.quantity);
            //     // total+=int.parse(element.price);
            //     // user.myCart.add(element);
            //   });
            //   // setState(() {
            //   // });
            // }
            // print("${user.total}");

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading....');
              case  ConnectionState.done:
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: white,
                              boxShadow: [
                                BoxShadow(
                                    color: red.withOpacity(0.2),
                                    offset: Offset(3, 2),
                                    blurRadius: 30)
                              ]),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                                child: Image.network(
                                  snapshot.data[index].image,
                                  height: 120,
                                  width: 140,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child: RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: snapshot.data[index].name +
                                                  "\n",
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text:
                                              "${int.parse(snapshot.data[index].price) / 100} OMR \n\n",
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300)),
                                          TextSpan(
                                              text: "Quantity: ",
                                              style: TextStyle(
                                                  color: grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400)),
                                          TextSpan(
                                              text: snapshot.data[index].quantity
                                                  .toString(),
                                              style: TextStyle(
                                                  color: primary,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400)),
                                        ]),
                                      ),
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: red,
                                        ),
                                        onPressed: () async {
                                          app.changeLoading();
                                          bool value = await user.removeFromCart(
                                              cartItem: snapshot.data[index]);
                                          if (value) {
                                            user.reloadUserModel();
                                            print("Item added to cart");
                                            _key.currentState.showSnackBar(SnackBar(
                                                content:
                                                Text("Removed from Cart!")));
                                            app.changeLoading();
                                            return;
                                          } else {
                                            print("ITEM WAS NOT REMOVED");
                                            app.changeLoading();
                                          }
                                        })
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              default:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else
                  return Text('Result: ${snapshot.data}');
            }

          }),
      bottomNavigationBar: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Total: ",
                      style: TextStyle(
                          color: grey,
                          fontSize: 22,
                          fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: "${user.total / 100} OMR",
                      style: TextStyle(
                          color: primary,
                          fontSize: 22,
                          fontWeight: FontWeight.normal)),
                ]),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: primary),
                child: FlatButton(
                    onPressed: () {
                      if (user.total == 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0)), //this right here
                                child: Container(
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Your cart is emty',
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                        return;
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0)), //this right here
                              child: Container(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'You will be charged ${user.total / 100} OMR upon delivery!',
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        width: 320.0,
                                        child: RaisedButton(
                                          onPressed: () async {
                                            // user.total = UserServices.total;
                                            changeScreen(context,PaymentScreen());
                                            // Navigator.push(context, route)
                                            // var uuid = Uuid();
                                            // String id = uuid.v4();
                                            // _orderServices.createOrder(
                                            //     //userId: user.user.uid,
                                            //     id: id,
                                            //     description:
                                            //         "Some random description",
                                            //     status: "complete",
                                            //     totalPrice: user
                                            //         .userModel.totalCartPrice,
                                            //     cart: user.userModel.cart);
                                            // for (CartItemModel cartItem
                                            //     in user.userModel.cart) {
                                            //   bool value =
                                            //       await user.removeFromCart(
                                            //           cartItem: cartItem);
                                            //   if (value) {
                                            //     user.reloadUserModel();
                                            //     print("Item added to cart");
                                            //     _key.currentState.showSnackBar(
                                            //         SnackBar(
                                            //             content: Text(
                                            //                 "Removed from Cart!")));
                                            //   } else {
                                            //     print("ITEM WAS NOT REMOVED");
                                            //   }
                                            // }
                                            // _key.currentState.showSnackBar(
                                            //     SnackBar(
                                            //         content: Text(
                                            //             "Order created!")));
                                            // Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Accept",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          color: const Color(0xFF1BC0C5),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 320.0,
                                        child: RaisedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Reject",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: red),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: CustomText(
                      text: "Check out",
                      size: 20,
                      color: white,
                      weight: FontWeight.normal,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    // UserServices.total = 0;
    super.dispose();
  }
}
