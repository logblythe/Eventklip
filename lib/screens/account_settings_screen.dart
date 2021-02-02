import 'package:eventklip/screens/change_passwords_screen.dart';
import 'package:eventklip/utils/widget_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventklip/utils/app_localizations.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/images.dart';

class AccountSettingsScreen extends StatefulWidget {
  static String tag = '/AccountSettingsScreen';

  @override
  AccountSettingsScreenState createState() => AccountSettingsScreenState();
}

class AccountSettingsScreenState extends State<AccountSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarLayout(context, keyString(context, "account_settings")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            subType(context, "change_password", () {
              launchScreen(context, ChangePasswordScreen.tag);
            }, ic_password),
            // subType(context, "video_quality", () {}, ic_video),
            // subType(context, "download_settings", () {}, ic_download),
          ],
        ),
      ),
    );
  }
}
