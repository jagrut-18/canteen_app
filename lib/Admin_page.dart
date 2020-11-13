import 'package:canteen_app/start_screen.dart';
import 'package:canteen_app/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Firestore _firestore = Firestore();
  List _user = [];
  List _currentOrders = [];
  Map<String, dynamic> food = {};
  List id = [];
  int currentScreen = 0;

  String title;
  String imgUrl;
  double price;
  String category;

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', null);
  }

  void fetchData() {
    var current;
    _firestore.collection('users').getDocuments().then((snapshot) {
      setState(() {
        current = snapshot.documents;
        if(current.isNotEmpty){
          current.forEach((doc) {
            if(doc['current-order'].length!=0){
              
          _currentOrders.add(doc['current-order']);
          _user.add(doc['user-email']);
            }
        });
        }
      });
    });
    var foodItems;
    _firestore.collection('admin').document('food-items').get().then((snapshot){
      setState(() {
        foodItems = snapshot.data.values.toList();
        for(int i=0;i<foodItems.length;i++){
        food.addAll({
          '$i': foodItems[i]
        });
      }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async=>false,
          child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: adminWidget()),
            Container(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.dns, color: currentScreen==0?Colors.red:Colors.black,),
                    onPressed: (){
                      setState(() {
                       currentScreen = 0; 
                      });
                    },
                  ),
                  IconButton(
                    icon: Column(
                      children: <Widget>[
                        Icon(Icons.add_circle, color: currentScreen==1?Colors.red:Colors.black,),
                      ],
                    ),
                    onPressed: (){
                      setState(() {
                       currentScreen = 1; 
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: (){
                      logout();
                      Navigator.push(
                      context,
                      NoAnimationMaterialPageRoute(
                          builder: (context) => StartScreen()));
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget adminWidget(){
    Widget w;
    setState(() {
     if(currentScreen == 0){
      w =_user.length>0?Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: _user.length==null?0:_user.length,
                  itemBuilder: (context, uid) {
                    return Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _user[uid],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              color: Colors.blue[200],
                              child: Text(
                                'Order Ready',
                                style: TextStyle(color: Colors.black54),
                              ),
                              onPressed: () {
                                setState(() {
                                  _firestore.collection('users').document(_user[uid]).updateData({'current-order' : {}});
                                  _currentOrders.removeAt(uid);
                                  _user.removeAt(uid);
                                });
                              },
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: (_currentOrders[uid]).length==null?0:(_currentOrders[uid]).length,
                          itemBuilder: (context, orderID) {
                            return Text(
                              '${_currentOrders[uid].keys.toList()[orderID]} : ${_currentOrders[uid].values.toList()[orderID]}',
                              style: TextStyle(fontSize: 16),
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Container(
                            color: Colors.grey,
                            height: 1,
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ):Center(child: Text('No orders right now', style: TextStyle(fontSize: 30, color: Colors.black54),),);
    }
    else if(currentScreen == 1){
      w = Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: 'Food Title'),
              onChanged: (tit){
                title = tit;
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Price'),
              onChanged: (amount){
                price = double.parse(amount);
              },
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Food Category'),
              onChanged: (cat){
                category = cat;
              },
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Image URL'),
              onChanged: (url){
                imgUrl = url;
              },
            ),
            FlatButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.red[100],
              child: Text('Add Food', style: TextStyle(fontSize: 16,),),
              onPressed: (){
                food.addAll({
                  '${food.length}' : {
                    'title' : title,
                    'imgUrl' : imgUrl,
                    'price' : price,
                    'category' : category
                  }
                });
                _firestore.collection('admin').document('food-items').updateData(food);
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
