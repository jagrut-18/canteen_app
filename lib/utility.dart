import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            maintainState: maintainState,
            settings: settings,
            fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

class Show{
  void toast(String message, Toast length, ToastGravity gravity, Color bgColor, Color textColor, double size){
    Fluttertoast.showToast(
        msg: message,
        toastLength: length,
        gravity: gravity,
        backgroundColor: bgColor,
        textColor: textColor,
        fontSize: size,
    );
  }
}

class RoundedButton extends StatelessWidget {
  final Widget childWidget;
  final Function ontap;
  RoundedButton({this.childWidget, this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: CircleBorder(),
          child: Container(
            padding: EdgeInsets.all(0),
        child: childWidget,
        decoration: BoxDecoration(
          color: Colors.green[300],
          shape: BoxShape.circle,
        ),
        
      ),
      onTap: ontap,
    );
  }
}

class CircleButton extends StatelessWidget {
  final Function ontap;
  final Widget child;
  final Color color;
  CircleButton({this.ontap, this.child, this.color});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 10,
                    onPressed: ontap,
                    color: color,
                    padding: EdgeInsets.all(25),
                    shape: CircleBorder(),
                    child: child,
                  );
  }
}

class InputField extends StatelessWidget {
  final String hintText;
  final String error;
  final TextStyle errorStyle;
  final Function(String) onChange;
  final TextInputType inputType;
  final TextEditingController controller;
  InputField({this.hintText, this.onChange, this.inputType, this.controller, this.error, this.errorStyle});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: inputType,
      onChanged: onChange,
      controller: controller,
      decoration: InputDecoration(
        errorText: error,
        errorStyle: errorStyle,
        labelStyle: TextStyle(color: Colors.black54),
          labelText: hintText,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.green, width: 2)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          )
          ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final Function(String) onChange;
  final String hintText;
  final bool obscure;
  final String error;
  final TextStyle errorStyle;
  final Function obscureFunction;
  final TextEditingController controller;
  PasswordField({this.hintText, this.obscure, this.obscureFunction, this.onChange, this.controller, this.error, this.errorStyle});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChange,
      obscureText: widget.obscure,
      decoration: InputDecoration(
        errorText: widget.error,
        errorStyle: widget.errorStyle,
        suffixIcon: IconButton(
          icon: Icon(widget.obscure==true?Icons.visibility:Icons.visibility_off),
          onPressed: widget.obscureFunction
        ),
          labelText: widget.hintText,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.green, width: 2)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          )
          ),
    );
  }
}
