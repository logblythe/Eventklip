import 'package:flutter/material.dart';

class AnimatedTile extends StatelessWidget {
  const AnimatedTile(
      {Key key,
        this.animationController,
        this.animation,
        this.widget})
      : super(key: key);

  final Widget widget;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: widget
          ),
        );
      },
    );
  }
}
