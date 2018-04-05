import 'dart:math';

import 'package:flutter/material.dart';

class PageReveal extends StatelessWidget {
  
  final double revealPercent;
  final Widget child;

  const PageReveal({Key key, this.revealPercent, this.child}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return new ClipOval(
      /// Set the visibility to oval
      clipper: new CircleRevealClipper(revealPercent),
      child: child,
    );
  }
}

class CircleRevealClipper extends CustomClipper<Rect> {

  final double revealPercent;

  CircleRevealClipper(this.revealPercent);

  @override
  Rect getClip(Size size) {

    /// Let's set the center of the circle towards to bottom
    final epicenter = new Offset(size.width / 2, size.height * 0.98);

    /// Let's calculate distance from epicenter to the top left conter to make sure we fill the screen
   double theta = atan(epicenter.dy / epicenter.dx);

   final distanceToCorner = epicenter.dy / sin(theta);

   final radius = distanceToCorner * revealPercent;

   final diameter = 2 * radius;

   return new Rect.fromLTWH(epicenter.dx - radius, epicenter.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }

}
