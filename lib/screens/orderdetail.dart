import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frostivus/models/order.dart';
import 'package:frostivus/utils/database_helper.dart';

class OrderDetail extends StatefulWidget {
  final String appBarTitle;
  final Order order;
  OrderDetail(this.order, this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return OrderDetailState(order, appBarTitle);
  }
}

class OrderDetailState extends State<OrderDetail> {
  String appBarTitle;
  Order order;
  OrderDetailState(this.order, this.appBarTitle);
  DatabaseHelper databaseHelper = DatabaseHelper();
  //OrderDetail Data
  var flavorArray = ['Strawberry', 'Chocolate', 'Mango'];
  var toppingArray = ['Chocolate','Sprinkle', 'Marshmallow'];
  String selectedFlavor = 'Strawberry';
  String selectedTopping = 'Marshmallow';

  TextEditingController orderNoController = new TextEditingController();
  TextEditingController totalController = new TextEditingController();
  TextEditingController changeController = new TextEditingController();

  //
  bool firstTime = true;

  // @override
  // void initState() {
  //   super.initState();
  //   selectedValue = dropDown[0];
  // }
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    if (order.orderNo == -1 && firstTime) {
      orderNoController.text = '';
      totalController.text = '';
      changeController.text = '';
      firstTime = false;
    } else if (firstTime) {
      orderNoController.text = order.orderNo.toString();
      totalController.text = order.total.toString();
      changeController.text = order.change.toString();
      selectedFlavor = this.order.flavor;
      selectedTopping = this.order.topping;

      firstTime = false;
    }

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                moveToLastScreen();
              },
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
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
                      child:
                          // Align(
                          //   alignment: Alignment.bottomRight,
                          //   child: RaisedButton(
                          //     color: Theme.of(context).primaryColorDark,
                          //     child: Padding(
                          //       padding: const EdgeInsets.only(
                          //         top: 3,
                          //         bottom: 3,
                          //         left: 7,
                          //         right: 7,
                          //       ),
                          //       child: Text(
                          //         'Submit',
                          //         style:
                          //             TextStyle(color: Colors.white, fontSize: 20),
                          //       ),
                          //     ),
                          //     onPressed: () {
                          //       saveData();
                          //     },
                          //   ),
                          // ),
                          saveAndDeleteBtnWidget(),
                    ),
                  ],
                ),
              ))),
    );
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
                items: flavorArray.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: selectedFlavor,
                onChanged: (String value) {
                  debugPrint('selected f: ' + value);
                  setState(() {
                    selectedFlavor = value;
                  });
                },
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

  saveAndDeleteBtnWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            color: Theme.of(context).primaryColorDark,
            textColor: Theme.of(context).primaryColorLight,
            child: Text('SAVE', style: TextStyle(fontSize: 16)),
            onPressed: () {
              saveData();
            },
          ),
        ),
        Container(width: 5.0),
        Expanded(
          child: RaisedButton(
            color: Theme.of(context).primaryColorDark,
            textColor: Theme.of(context).primaryColorLight,
            child: Text('DELETE', style: TextStyle(fontSize: 16)),
            onPressed: () {
              deleteData();
            },
          ),
        ),
      ],
    );
  }

  void saveData() async {
    this.order.flavor = selectedFlavor;
    this.order.topping = selectedTopping;

    moveToLastScreen();

    int result;

    if (order.id == null) {
      //insert operation
      result = await databaseHelper.insertOrder(order);
      debugPrint('insert operation');
      if(result != 0){
        showAlertDialog('Status', 'Order Saved Successfully');
      }
    } else {
      //update operation
      debugPrint('update operation');
      result = await databaseHelper.updateOrder(order);
      if(result != 0) {
        showAlertDialog('Status', 'Order Updated Successfully');
      }
    }

    if (result == 0) {
      showAlertDialog('Status', 'Fail to Saved');
    }
  }

  deleteData() async {
    moveToLastScreen();

    if (order.id == null) {
      showAlertDialog('Status', 'No order is selected');
      return;
    } else {
      databaseHelper.deleteOrder(order.id);
    }
  }

  void showAlertDialog(String title, String msg) {
    AlertDialog alertDialog =
        AlertDialog(title: Text(title), content: Text(msg));
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
