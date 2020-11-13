import 'package:canteen_app/firestore.dart';
import 'package:canteen_app/home_page.dart';
import 'package:canteen_app/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utility.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Firestore _firestore = Firestore();
  Fire _fire = Fire();
  Show _show = Show();
  String _email;
  String _password;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool hidepassword = true;
  bool _isLoading = false;
  bool _alreadyUser;
  var _foodItems;
  List<FoodItem> _f = [];
  FooditemList itemList;

  Future<Null> loginUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _email);
  }

  void fetchData(String email) {
    DocumentReference df = _firestore.collection('users').document(email);
    df.get().then((snapshot) {
      setState(() {
        if (snapshot.exists) {
          _alreadyUser = true;
        } else {
          _alreadyUser = false;
        }
        if (_alreadyUser == false) {
          _fire.registerUser(_email, _password).then((e) {
            _isLoading = true;
            Navigator.push(
                context,
                NoAnimationMaterialPageRoute(
                    builder: (context) => HomePage(
                          email: _email,
                          items: itemList,
                        )));
          });
        } else if (_alreadyUser == true) {
          _show.toast('Email already registered!', Toast.LENGTH_LONG,
              ToastGravity.BOTTOM, Colors.grey[600], Colors.white, 16);
              _isLoading = false;
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
    fetch();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.blue[900],
            Colors.blue[200],
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: Center(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 135, left: 25),
                  child: Hero(
                      tag: 'foodicon',
                      child: Icon(
                        Icons.fastfood,
                        color: Colors.white,
                        size: 55,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 80, left: 25),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Let\'s get started',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Pacifico',
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3),
                  ),
                ),
              ),
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Hero(
                      tag: 'sign',
                      child: Container(
                        width: 350,
                        height: 450,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30))),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Sign up',
                                    style: TextStyle(
                                        fontSize: 20, letterSpacing: 2),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                InputField(
                                  inputType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  error: _emailController.text.isNotEmpty
                                      ? ((_emailController.text.contains('@') &&
                                                  _emailController.text
                                                      .contains('.')) ==
                                              true
                                          ? null
                                          : 'Enter valid email')
                                      : null,
                                  errorStyle: TextStyle(color: Colors.red),
                                  hintText: 'Email',
                                  onChange: (email) {
                                    setState(() {
                                      _email = email;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                PasswordField(
                                  errorStyle: TextStyle(color: Colors.red),
                                  error: _passwordController.text.isNotEmpty
                                      ? (_passwordController.text.length < 6
                                          ? 'Password length must greater than 6'
                                          : null)
                                      : null,
                                  controller: _passwordController,
                                  onChange: (password) {
                                    setState(() {
                                      _password = password;
                                    });
                                  },
                                  hintText: 'Password',
                                  obscure: hidepassword,
                                  obscureFunction: () {
                                    setState(() {
                                      hidepassword = !hidepassword;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Already have an account?'),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 6),
                                        child: Text('Sign in',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 70, top: 410),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Hero(
                          tag: 'button',
                          child: new CircleButton(
                            color: ((_emailController.text.isNotEmpty) &&
                                        (_passwordController
                                            .text.isNotEmpty)) ==
                                    true
                                ? Colors.green[300]
                                : Colors.grey,
                            child: _isLoading == true
                                ? CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                  )
                                : Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  ),
                            ontap: ((_emailController.text.isNotEmpty) &&
                                        (_passwordController.text.isNotEmpty) &&
                                        (_emailController.text.contains('@') &&
                                            _emailController.text
                                                .contains('.')) &&
                                        (_passwordController.text.length >=
                                            6)) ==
                                    true
                                ? () {
                                    setState(() {
                                      loginUser();
                                      _isLoading = true;
                                      fetchData(_email);
                                    });
                                  }
                                : () {},
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
