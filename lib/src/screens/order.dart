import 'package:flutter/material.dart';
import 'package:foodapplication/src/helpers/order.dart';
import 'package:foodapplication/src/helpers/style.dart';
import 'package:foodapplication/src/models/order.dart';
import 'package:foodapplication/src/providers/app.dart';
import 'package:foodapplication/src/providers/user.dart';
import 'package:foodapplication/src/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<OrderModel> orders;
  bool isLoading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    orders = await OrderServices().getUserOrders();
    print(orders.length);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "Orders"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: isLoading
          ? Text('Loading....')
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: CustomText(
                    text: "\$${orders[index].total / 100}",
                    weight: FontWeight.bold,
                  ),
                  title: Text(orders[index].description),
                  subtitle: Text(DateTime.fromMillisecondsSinceEpoch(
                          orders[index].createdAt)
                      .toString()),
                  trailing: CustomText(
                    text: orders[index].status,
                    color: green,
                  ),
                );
              }),
    );
  }
}
