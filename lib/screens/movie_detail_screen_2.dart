import 'package:eventklip/models/homemovie_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:eventklip/screens/view_movie_screen.dart';
import 'package:eventklip/utils/app_localizations.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/resources/images.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class MovieDetail2Screen extends StatefulWidget {
  static String tag = '/MovieDetail2Screen';
  final VideoDetails movie;

  MovieDetail2Screen({@required this.movie});

  @override
  MovieDetail2ScreenState createState() => MovieDetail2ScreenState();
}

class MovieDetail2ScreenState extends State<MovieDetail2Screen> {
  var mMovieList = List<VideoDetails>();
  var mMovieOriginalsList = List<VideoDetails>();
  var trailerVideo;
  var isloaded = false;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var buttons = Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: iconButton(
                    context, keyString(context, "play"), ic_play_outlined, () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MovieScreen()));
        }, padding: spacing_standard)
                .paddingRight(spacing_standard)),
        Expanded(
            child: iconButton(
                    context, keyString(context, "my_list"), ic_add, () {},
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                    buttonTextColor: Theme.of(context).primaryColor,
                    iconColor: Theme.of(context).primaryColor,
                    padding: spacing_standard)
                .paddingLeft(spacing_standard)),
      ],
    ).paddingOnly(
        left: spacing_standard_new,
        right: spacing_standard_new,
        top: spacing_standard_new);

    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: width * 16 / 11,
                  floating: false,
                  pinned: true,
                  titleSpacing: 0,
                  leading: InkWell(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onTap: () {
                      finish(context);
                    },
                    radius: spacing_standard_new,
                  ),
                  backgroundColor: Theme.of(context).cardTheme.color,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: <Widget>[
                        networkImage(widget.movie.thumbnailLocation,
                            aWidth: width,
                            aHeight: width * (16 / 11),
                            fit: BoxFit.cover),
                        Container(
                          child: Column(
                            children: <Widget>[
                              text(context, widget.movie.title,
                                      fontSize: ts_xlarge,
                                      textColor: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .color,
                                      fontFamily: font_bold)
                                  .paddingOnly(
                                      left: spacing_standard_new,
                                      right: spacing_standard_new),
                              Row(
                                children: <Widget>[
                                  itemSubTitle(context, "1h 29m"),
                                  Container(
                                    decoration: boxDecoration(context,
                                        color: Theme.of(context)
                                            .textTheme
                                            .subtitle2
                                            .color,
                                        bgColor: Colors.transparent),
                                    child: text(context, "HD",
                                        fontSize: ts_medium_small),
                                    padding: EdgeInsets.only(
                                        left: spacing_control_half,
                                        right: spacing_control_half,
                                        top: 0,
                                        bottom: 0),
                                  ).paddingLeft(spacing_control_half)
                                ],
                                crossAxisAlignment: CrossAxisAlignment.center,
                              ).paddingOnly(
                                  left: spacing_standard_new,
                                  right: spacing_standard_new,
                                  top: spacing_control),
                              Row(
                                children: <Widget>[
                                  itemSubTitle(context, "Adventure"),
                                  Container(
                                    color: Theme.of(context).primaryColor,
                                    padding:
                                        EdgeInsets.all(spacing_control_half),
                                  ).paddingAll(spacing_control),
                                  itemSubTitle(context, "Romantic"),
                                  Container(
                                    color: Theme.of(context).primaryColor,
                                    padding:
                                        EdgeInsets.all(spacing_control_half),
                                  ).paddingAll(spacing_control),
                                  itemSubTitle(context, "Thriller"),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.center,
                              ).paddingOnly(
                                  left: spacing_standard_new,
                                  right: spacing_standard_new,
                                  top: spacing_control),
                              buttons
                            ],
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          height: width,
                          alignment: Alignment.bottomLeft,
                          decoration: BoxDecoration(
                              gradient: new LinearGradient(
                                  colors: [
                                Colors.transparent,
                                Theme.of(context).scaffoldBackgroundColor,
                              ],
                                  stops: [
                                0.0,
                                1.0
                              ],
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                  tileMode: TileMode.repeated)),
                        )
                      ],
                      alignment: Alignment.bottomLeft,
                    ),
                  ),
                  title: toolBarTitle(context, "The Silence")
                      .visible(innerBoxIsScrolled),
                ),
              ];
            },
            body: RefreshIndicator(
              onRefresh: () {
                return getData();
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    itemSubTitle(context,
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."),
                    itemSubTitle(context,
                        "Cast: Kimen Shikla, Stanley Tucci, Miranda Otto",
                        colorThird: true, fontsize: ts_medium),
                    itemSubTitle(context, "Director: John R. Leonetti",
                        colorThird: true, fontsize: ts_medium),
                  ],
                ).paddingAll(spacing_standard_new),
              ),
            ),
          ),
          Center(child: loadingWidgetMaker()).visible(isLoading)
        ],
      ),
    );
  }
}
