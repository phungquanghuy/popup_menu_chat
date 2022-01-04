import 'package:simple_animations/simple_animations.dart';
import 'package:flutter/material.dart';

class AnimatedScreen extends StatefulWidget {
  const AnimatedScreen({Key? key, required this.widget}) : super(key: key);

  final Widget widget;

  @override
  State<AnimatedScreen> createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen> {
  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: Tween(begin: 0.0, end: 200.0),
      duration: const Duration(milliseconds: 200),
      builder: (context, child, value) {
        return SizedBox(
          width: value,
          child: widget.widget,
        );
      },
    );
  }
}
