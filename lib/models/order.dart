class Order {
  int _id;
  int _orderNo;
  String _flavor;
  String _topping;
  int _total;
  int _change;

  Order(this._orderNo, this._flavor, this._topping, this._total, [this._change]);
  Order.withID(this._orderNo, this._flavor, this._topping, this._total, [this._change]);
  Order.empty();

  int get id => this._id;
  int get orderNo => this._orderNo;
  String get flavor => this._flavor;
  String get topping => this._topping;
  int get total => this._total;
  int get change => this._change;

  set orderNo(int newValue) {
    this._orderNo = newValue;
  }

  set flavor(String newValue) {
    this._flavor = newValue;
  }

  set topping(String newValue) {
    this._topping = newValue;
  }

  set total(int newValue) {
    this._total = newValue;
  }

  set change(int newValue) {
    this._change = newValue;
  }

  //SQLFlite only get and return value in form of map

  //Convert Order object to Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) map['id'] = _id;

    map['orderno'] = _orderNo;
    map['flavor'] = _flavor;
    map['topping'] = _topping;
    map['total'] = _total;
    map['change'] = _change;

    return map;
  }

  //Convert Map object to Order object
  Order.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _orderNo = map['orderno'];
    _flavor = map['flavor'];
    _topping = map['topping'];
    _total = map['total'];
    _change = map['change'];
  }
}
