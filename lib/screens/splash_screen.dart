import 'dart:async';

import 'package:eventklip/screens/home_screen.dart';
import 'package:eventklip/screens/qr_users_home_screen.dart';
import 'package:eventklip/screens/shared_preferences.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/view_models/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventklip/screens/onboarding_screen.dart';
import 'package:eventklip/utils/widget_extensions.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController rotationController;

  startTime() async {
    var _duration = Duration(seconds: 3);

    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    final loggedIn = await SharedPreferenceHelper.getIsLoggedIn();

    if (loggedIn) {
      final user = await SharedPreferenceHelper.getUser();
      Provider.of<EventklipAppState>(context, listen: false)
          .setUserProfile(user);
      final userType = await SharedPreferenceHelper.getUserType();
      if (userType == UserType.CUSTOMER) {
        launchScreenWithNewTask(context, QrUsersHomeScreen.tag);
      } else {
        launchScreenWithNewTask(context, HomeScreen.tag);
      }
    } else {
      launchScreenWithNewTask(context, OnBoardingScreen.tag);
    }
  }

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    rotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        rotationController.repeat();
      }
    });
    rotationController.forward();
    startTime();
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).splashColor,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FadeTransition(
                  opacity:
                      Tween(begin: 0.0, end: 1.0).animate(rotationController),
                  child: Image.asset("assets/images/eventklipblue.png")),
              Loader()
            ],
          ),
        ),
      ),
    );
  }
}
