import 'package:canteen_app/Admin_page.dart';
import 'package:flutter/material.dart';
import 'package:canteen_app/home_page.dart';
import 'package:canteen_app/log_in.dart';
import 'package:canteen_app/model.dart';
import 'package:canteen_app/order_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utility.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String _autoEmail;
  var _foodItems;
  List<FoodItem> _f = [];
  Firestore _firestore = Firestore();
  FooditemList itemList;
  bool isLoading = false;
  var _adminData;
  String _adminEmail;

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String user = prefs.getString('email');
    _firestore
        .collection('admin')
        .document('admin-login')
        .get()
        .then((snapshot) {
      _adminData = snapshot.data;
      setState(() {
        if (snapshot.exists) {
          _adminEmail = _adminData['admin-email'];
        }
        if (user == _adminEmail) {
          Navigator.push(context,
              NoAnimationMaterialPageRoute(builder: (context) => AdminPage()));
        } else if (user != null && user != _adminEmail) {
          setState(() {
            print(user);
            _autoEmail = user;
            _firestore
                .collection('users')
                .document(_autoEmail)
                .get()
                .then((snap) {
              if (snap.data['current-order'].length != 0) {
                Navigator.push(
                    context,
                    NoAnimationMaterialPageRoute(
                        builder: (context) => OrderStatus(
                              email: _autoEmail,
                            )));
              } else {
                Navigator.push(
                    context,
                    NoAnimationMaterialPageRoute(
                        builder: (context) => HomePage(
                              email: _autoEmail,
                              items: itemList,
                            )));
              }
            });
          });
        } else {
          Navigator.push(
              context,
              NoAnimationMaterialPageRoute(
                  builder: (context) => LoginPage(itemList)));
        }
      });
    });
  }

  void fetch() {
    _firestore
        .collection('admin')
        .document('food-items')
        .get()
        .then((snapshot) {
      setState(() {
        _foodItems = snapshot.data;
        var keys = _foodItems.keys.toList();
        var values = _foodItems.values.toList();
        if (snapshot.exists) {
          for (int i = 0; i < _foodItems.length; i++) {
            _f.add(FoodItem(
                id: int.parse(keys[i]),
                title: values[i]['title'],
                price: values[i]['price'].toDouble(),
                category: values[i]['category'],
                imgUrl: values[i]['imgUrl']));
          }
        }
        itemList = FooditemList(foodItems: _f);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    fetch();
    autoLogIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('gif/start.png'), fit: BoxFit.contain)),
          ),
          isLoading == true ? CircularProgressIndicator() : Container()
        ],
      ),
    );
  }
}
