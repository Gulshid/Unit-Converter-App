import 'package:flutter/material.dart';

class DynamicCurveClipper extends CustomClipper<Path> {
  final double scrollPercentage;

  DynamicCurveClipper(this.scrollPercentage);

  @override
  Path getClip(Size size) {
    Path path = Path();
    double curveHeight = 50 * (1 - scrollPercentage); 

    path.lineTo(0, size.height - curveHeight);
    path.quadraticBezierTo(
      size.width / 2, size.height + curveHeight, 
      size.width, size.height - curveHeight,   
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true; 
  }
}