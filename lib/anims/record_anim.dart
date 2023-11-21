import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class RotateRecord extends AnimatedWidget {
  const RotateRecord({super.key, required Animation<double> animation})
      : super(listenable: animation);

  Widget build(BuildContext context) {
    final Listenable animation = listenable;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 250.0,
      width: 250.0,
      child: RotationTransition(
          turns: animation as Animation<double>,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                    "https://images-na.ssl-images-amazon.com/images/I/51inO4DBH0L._SS500.jpg"),
              ),
            ),
          )),
    );
  }
}
