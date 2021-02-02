import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventklip/screens/signin.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/dots_indicator/dots_indicator.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:eventklip/utils/resources/strings.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:eventklip/utils/widget_extensions.dart';

class OnBoardingScreen extends StatefulWidget {
  static String tag = '/OnBoardingScreen';

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndexPage = 0;
  PageController _controller = new PageController();

  @override
  Widget build(BuildContext context) {
    var pageView = PageView(
      controller: _controller,
      children: <Widget>[
        WalkThrough(
          title: walk_titles[0],
          subtitle: walk_sub_titles[0],
        ),
        WalkThrough(
          title: walk_titles[1],
          subtitle: walk_sub_titles[1],
        ),
        WalkThrough(
          title: walk_titles[2],
          subtitle: walk_sub_titles[2],
        ),
      ],
      onPageChanged: (value) {
        setState(() => currentIndexPage = value);
      },
    );
    var startButton = SizedBox(
      width: double.infinity,
      child: button(context, "Get Started", () {
        launchScreen(context, SignInScreen.tag);
      }),
    );
    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: [

        assetImage("assets/images/collage.jpg",
            aWidth: double.infinity,
            aHeight: MediaQuery.of(context).size.height,
            fit: BoxFit.cover),
        Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
              gradient:  LinearGradient(
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                  stops: [
                    0.0,
                    1.0
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  tileMode: TileMode.repeated)),
        ),
        SafeArea(
            child:
                Align(alignment: Alignment.topLeft, child: muviTitle(context))
                    .paddingAll(spacing_standard_new)),
        Container(
            height: double.infinity,
            child: pageView.paddingTop(spacing_standard)),
        Container(
          alignment: Alignment.topLeft,
          height: double.infinity,
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.6),
          child: DotsIndicator(
                  dotsCount: 3,
                  position: currentIndexPage,
                  decorator: dotsDecorator(context))
              .paddingAll(spacing_standard_new),
        ),
        startButton.paddingAll(spacing_standard_new)
      ],
    ));
  }
}

class WalkThrough extends StatelessWidget {
  final String title;
  final String subtitle;

  WalkThrough({Key key, this.title, this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.height;
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(bottom: width * 0.4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text(context, title,
                  fontSize: ts_large,
                  fontFamily: font_bold,
                  textColor: Theme.of(context).textTheme.headline6.color)
              .paddingOnly(
                  left: spacing_standard_new,
                  right: spacing_standard_new,
                  top: spacing_standard_new),
          text(
            context,
            subtitle,
            fontSize: ts_normal,
            textColor: Theme.of(context).textTheme.headline6.color,
            maxLine: 2,
          ).paddingOnly(
              top: spacing_control,
              left: spacing_standard_new,
              right: spacing_standard_new),
        ],
      ),
    );
  }
}
