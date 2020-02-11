import 'package:flutter/material.dart';
import 'package:frostivus/models/order.dart';
import 'package:frostivus/utils/database_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Frostivus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Frostivus'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var flavorArray = ['Strawberry', 'Chocolate', 'Mango'];
  var toppingArray = ['Chocolate', 'Sprinkle', 'Marshmallow'];
  String selectedFlavor = 'Strawberry';
  String selectedTopping = 'Marshmallow';
  //Order Data
  Order order = new Order.empty();
  TextEditingController orderNoController = new TextEditingController();
  TextEditingController totalController = new TextEditingController();
  TextEditingController changeController = new TextEditingController();
  //databasehelper
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(child: Column(
            children: <Widget>[
              TextField(
                controller: orderNoController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Order NO'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  debugPrint('ordertestbefore');
                  debugPrint(orderNoController.text);
                  this.order.orderNo = int.parse(orderNoController.text);
                  debugPrint('ordertestafter');
                },
              ),
              flavorWidget(),
              toppingsWidget(),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: totalController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Total'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    this.order.total = int.parse(totalController.text);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: changeController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Change'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    this.order.change = int.parse(changeController.text);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 3,
                        bottom: 3,
                        left: 7,
                        right: 7,
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    onPressed: () {
                      saveData();
                    },
                  ),
                ),
              ),
            ],
          ),
        )));
  }

  flavorWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Align(
          alignment: Alignment.topLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Flavor',
                style: TextStyle(fontSize: 20),
              ),
              DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                items: flavorArray.map((String dropDownStringItem) {
                  return DropdownMenuItem(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                onChanged: (String value) {
                  setState(() {
                    selectedFlavor = value;
                  });
                },
                value: selectedFlavor,
              )),
            ],
          )),
    );
  }

  toppingsWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Align(
          alignment: Alignment.topLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Toppings',
                style: TextStyle(fontSize: 20),
              ),
              DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                items: toppingArray.map((String dropDownStringItem) {
                  return DropdownMenuItem(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                onChanged: (String value) {
                  setState(() {
                    selectedTopping = value;
                  });
                },
                value: selectedTopping,
              )),
            ],
          )),
    );
  }

  void saveData() async {
    this.order.flavor = selectedFlavor;
    this.order.topping = selectedTopping;

    // Order existingOrder = await databaseHelper.getExistingOrder(this.order.orderNo);
    
    
    int result;
    result = await databaseHelper.insertOrder(order);
    // if (existingOrder.orderNo != null ) {
    //   this.order.id = existingOrder.id;
    //   debugPrint("update");
    //   result = await databaseHelper.updateOrder(order);
    // } else {
    //   result = await databaseHelper.insertOrder(order);
    //   debugPrint("insert");
    // }

    if (result != 0) {
      showAlertDialog('Status', 'Order Added Successfully');
    } else {
      showAlertDialog('Status', 'Fail to Saved');
    }
  }

  void showAlertDialog(String title, String msg) {
    AlertDialog alertDialog =
        AlertDialog(title: Text(title), content: Text(msg));
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
