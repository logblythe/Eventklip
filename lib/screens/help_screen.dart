import 'package:eventklip/utils/widget_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventklip/screens/faq_screen.dart';
import 'package:eventklip/utils/app_localizations.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/images.dart';

class HelpScreen extends StatefulWidget {
  static String tag = '/HelpScreen';

  @override
  HelpScreenState createState() => HelpScreenState();
}

class HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarLayout(context, keyString(context, "help")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            subType(context, "report_problem", () {}, ic_report),
            subType(context, "help_center", () {}, ic_help),
            subType(context, "faq", () {
              launchScreen(context, FaqScreen.tag);
            }, ic_faq),
          ],
        ),
      ),
    );
  }
}
