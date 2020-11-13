import 'package:canteen_app/Admin_page.dart';
import 'package:canteen_app/firestore.dart';
import 'package:canteen_app/home_page.dart';
import 'package:canteen_app/model.dart';
import 'package:canteen_app/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utility.dart';

class LoginPage extends StatefulWidget {
  final FooditemList itemList;
  LoginPage(this.itemList);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Show _show = Show();
  Fire _fire = Fire();
  Firestore _firestore = Firestore();
  String _email;
  String _password;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool hidepassword = true;
  bool _isLoading = false;
  var _adminData;
  String _adminEmail;
  String _adminPassword;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  
  Future<Null> loginUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _email);
  }

  void admin(){
    _firestore.collection('admin').document('admin-login').get().then((snapshot){
      _adminData = snapshot.data;
      setState(() {
        if(snapshot.exists){
          _adminEmail = _adminData['admin-email'];
          _adminPassword = _adminData['admin-password'];
        }
      });
    });
  }

  

@override
  void initState() {
    super.initState();
    admin();
  }

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: ()async=>false,
          child: Scaffold(
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
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(alignment: Alignment.bottomLeft,
                                child: Padding(
                    padding: EdgeInsets.only(bottom: 180, left: 25),
                    child: Hero(tag: 'foodicon',child: Icon(Icons.fastfood, color: Colors.white,size: 55,)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 120, left: 25),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Welcome',
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
                      child: Hero(tag: 'sign',
                                            child: Container(
                          width: 350,
                          height: 400,
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
                                      'Sign in',
                                      style:
                                          TextStyle(fontSize: 20, letterSpacing: 2),
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                  InputField(
                                    inputType: TextInputType.emailAddress,
                                    controller: _emailController,
                                    error: _emailController.text.isNotEmpty?((_emailController.text.contains('@') && _emailController.text.contains('.'))==true?null:'Enter valid email'):null,
                                    errorStyle: TextStyle(color: Colors.red),
                                    hintText: 'Email',
                                    onChange: (email){
                                      setState(() {
                                        _email = email;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 20,),
                                  PasswordField(
                                    errorStyle: TextStyle(color: Colors.red),
                                    error: _passwordController.text.isNotEmpty?(_passwordController.text.length<6?'Password length must greater than 6':null):null,
                                    controller: _passwordController,
                                    onChange: (password){
                                      setState(() {
                                       _password = password; 
                                      });
                                    },
                                    hintText: 'Password',
                                    obscure: hidepassword,
                                    obscureFunction: (){
                                      setState(() {
                                       hidepassword = !hidepassword; 
                                      });
                                    },
                                  ),
                                  SizedBox(height: 30,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('Don\'t have an account?'),
                                      Padding(
                                        padding: EdgeInsets.only(left: 6),
                                        child: GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, NoAnimationMaterialPageRoute(builder: (context)=>SignUpPage()));
                                          },
                                                                              child: Text('Sign up',
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
                      padding: EdgeInsets.only(right: 70, top: 360),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Hero(tag: 'button',child: new CircleButton(
                            color: ((_emailController.text.isNotEmpty) && (_passwordController.text.isNotEmpty))==true?Colors.green[300]:Colors.grey,
                            child: _isLoading==true?CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),):Icon(Icons.arrow_forward_ios, color: Colors.white,),
                            ontap: ((_emailController.text.isNotEmpty) && (_passwordController.text.isNotEmpty) && (_emailController.text.contains('@') && _emailController.text.contains('.')) && (_passwordController.text.length>=6))==true?(){
                              setState(() {
                                _isLoading = true;
                                loginUser();
                                if(_adminEmail==_email && _adminPassword==_password){
                                   Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminPage()));
                                 }
                                else{
                                  try {
                                 
                                _fire.logIn(_email, _password).then((a){
                                  if(a==0){
                                    _show.toast('Email or Password is wrong!', Toast.LENGTH_SHORT, ToastGravity.BOTTOM, Colors.white, Colors.blue, 16);
                                    _isLoading = false;
                                  }
                                  else{
                                    Navigator.push(context, NoAnimationMaterialPageRoute(builder: (context)=>HomePage(email: _email,items: widget.itemList,)));
                                    _isLoading = false;
                                  }
                                });
                              } catch (e) {
                                print('Error $e');
                              } 
                                }
                              });
                            }:(){},
                          )),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


