import 'package:eventklip/utils/resources/colors.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:eventklip/utils/utility.dart';
import 'package:eventklip/view_models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventklipAppState>(builder: (context, provider, child) {
      return Container(
              width: 35.0,
              height: 35.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new AssetImage("assets/items/actors/01.jpg"))))
          .paddingRight(spacing_standard_new);
    });
  }
}

class UserAvatarWithInitials extends StatelessWidget {
  final fullName;
  final double size;

  UserAvatarWithInitials(this.fullName, {this.size = 95.0});

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: size,
        height: size,
        child: Center(
          child: Text(
            getInitials(fullName),
            style: TextStyle(
                fontSize: size < 40 ? 12 : 24, color: textColorPrimary),
          ),
        ),
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: stringToHslColor(fullName, 0.2, 0.5),
        ));

    /*CircleAvatar(
      child: Center(child: Text(getInitials(fullName))),
      radius: 95 / 2,
    ).paddingRight(spacing_standard_new);*/
  }
}
