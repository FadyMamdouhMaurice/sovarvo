import 'package:Sovarvo/modules/realtime_firebase/users.dart';
import 'package:Sovarvo/shared/my_theme.dart';
import 'package:flutter/material.dart';

class VideoGamesOrdersScreen extends StatefulWidget {
  @override
  _VideoGamesOrdersScreenState createState() => _VideoGamesOrdersScreenState();
}

class _VideoGamesOrdersScreenState extends State<VideoGamesOrdersScreen> {
  late Future<List<Map<String, dynamic>>> ordersFuture;

  @override
  void initState() {
    super.initState();
    ordersFuture = getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found.'));
          } else {
            List<Map<String, dynamic>> orderList = snapshot.data!;
            return ListView.builder(
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                var order = orderList[index];
                var customerInfo = order['customerInfo'] as Map<dynamic, dynamic>;
                var cartItems = order['cartItems'] as List<dynamic>;
                DateTime requestedTime = order['requestedTime'] as DateTime;

                return Card(
                  color: MyThemeData.primaryColor,
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Order ID: ${order['orderId']}', style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Customer Name: ${customerInfo['Name']}', style: TextStyle(
                          color: Colors.white,
                        )),
                        Text('Customer Email: ${customerInfo['E-Mail']}', style: TextStyle(
                          color: Colors.white,
                        )),
                        Text('Customer Phone: ${customerInfo['Phone']}', style: TextStyle(
                          color: Colors.white,
                        )),
                        Text('Customer Company: ${customerInfo['Company']}', style: TextStyle(
                          color: Colors.white,
                        )),
                        Text('Customer Code: ${customerInfo['Code']}', style: TextStyle(
                          color: Colors.white,
                        )),
                        Text('Total Price: \$${order['totalPrice']}', style: TextStyle(
                          color: Colors.white,
                        )),
                        Text('Delivery Type: ${order['deliveryType']}', style: TextStyle(
                          color: Colors.white,
                        )),
                        Text('Selected Address: ${order['selectedAddress']}', style: TextStyle(
                          color: Colors.white,
                        )),
                        Text('Selected Way: ${order['selectedWay']}', style: TextStyle(
                          color: Colors.white,
                        )),
                        Text('Cart Items: ${cartItems.map((item) => '${item['name']} (x${item['selectedCount']})').join(', ')}', style: TextStyle(
                          color: Colors.white,
                        )),
                        Text('Requested Time: ${requestedTime.toLocal().toString()}', style: TextStyle(
                          color: Colors.white,
                        )),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}