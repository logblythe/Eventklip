import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventklip/fragments/sub_home_fragment.dart';
import 'package:eventklip/utils/app_widgets.dart';

class HomeFragment extends StatefulWidget {
  static String tag = '/HomeFragment';

  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment> {

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: muviTitle(context),
          // actions: <Widget>[notificationIcon(context, 2)],
          // bottom: PreferredSize(
          //   preferredSize: Size(double.infinity, 45),
          //   child: Align(
          //     alignment: Alignment.topLeft,
          //     child: TabBar(
          //       isScrollable: true,
          //       indicatorPadding: EdgeInsets.only(left: 30, right: 30),
          //       indicatorWeight: 3.0,
          //       indicatorSize: TabBarIndicatorSize.tab,
          //       labelStyle: TextStyle(
          //         fontFamily: font_medium,
          //         fontSize: ts_normal,
          //       ),
          //       indicatorColor: Theme.of(context).primaryColor,
          //       unselectedLabelColor: Theme.of(context).textTheme.headline6.color,
          //       labelColor: Theme.of(context).primaryColor,
          //       labelPadding:
          //           EdgeInsets.only(left: spacing_large, right: spacing_large),
          //       tabs: [
          //         Tab(child: Text(keyString(context, "home"))),
          //         Tab(child: Text(keyString(context, "movies"))),
          //         Tab(child: Text(keyString(context, "tv_shows"))),
          //       ],
          //     ),
          //   ),
          // ),
        ),
        body:HomeCategoryFragment()
      /*  body: true? HomeCategoryFragment() :TabBarView(
          children: <Widget>[
            HomeCategoryFragment(
              type: "Featured",
            ),
            MovieCategoryFragment(
              type: "Featured",
            ),
            ShowsCategoryFragment(
              type: "Featured",
            ),
          ],
        ),*/
      ),
    );
  }
}
