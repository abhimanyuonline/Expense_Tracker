import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MeshGradientBackground extends StatefulWidget {
  final Widget child;
  const MeshGradientBackground({super.key, required this.child});

  @override
  State<MeshGradientBackground> createState() => _MeshGradientBackgroundState();
}

class _MeshGradientBackgroundState extends State<MeshGradientBackground> {
  double _x = 0;
  double _y = 0;
  StreamSubscription<AccelerometerEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      setState(() {
        _x = event.x * 5; // Sensitivity
        _y = event.y * 5;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            top: -50 + _y,
            left: -50 + _x,
            right: -50 - _x,
            bottom: -50 - _y,
            child: MeshGradient(
              points: [
                MeshGradientPoint(
                  position: const Offset(0.2, 0.2),
                  color: const Color(0xFF6366F1).withOpacity(0.8),
                ),
                MeshGradientPoint(
                  position: const Offset(0.8, 0.2),
                  color: const Color(0xFF8B5CF6).withOpacity(0.8),
                ),
                MeshGradientPoint(
                  position: const Offset(0.5, 0.5),
                  color: const Color(0xFF312E81).withOpacity(0.8),
                ),
                MeshGradientPoint(
                  position: const Offset(0.2, 0.8),
                  color: const Color(0xFF1E1B4B).withOpacity(0.8),
                ),
                MeshGradientPoint(
                  position: const Offset(0.8, 0.8),
                  color: const Color(0xFF4F46E5).withOpacity(0.8),
                ),
              ],
              options: MeshGradientOptions(
                blend: 5,
                noiseIntensity: 0.1,
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}
