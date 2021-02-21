import 'package:flutter/material.dart';

class AnimatedScanner extends StatefulWidget {
  @override
  _AnimatedScannerState createState() => _AnimatedScannerState();
}

class _AnimatedScannerState extends State<AnimatedScanner>
    with TickerProviderStateMixin<AnimatedScanner> {
  AnimationController animationController;

  Animation<double> verticalPosition;

  @override
  void initState() {
    initializeAnimationController();
    super.initState();
  }

  initializeAnimationController() {
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );

    animationController.addListener(() {
      this.setState(() {});
    });
    animationController.forward();
    verticalPosition = Tween<double>(begin: 0.0, end: 300.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInSine))
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          animationController.reverse();
        } else if (state == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(width: 5, color: Colors.white),
                    left: BorderSide(width: 5, color: Colors.white))),
            height: 25,
            width: 25),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 5, color: Colors.white),
                      right: BorderSide(width: 5, color: Colors.white))),
              height: 25,
              width: 25),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 5, color: Colors.white),
                      left: BorderSide(width: 5, color: Colors.white))),
              height: 25,
              width: 25),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 5, color: Colors.white),
                      right: BorderSide(width: 5, color: Colors.white))),
              height: 25,
              width: 25),
        ),
        SizedBox(
          height: 300.0,
          width: 300,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white70, width: 1.0)),
          ),
        ),
        Positioned(
          top: verticalPosition.value,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.90,
            height: 2.0,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }
}
