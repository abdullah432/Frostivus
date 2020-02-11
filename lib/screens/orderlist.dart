import 'package:flutter/material.dart';
import 'package:frostivus/models/order.dart';
import 'package:frostivus/screens/orderdetail.dart';
import 'package:frostivus/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  //
  TextEditingController cupController = TextEditingController();
  TextEditingController spoonController = TextEditingController();
  FocusNode focusNodeCups;
  FocusNode focusNodeSpoons;
  String currentNote;
  //Inventory Data
  String totalcups;
  String totalspoons;
  int cups;
  int spoons;

  @override
  void initState() {
    focusNodeCups = new FocusNode();
    // listen to focus changes
    focusNodeCups.addListener(
        () => print('focusNode updated: hasFocus: ${focusNodeCups.hasFocus}'));

    focusNodeSpoons = new FocusNode();
    // listen to focus changes
    focusNodeSpoons.addListener(() =>
        print('focusNode updated: hasFocus: ${focusNodeSpoons.hasFocus}'));

    //get spoons and cups data
    loadSpoonAndCupsData();

    super.initState();
  }

  void setFocus() {
    FocusScope.of(context).requestFocus(focusNodeCups);
  }

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
      drawer: drawerWidget(),
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
            title: Text(
                'Order No ' + this.orderList[position].orderNo.toString(),
                style: titleStyle),
            subtitle: Text(this.orderList[position].flavor),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                deleteNote(context, this.orderList[position].id);
                updateOrderList();
              },
            ),
            onTap: () {
              navigateToDetail(this.orderList[position], 'Edit Order');
            },
          ),
        );
      },
    );
  }

  void navigateToDetail(Order order, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrderDetail(order, title);
    }));

    if (result) {
      updateOrderList();
      setState(() {
        loadSpoonAndCupsData();
      });
    }
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

  drawerWidget() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
              height: 85,
              child: DrawerHeader(
                child: Text(
                  'Inventory',
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              )),
          ListTile(
            leading: Text('Cups: ', style: TextStyle(fontSize: 18.0)),
            title: EditableText(
              textAlign: TextAlign.start,
              maxLines: null,
              focusNode: focusNodeCups,
              controller: cupController,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
              keyboardType: TextInputType.number,
              cursorColor: Colors.blue,
              backgroundCursorColor: Colors.blue,
              onSubmitted: (value) {
                updateCupsData();
              },
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Text(
              'Spoons: ',
              style: TextStyle(fontSize: 18.0),
            ),
            title: EditableText(
              textAlign: TextAlign.start,
              maxLines: null,
              focusNode: focusNodeSpoons,
              controller: spoonController,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
              keyboardType: TextInputType.number,
              cursorColor: Colors.blue,
              backgroundCursorColor: Colors.blue,
              onSubmitted: (value) {
                updateSpoonsData();
              },
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }

  void updateCupsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('totalcups', int.parse(cupController.text));
  }

  void updateSpoonsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('totalspoons', int.parse(spoonController.text));
  }

  void loadSpoonAndCupsData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    cups = pref.getInt('totalcups') ?? 50;
    spoons = pref.getInt('totalspoons') ?? 50;

    cupController.text = cups.toString();
    spoonController.text = spoons.toString();
  }
}
