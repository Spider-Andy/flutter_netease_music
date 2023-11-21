import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class PivotTransition extends AnimatedWidget {
  /// 创建旋转变换
  /// turns不能为空.
  const PivotTransition({
    super.key,
    this.alignment = FractionalOffset.topCenter,
    required Animation<double> turns,
    required this.child,
  }) : super(listenable: turns);

  /// The animation that controls the rotation of the child.
  /// If the current value of the turns animation is v, the child will be
  /// rotated v * 2 * pi radians before being painted.
  Listenable get turns => listenable;

  /// The pivot point to rotate around.
  final FractionalOffset alignment;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    double turnsValue = (turns as Animation).value;
    final Matrix4 transform = new Matrix4.rotationZ(turnsValue * pi * 2.0);
    return Transform(
      transform: transform,
      alignment: alignment,
      child: child,
    );
  }
}

// class AnimatedNeedle extends AnimatedWidget {
//   AnimatedNeedle({Key key, Animation<double> animation})
//       : super(key: key, listenable: animation);

//   Widget build(BuildContext context) {
//     final Animation<double> animation = listenable;
//     return new Container(
//       height: 300.0,
//       width: 100.0,
//       child: new PivotTransition(
//           turns: animation,
//           alignment: FractionalOffset.topCenter,
//           child: new Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               image: DecorationImage(
//                 image: AssetImage("images/play_needle.png"),
//               ),
//             ),
//           )),
//     );
//   }
// }
