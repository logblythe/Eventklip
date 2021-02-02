import 'dart:async';

import 'package:eventklip/models/homemovie_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventklip/screens/view_all_movies_screen.dart';
import 'package:eventklip/screens/view_movie_screen.dart';
import 'package:eventklip/utils/app_localizations.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/images.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class MovieDetailScreen extends StatefulWidget {
  static String tag = '/MovieDetailScreen';
  var title = "";
  VideoDetails movie;

  MovieDetailScreen({this.title, this.movie});

  @override
  MovieDetailScreenState createState() => MovieDetailScreenState();
}

class MovieDetailScreenState extends State<MovieDetailScreen>
    with WidgetsBindingObserver {
  var mMovieList = List<VideoDetails>();
  var mMovieOriginalsList = List<VideoDetails>();
  var trailerVideo;
  VideoPlayerController _controller;
  var isloaded = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // These are the callbacks
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      setState(() {
        _controller.pause();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    WidgetsBinding.instance.addObserver(this);

    _controller = VideoPlayerController.network(
        'https://iqonic.design/wp-themes/proshop-book/wp-content/uploads/2020/08/sample-mp4-file.mp4');

    _controller.addListener(() {
      print("listener");
      if (!_controller.value.isPlaying && !_controller.value.isBuffering) {
        setState(() {
          isloaded = false;
        });
      }
    });
    _controller.setLooping(false);
    _controller.initialize().then((_) => setState(() {
          isloaded = true;
        }));

    Timer(Duration(seconds: 2), () {
      _controller.play();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  getData() async {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    var moviePoster = AspectRatio(
      aspectRatio: isloaded ? _controller.value.aspectRatio : 16 / 9,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          VideoPlayer(_controller),
          assetImage(widget.movie.thumbnailLocation,
                  aWidth: double.infinity,
                  aHeight: double.infinity,
                  fit: BoxFit.cover)
              .visible(!isloaded),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.play_arrow, size: 28),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  headingText(context, "Watch Movie"),
                  itemTitle(context, "2 hr 30 min")
                ],
              ).paddingLeft(spacing_standard)
            ],
          ).paddingAll(spacing_standard)
        ],
      ),
    ).paddingAll(spacing_standard_new).onTap(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MovieScreen()));
      setState(() {
        _controller.pause();
        isloaded = false;
      });
    });
    var buttons = Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: iconButton(
                    context, keyString(context, "download"), ic_download, () {})
                .paddingRight(spacing_standard)),
        Expanded(
            child: iconButton(
                    context, keyString(context, "my_list"), ic_add, () {},
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    buttonTextColor:
                        Theme.of(context).textTheme.headline6.color,
                    iconColor: Theme.of(context).primaryColor)
                .paddingRight(spacing_standard)),
      ],
    ).paddingAll(spacing_standard_new);
       var moreMovieList = mMovieList.isNotEmpty
        ? ItemHorizontalList(
            mMovieList,
            isMovie: false,
          )
        : Container();
    var originalsMovieList = mMovieOriginalsList.isNotEmpty
        ? ItemHorizontalList(
            mMovieOriginalsList,
            isMovie: false,
          )
        : Container();

    return Scaffold(
      appBar: appBarLayout(context, widget.title, darkBackground: false),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            moviePoster,
            headingText(context, "The Illusion").paddingOnly(
                left: spacing_standard_new, right: spacing_standard_new),
            MoreLessText(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.")
                .paddingOnly(
                    left: spacing_standard_new, right: spacing_standard_new),
            buttons,
            headingWidViewAll(context, "U.S. Action Movies", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewAllVideoScreen(title: "U.S. Action Movies")));
            }).paddingOnly(
                left: spacing_standard_new,
                right: spacing_standard_new,
                top: 12,
                bottom: spacing_standard_new),
            moreMovieList,
            headingWidViewAll(context, "Muvi Originals Action", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewAllVideoScreen(title: "Muvi Originals Action")));
            }).paddingOnly(
                left: spacing_standard_new,
                right: spacing_standard_new,
                top: 12,
                bottom: spacing_standard_new),
            originalsMovieList.paddingBottom(spacing_standard_new),
          ],
        ),
      ),
    );
  }
}
