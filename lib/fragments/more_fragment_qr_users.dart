import 'package:eventklip/screens/privacy_policy_screen.dart';
import 'package:eventklip/screens/shared_preferences.dart';
import 'package:eventklip/screens/signin.dart';
import 'package:eventklip/ui/widgets/user_avatar_widget.dart';
import 'package:eventklip/view_models/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventklip/screens/account_settings_screen.dart';
import 'package:eventklip/screens/edit_profile_screen.dart';
import 'package:eventklip/screens/terms_conditions_screen.dart';
import 'package:eventklip/utils/app_localizations.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/resources/images.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:eventklip/utils/widget_extensions.dart';
import 'package:provider/provider.dart';

class MoreFragmentQrUsers extends StatefulWidget {
  static String tag = '/MoreFragmentQrUsers';

  @override
  MoreFragmentQrUsersState createState() => MoreFragmentQrUsersState();
}

class MoreFragmentQrUsersState extends State<MoreFragmentQrUsers> {
  var profileImage = "";
  var userName = "";
  var userEmail = "";
  var isDarkMode = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventklipAppState>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(0, 10),
          child: Container(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  left: spacing_standard_new,
                  top: spacing_standard_new,
                  right: 12,
                  bottom: spacing_standard_new),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Card(
                    color: Colors.transparent,
                    elevation: spacing_standard_new,
                    margin: EdgeInsets.all(0),
                    child: UserAvatarWithInitials(
                      provider.userProfile?.fullname ?? "??",
                      size: 60,
                    ),
                  ).paddingRight(spacing_standard_new),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        text(context, provider.userProfile?.fullname ?? "-",
                            fontSize: ts_extra_normal,
                            fontFamily: font_bold,
                            textColor:
                                Theme.of(context).textTheme.headline6.color),
                        text(context, provider.userProfile?.userName ?? "",
                            fontSize: ts_normal,
                            fontFamily: font_medium,
                            textColor:
                                Theme.of(context).textTheme.subtitle2.color)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    itemSubTitle(
                            context, keyString(context, "general_settings"),
                            colorThird: false)
                        .paddingOnly(
                            left: spacing_standard_new,
                            right: spacing_standard_new,
                            top: 12,
                            bottom: 12),
                    subType(context, "account_settings", () {
                      launchScreen(context, AccountSettingsScreen.tag);
                    }, ic_settings),
                    // Row(
                    //   children: <Widget>[
                    //     Image.asset(
                    //       ic_dark_mode,
                    //       width: 20,
                    //       height: 20,
                    //       color: Theme.of(context).textTheme.headline6.color,
                    //     ).paddingRight(spacing_standard),
                    //     Expanded(
                    //         child: itemTitle(
                    //             context, keyString(context, "dark_mode"))),
                    //     Theme(
                    //       data: Theme.of(context).copyWith(
                    //         unselectedWidgetColor: Theme.of(context).primaryColor,
                    //       ),
                    //       child: Checkbox(
                    //         activeColor: Theme.of(context).primaryColor,
                    //         checkColor: Colors.white,
                    //         value: isDarkMode,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             isDarkMode = value;
                    //           });
                    //         },
                    //       ),
                    //     )
                    //   ],
                    // )
                    //     .paddingOnly(
                    //         left: spacing_standard_new,
                    //         right: spacing_control,
                    //         top: spacing_control,
                    //         bottom: spacing_control)
                    //     .onTap(() {
                    //   setState(() {
                    //     isDarkMode = !isDarkMode;
                    //   });
                    // }),
                    // subType(context, "language", () {}, ic_language),
                    // subType(context, "help", () {
                    //   launchScreen(context, HelpScreen.tag);
                    // }, ic_help),
                    itemSubTitle(context, keyString(context, "more"))
                        .paddingOnly(
                            left: spacing_standard_new,
                            right: 12,
                            top: spacing_standard_new,
                            bottom: spacing_control),
                    subType(context, "logout", () async {
                      SharedPreferenceHelper.clear();
                      final storage = FlutterSecureStorage();
                      await storage.deleteAll();
                      launchScreenWithNewTask(context, SignInScreen.tag);
                    }, null),
                  ],
                ).paddingBottom(spacing_large),
              ),
            )
          ],
        ),
      );
    });
  }

  void getUserData() {
    setState(() {
      profileImage = "assets/items/actors/01.jpg";
      userName = "Vicotria Becks";
      userEmail = "vicotriabecks@gmail.com";
    });
  }
}
