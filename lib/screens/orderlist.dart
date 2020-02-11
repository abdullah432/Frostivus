import 'package:flutter/material.dart';
import 'package:frostivus/models/order.dart';
import 'package:frostivus/screens/orderdetail.dart';
import 'package:frostivus/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class OrderList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OrderListState();
  }
}

class OrderListState extends State<OrderList> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List<Order> orderList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (orderList == null) {
      orderList = new List<Order>();
      updateOrderList();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'AddOrder',
        child: Icon(Icons.add),
        onPressed: () {
          debugPrint("Add");
          navigateToDetail(Order(-1, '', '', 1, 1), 'Add Order');
        },
      ),
      appBar: AppBar(title: Text('Orders')),
      body: getOrderList(),
    );
  }

  ListView getOrderList() {
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text('Order No '+this.orderList[position].orderNo.toString(), style: titleStyle),
            subtitle: Text(this.orderList[position].flavor),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                deleteNote(context, this.orderList[position].id);
                updateOrderList();
              },
            ),
            onTap: () {
              navigateToDetail(this.orderList[position], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  void navigateToDetail(Order order, String title) async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrderDetail(order, title);
    }));

    if (result)
      updateOrderList();
  }

  void deleteNote(BuildContext context, int id) async {
    int result = await databaseHelper.deleteOrder(id);
    if (result != 0) {
      showSnackBar(context, 'Order is successfully Deleted');
    }
  }

  void showSnackBar(context, msg) {
    SnackBar snackbar = SnackBar(content: Text(msg));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void updateOrderList() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Order>> noteListFuture = databaseHelper.getOrderList();
      noteListFuture.then((orderList) {
        setState(() {
          this.orderList = orderList;
          this.count = orderList.length;
        });
      });
    });
  }
}
