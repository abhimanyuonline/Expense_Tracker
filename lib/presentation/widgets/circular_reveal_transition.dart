import 'dart:math';
import 'package:flutter/material.dart';

class CircularRevealRoute extends PageRouteBuilder {
  final Widget page;
  final Offset center;

  CircularRevealRoute({required this.page, required this.center})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ClipPath(
              clipper: CircularRevealClipper(
                fraction: animation.value,
                center: center,
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        );
}

class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset center;

  CircularRevealClipper({required this.fraction, required this.center});

  @override
  Path getClip(Size size) {
    // Calculate final radius to cover the entire screen
    double finalRadius = _calculateDistance(center, size);
    double radius = finalRadius * fraction;

    Path path = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  double _calculateDistance(Offset offset, Size size) {
    double x = max(offset.dx, size.width - offset.dx);
    double y = max(offset.dy, size.height - offset.dy);
    return sqrt(x * x + y * y);
  }

  @override
  bool shouldReclip(CircularRevealClipper oldClipper) {
    return oldClipper.fraction != fraction || oldClipper.center != center;
  }
}
