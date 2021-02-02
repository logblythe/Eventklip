import 'package:eventklip/models/homemovie_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:eventklip/screens/view_all_movies_screen.dart';
import 'package:eventklip/utils/app_localizations.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/data_generator.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:nb_utils/nb_utils.dart';

class MyFilesFragment extends StatefulWidget {
  static String tag = '/MyFilesFragment';

  @override
  MyFilesFragmentState createState() => MyFilesFragmentState();
}

class MyFilesFragmentState extends State<MyFilesFragment> {
  var popularMovieList = List<VideoDetails>();
  var downloadedMovieList = List<VideoDetails>();
  var mcontinueList = List<VideoDetails>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    setState(() {
      popularMovieList.addAll(getMyListMovies());
      mcontinueList.addAll(getContinueMovies());
      downloadedMovieList.addAll(getDownloadedMovies());
    });
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    var myList = ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: popularMovieList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(
            left: spacing_standard_new,
            right: spacing_standard_new,
            top: spacing_standard_new),
        itemBuilder: (context, index) {
          return Slidable(
            key: ValueKey(index),
            actionPane: SlidableDrawerActionPane(),
            child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: spacing_standard_new),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: spacing_control_half,
                        margin: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(spacing_control_half),
                        ),
                        child: assetImage(popularMovieList[index].thumbnailLocation,
                            aWidth: (width * 0.5) - 42,
                            aHeight: ((width * 0.5) - 42) * (2.5 / 4)),
                      ).paddingRight(10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            itemTitle(context, popularMovieList[index].title),
                            itemSubTitle(context, "2019"),
                            itemSubTitle(
                                context, "Action, 18+, Dark, Inspiring, Comedy",
                                colorThird: true, fontsize: ts_medium),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
            secondaryActions: <Widget>[
              new IconSlideAction(
                caption: 'Delete',
                color: Theme.of(context).errorColor,
                icon: Icons.delete_outline,
                onTap: () {},
              ),
            ],
          );
        });
    var myDownloadedList = ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: downloadedMovieList.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(
            left: spacing_standard_new,
            right: spacing_standard_new,
            top: spacing_standard_new),
        itemBuilder: (context, index) {
          return Slidable(
            key: ValueKey(index),
            actionPane: SlidableDrawerActionPane(),
            child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: spacing_standard_new),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: spacing_control_half,
                        margin: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(spacing_control_half),
                        ),
                        child: assetImage(
                            downloadedMovieList[index].thumbnailLocation,
                            aWidth: (width * 0.5) - 42,
                            aHeight: ((width * 0.5) - 42) * (2.5 / 4)),
                      ).paddingRight(10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            itemTitle(
                                context, downloadedMovieList[index].title),
                            itemSubTitle(context, "2019"),
                            itemSubTitle(
                                context, "Action, 18+, Dark, Inspiring, Comedy",
                                colorThird: true, fontsize: ts_medium),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
            secondaryActions: <Widget>[
              new IconSlideAction(
                caption: 'Delete',
                color: Theme.of(context).errorColor,
                icon: Icons.delete_outline,
                onTap: () {},
              ),
            ],
          );
        });
    var continueWatchingList = mcontinueList.isNotEmpty
        ? ItemProgressHorizontalList(
            mcontinueList,
          )
        : Container();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          title: muviTitle(context),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 45),
            child: Align(
              alignment: Alignment.topLeft,
              child: TabBar(
                indicatorPadding: EdgeInsets.only(left: 30, right: 30),
                indicatorWeight: 3.0,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(
                  fontFamily: font_medium,
                  fontSize: ts_normal,
                ),
                indicatorColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Theme.of(context).textTheme.headline6.color,
                labelColor: Theme.of(context).primaryColor,
                labelPadding:
                    EdgeInsets.only(left: spacing_large, right: spacing_large),
                tabs: [
                  Tab(child: Text(keyString(context, "my_list"))),
                  Tab(child: Text(keyString(context, "downloaded"))),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                headingWidViewAll(
                    context, keyString(context, "continue_watching"), () {
                  MaterialPageRoute(
                      builder: (context) => ViewAllVideoScreen(
                          title: keyString(context, "continue_watching")));
                }).paddingOnly(
                    left: spacing_standard_new,
                    right: spacing_standard_new,
                    top: 12,
                    bottom: spacing_standard_new),
                continueWatchingList,
                myList,
              ],
            ),
          ),
          myDownloadedList,
        ]),
      ),
    );
  }
}
