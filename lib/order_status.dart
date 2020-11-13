import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderStatus extends StatefulWidget {
  final String email;
  OrderStatus({this.email});
  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus>
    with TickerProviderStateMixin {
  Firestore _firestore = Firestore();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async=>false,
          child: Scaffold(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Canteen',
                          style: TextStyle(
                              fontSize: 35,
                              fontFamily: 'Pacifico',
                              color: Colors.white)),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: StreamBuilder(
                                stream: _firestore
                                    .collection('users')
                                    .document(widget.email)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  return snapshot.hasData ? Column(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data['current-order'].length == 0 ? 'Your order is ready' : 'Your order is getting ready',
                                        style: TextStyle(
                                            fontSize: 40,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Container(
                                        height: 200,
                                        width: 200,
                                        child: snapshot.data['current-order'].length == 0
                                            ? Image.asset('gif/check_mark.gif')
                                            : Image.asset('gif/food_load.gif'),
                                      ),
                                      snapshot.data['current-order'].length == 0? RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.green[300],
                    child: Text(
                      'Back to Home',
                      style: TextStyle(
                          fontFamily: 'Righteous', color: Colors.black54),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ):Container(),
                                    ],
                                  ) : Container();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
