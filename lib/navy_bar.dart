import 'package:flutter/material.dart';

class NavyBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipPath(
          clipper: NClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
            color: Colors.red,
                    ),
            height: 70,
            width: 300,
          ),
        ),
      ),
    );
  }
}

class NClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0.75*size.width, 0);
    path.arcToPoint(Offset((size.width/2)+((7/8)*(size.width)), size.height/3), radius: Radius.circular(size.height/100));
    //path.quadraticBezierTo(0.68*size.width, size.height/4, size.width - size.width/1.75, size.height/4);
    path.lineTo((size.width/2)-((7/8)*(size.width)), size.height/3);
    //path.quadraticBezierTo(0.32*size.width, size.height/4, size.width - 2*(size.width/3), 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

}