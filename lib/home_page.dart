import 'package:canteen_app/firestore.dart';
import 'package:canteen_app/log_in.dart';
import 'package:canteen_app/model.dart';
import 'package:canteen_app/order_status.dart';
import 'package:canteen_app/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String email;
  final FooditemList items;
  HomePage({this.email, this.items});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Show _show = Show();
  Firestore _firestore = Firestore();
  Fire _fire = Fire();
  int currentScreen = 0;
  List<List<Widget>> food = [];
  List<String> category = [];
  static double totalPrice = 0;
  static int totalItems = 0;
  List<FoodItem> orderedFood = [];
  Map<String, dynamic> _userData;
  double wallet = 0;
  List pastItems = [];
  List pastPrice = [];

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', null);
  }

  void fetchData() {
    _firestore
        .collection('users')
        .document(widget.email)
        .get()
        .then((snapshot) {
      setState(() {
        Map<String, dynamic> d = snapshot.data;
        _userData = d;
      });
      wallet = _userData['wallet-balance'] == null
          ? 1000
          : _userData['wallet-balance'];
      if (_userData['past-orders'] != null) {
        for (int i = 0; i < _userData['past-orders'].length; i++) {
          pastItems.add([]);
          pastPrice.add([]);
        }
        for (int i = 0; i < _userData['past-orders'].length; i++) {
          _userData['past-orders']['order-$i'].forEach((k, v) {
            pastItems[i].add(k);
            pastPrice[i].add(v);
          });
        }
        pastItems = pastItems.reversed.toList();
        pastPrice = pastPrice.reversed.toList();
      }
    });
  }

  Widget total(int qty, double price) {
    return Text(
      'Rs. ${qty * price}',
      style: TextStyle(fontSize: 12, color: Colors.grey),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return orderedFood.length == 0
                  ? Container(
                      height: 200,
                      child: Center(
                        child: Text('Your Cart is empty',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 25,
                                color: Color(0xff695C5A))),
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 15, left: 15, right: 15),
                            child: Text('Your Cart',
                                style: TextStyle(
                                    letterSpacing: 2,
                                    color: Colors.blue[900],
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Container(
                            child: Expanded(
                          child: ListView.builder(
                            itemCount: orderedFood.length == null
                                ? 0
                                : orderedFood.length,
                            itemBuilder: (context, index) {
                              return orderedFood[index].quantity == 0
                                  ? null
                                  : Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      '    ${orderedFood[index].title}',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      '     X ${orderedFood[index].quantity}',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  child: Text(
                                                'Rs. ${orderedFood[index].price}',
                                                style: TextStyle(fontSize: 14),
                                              )),
                                              Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      RoundedButton(
                                                        childWidget:
                                                            Icon(Icons.remove),
                                                        ontap: () {
                                                          setState(() {
                                                            orderedFood[index]
                                                                .decrementQuantity();

                                                            if (orderedFood[
                                                                        index]
                                                                    .quantity ==
                                                                0) {
                                                              orderedFood
                                                                  .removeAt(
                                                                      index);
                                                            }
                                                          });
                                                        },
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child: Text(
                                                            '${orderedFood[index].quantity}'),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                        child: RoundedButton(
                                                          childWidget:
                                                              Icon(Icons.add),
                                                          ontap: () {
                                                            setState(() {
                                                              orderedFood[index]
                                                                  .incrementQuantity();
                                                            });
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 5),
                                                    child: total(
                                                        orderedFood[index]
                                                            .quantity,
                                                        orderedFood[index]
                                                            .price),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height: 3,
                                        )
                                      ],
                                    );
                            },
                          ),
                        )),
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 180,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40),
                                          topRight: Radius.circular(40))),
                                  height: 150,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 40, horizontal: 20),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              'Total Amount',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xff695C5A)),
                                            ),
                                            Text(
                                              'Rs. ${FoodItem.total}',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xff695C5A)),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              'Quantity',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xff695C5A)),
                                            ),
                                            Text(
                                              '${FoodItem.totalQty}',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xff695C5A)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 100,
                              height: 50,
                              child: RaisedButton(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                color: Colors.blue,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 10),
                                  child: Text(
                                    'Place Order',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        letterSpacing: 2),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (wallet >= FoodItem.total) {
                                      wallet = wallet - FoodItem.total;
                                      placeOrder();
                                      Navigator.push(
                                          context,
                                          NoAnimationMaterialPageRoute(
                                              builder: (context) => OrderStatus(
                                                    email: widget.email,
                                                  )));
                                                  
                                    orderedFood = [];
                                    }
                                    else{
                                      _show.toast('Wallet amount is not enough', Toast.LENGTH_SHORT, ToastGravity.BOTTOM, Colors.grey[700], Colors.white, 15);
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
            },
          );
        }).whenComplete(() {
      setState(() {
        category = [];
        food = [];
        initialWidget();
        print('Closed');
      });
    });
  }

  void placeOrder() {
    Map order = {};
    for (var f in orderedFood) {
      order['${f.quantity}X${f.title}'] = f.price;
    }
    _fire.placeOrder(order, widget.email,);
    _fire.updateWallet(wallet, widget.email);
    if (_userData['past-orders'] == null) {
      _fire.pastOrders({'order-0': order}, widget.email);
    } else {
      Map past = _userData['past-orders'];
      past['order-${past.length}'] = order;
      _fire.pastOrders(past, widget.email,);
    }
  }

  void initialWidget() {
    setState(() {
      for (var f in widget.items.foodItems) {
        if (category.contains(f.category) == false) {
          category.add(f.category);
          food.add([]);
        }
      }
      for (int i = 0; i < category.length; i++) {
        for (int j = 0; j < widget.items.foodItems.length; j++) {
          if (category[i] == widget.items.foodItems[j].category) {
            FoodItem f = widget.items.foodItems[j];
            food[i].add(GrooveWidget(
              id: f.id,
              title: f.title,
              price: f.price,
              order: orderedFood,
              imgUrl: f.imgUrl,
            ));
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    initialWidget();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 10, right: 10),
          child: SizedBox(
            width: 120,
            height: 40,
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              //elevation: 10,
              child: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                FoodItem.total = 0;
                FoodItem.totalQty = 0;
                for (var food in orderedFood) {
                  FoodItem.total = FoodItem.total + food.price;
                  FoodItem.totalQty = FoodItem.totalQty + food.quantity;
                }
                _settingModalBottomSheet(context);
              },
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[900], Colors.blue[200]],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 11,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 20, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text('Canteen',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontFamily: 'Pacifico',
                                  color: Colors.white)),
                          IconButton(
                            icon: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                currentScreen = 3;
                              });
                            },
                          )
                        ],
                      ),
                      Expanded(
                        child: Hero(
                          tag: 'sign',
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: homeWidget()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40)),
                    child: Padding(
                      padding: EdgeInsets.only(right: 132),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            child: currentScreen == 0
                                ? CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.red[100],
                                    child: Icon(
                                      Icons.restaurant_menu,
                                      color: Colors.black,
                                    ),
                                  )
                                : Icon(Icons.restaurant_menu),
                            onTap: () {
                              setState(() {
                                currentScreen = 0;
                              });
                            },
                          ),
                          InkWell(
                            child: currentScreen == 1
                                ? CircleAvatar(
                                    backgroundColor: Colors.red[100],
                                    child: Icon(
                                      Icons.account_balance_wallet,
                                      color: Colors.black,
                                    ),
                                  )
                                : Icon(Icons.account_balance_wallet),
                            onTap: () {
                              setState(() {
                                currentScreen = 1;
                              });
                            },
                          ),
                          InkWell(
                            child: currentScreen == 2
                                ? CircleAvatar(
                                    backgroundColor: Colors.red[100],
                                    child: Icon(
                                      Icons.dns,
                                      color: Colors.black,
                                    ),
                                  )
                                : Icon(Icons.dns),
                            onTap: () {
                              setState(() {
                                currentScreen = 2;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget homeWidget() {
    Widget w;
    var amount = 0;
    setState(() {
      if (currentScreen == 0) {
        w = ListView.builder(
          itemCount: category.length,
          itemBuilder: (context, categoryIndex) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                  child: Text(
                    category[categoryIndex],
                    style: TextStyle(
                      fontFamily: 'Righteous',
                      fontSize: 23,
                      color: Colors.black87,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: food[categoryIndex].length,
                  itemBuilder: (context, index) {
                    return food[categoryIndex][index];
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
                  child: Container(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                )
              ],
            );
          },
        );
      } else if (currentScreen == 1) {
        w = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('gif/wallet.gif'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Text(
                    'Your Wallet',
                    style: TextStyle(color: Colors.black54, fontSize: 30),
                  ),
                  Text(
                    'Rs. ' + wallet.toString(),
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.green[300],
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                    child: InputField(
                      inputType: TextInputType.number,
                      hintText: 'Enter amount',
                      onChange: (a) {
                        amount = int.parse(a);
                      },
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.green[300],
                    child: Text(
                      'Add money',
                      style: TextStyle(
                          fontFamily: 'Righteous', color: Colors.black54),
                    ),
                    onPressed: () {
                      setState(() {
                        wallet = wallet + amount;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        );
      } else if (currentScreen == 2) {
        w = pastItems.length == 0
            ? Center(
                child: Text(
                  'No orders yet',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black54,
                      fontFamily: 'Righteous'),
                ),
              )
            : ListView.builder(
                itemCount: pastItems.length,
                itemBuilder: (context, itemIndex) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 10, bottom: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Order ${pastItems.length - itemIndex}',
                                style: TextStyle(
                                  fontFamily: 'Righteous',
                                  fontSize: 20,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                pastItems[itemIndex].length.toString() +
                                    ((pastItems[itemIndex].length) == 1
                                        ? ' Item'
                                        : ' Items'),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Righteous',
                                    color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: pastItems[itemIndex].length,
                        itemBuilder: (context, priceIndex) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    pastItems[itemIndex][priceIndex],
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Righteous',
                                        color: Colors.black54),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                      'Rs. ' +
                                          pastPrice[itemIndex][priceIndex]
                                              .toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Righteous',
                                        color: Colors.black54,
                                      )),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 6),
                        child: Container(
                          height: 1,
                          color: Colors.grey[300],
                        ),
                      )
                    ],
                  );
                },
              );
      } else if (currentScreen == 3) {
        w = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('gif/account.gif'),
                        fit: BoxFit.cover,
                        colorFilter:
                            ColorFilter.mode(Colors.blue, BlendMode.color))),
              ),
              Text(
                widget.email,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontFamily: 'Righteous'),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.green[300],
                child: Text(
                  'Log Out',
                  style:
                      TextStyle(fontFamily: 'Righteous', color: Colors.black54),
                ),
                onPressed: () {
                  logout();
                  Navigator.push(
                      context,
                      NoAnimationMaterialPageRoute(
                          builder: (context) => LoginPage(widget.items)));
                },
              )
            ],
          ),
        );
      }
    });
    return w;
  }
}

class GrooveWidget extends StatefulWidget {
  final int id;
  final String title;
  final double price;
  final String imgUrl;
  final List<FoodItem> order;
  GrooveWidget({
    this.id,
    this.title,
    this.price,
    this.order,
    this.imgUrl,
  });
  @override
  _GrooveWidgetState createState() => _GrooveWidgetState();
}

class _GrooveWidgetState extends State<GrooveWidget> {
  String addToCart = 'Add';
  String button() {
    if(widget.order.isEmpty){
          setState(() {
           addToCart = 'Add'; 
          });
        }
      else {
        for (var food in widget.order) {
        
         if (food.title == widget.title) {
          setState(() {
           addToCart = 'Added'; 
          });
        } else {
          setState(() {
           addToCart = 'Add'; 
          });
        }
      }
      }
    return addToCart;
  }

  @override
  void initState() {
    super.initState();
    addToCart = button();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                      image: widget.imgUrl == null
                          ? null
                          : DecorationImage(
                              image: NetworkImage(widget.imgUrl),
                              fit: BoxFit.cover)),
                  width: 100,
                  height: 90,
                ),
              ),
            ),
            Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: TextStyle(fontSize: 18, fontFamily: 'Righteous'),
                    ),
                    Text(
                      'Rs. ' + widget.price.toString(),
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Righteous',
                          color: Colors.black45),
                    )
                  ],
                )),
            Expanded(
              flex: 4,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color:
                    button() == 'Added' ? Colors.grey[300] : Colors.green[300],
                child: Text(
                  addToCart,
                  style:
                      TextStyle(fontFamily: 'Righteous', color: Colors.black54),
                ),
                onPressed: () {
                  setState(() {
                    if (button() == 'Add') {
                      widget.order.add(FoodItem(
                          id: widget.id,
                          title: widget.title,
                          price: widget.price));
                    }
                    addToCart = 'Added';
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
