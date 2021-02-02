import 'package:eventklip/models/homemovie_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eventklip/screens/view_all_movies_screen.dart';
import 'package:eventklip/screens/view_series_episodes_screen.dart';
import 'package:eventklip/utils/app_localizations.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/duration_formatter.dart';
import 'package:eventklip/utils/resources/images.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class SeriesDetailScreen extends StatefulWidget {
  static String tag = '/SeriesDetailScreen';
  var title;

  SeriesDetailScreen({this.title});

  @override
  SeriesDetailScreenState createState() => SeriesDetailScreenState();
}

class SeriesDetailScreenState extends State<SeriesDetailScreen>
    with WidgetsBindingObserver {
  VideoPlayerController _controller;
  var isloaded = false;
  bool showOverLay = false;
  bool isFullScreen = false;
  int _currentPosition = 0;
  int _duration = 0;
  bool isBuffering = false;
  var actors = List<VideoDetails>();
  var episodes = List<VideoDetails>();
  var mMovieOriginalsList = List<VideoDetails>();
  var isExpanded = false;

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
    WidgetsBinding.instance.addObserver(this);
    getData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller = VideoPlayerController.network(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4');
    _attachListenerToController();
    _controller.setLooping(false);
    _controller.initialize().then((_) => setState(() {
          isloaded = true;
        }));
    _controller.play();
  }

  _attachListenerToController() {
    _controller.addListener(
      () {
        isBuffering = _controller.value.isBuffering;
        if (_controller.value.duration == null ||
            _controller.value.position == null) {
          return;
        }
        if (mounted) {
          setState(() {
            _currentPosition = _controller.value.duration.inMilliseconds == 0
                ? 0
                : _controller.value.position.inMilliseconds;
            _duration = _controller.value.duration.inMilliseconds;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    var moviePoster = AspectRatio(
      aspectRatio: isloaded ? _controller.value.aspectRatio : 16 / 9,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          VideoPlayer(_controller),
          Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    showOverLay = !showOverLay;
                    print("showoverlay:" + showOverLay.toString());
                  });
                },
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 50),
                reverseDuration: Duration(milliseconds: 200),
                child: showOverLay
                    ? Container(
                        color: Colors.black38,
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    text(
                                            context,
                                            durationFormatter(
                                                    _currentPosition) +
                                                " / " +
                                                durationFormatter(_duration),
                                            textColor: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .color)
                                        .paddingLeft(spacing_standard),
                                    IconButton(
                                      icon: Icon(isFullScreen
                                          ? Icons.fullscreen_exit
                                          : Icons.fullscreen),
                                      onPressed: () {
                                        setState(() {
                                          !isFullScreen
                                              ? SystemChrome
                                                  .setPreferredOrientations([
                                                  DeviceOrientation
                                                      .landscapeRight,
                                                  DeviceOrientation
                                                      .landscapeLeft,
                                                ])
                                              : SystemChrome
                                                  .setPreferredOrientations([
                                                  DeviceOrientation.portraitUp,
                                                  DeviceOrientation
                                                      .portraitDown,
                                                ]);
                                          isFullScreen = !isFullScreen;
                                        });
                                      },
                                    ).visible(!isBuffering)
                                  ],
                                ),
                                VideoProgressIndicator(
                                  _controller,
                                  allowScrubbing: true,
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                ),
                              ],
                            ),
                            Center(
                              child: IconButton(
                                icon: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 56.0,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                    showOverLay = _controller.value.isPlaying
                                        ? false
                                        : true;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ).onTap(() {
                        setState(() {
                          showOverLay = !showOverLay;
                          print("showoverlay:" + showOverLay.toString());
                        });
                      })
                    : SizedBox.shrink(),
              ),
            ],
          ),
          Center(
            child: loadingWidgetMaker(),
          ).visible(isBuffering)
        ],
      ),
    );
    var actorsList = Container(
      height: width * 0.32, //32
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: actors.length,
          itemBuilder: (context, index) {
            return Container(
              width: width * 0.18, //18
              margin: EdgeInsets.only(left: spacing_standard_new),
              child: Column(
                children: <Widget>[
                  InkWell(
                    radius: width * 0.1,
                    child: CircleAvatar(
                      radius: width * 0.09,
                      backgroundImage: actors[index].thumbnailLocation != null
                          ? AssetImage(actors[index].thumbnailLocation)
                          : AssetImage(ic_profile),
                    ),
                    onTap: () {},
                  ),
                  text(context, actors[index].title,
                          textColor:
                              Theme.of(context).textTheme.headline6.color,
                          fontFamily: font_medium,
                          maxLine: 2,
                          isCentered: true)
                      .paddingOnly(
                          left: spacing_control, right: spacing_control)
                ],
              ),
            );
          }),
    );
    var buttons = Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: IconButton(
                icon: Icon(
                  Icons.thumb_up,
                  size: 24,
                ),
                onPressed: () {})),
        Expanded(
            child: IconButton(
          icon: Icon(
            Icons.playlist_add,
            size: 24,
          ),
          onPressed: () {},
        )),
        Expanded(
            child: IconButton(
          icon: Icon(
            Icons.cloud_download,
            size: 24,
          ),
          onPressed: () {},
        )),
        Expanded(
            child: IconButton(
          icon: Icon(
            Icons.share,
            size: 24,
          ),
          onPressed: () {},
        )),
        Expanded(
            child: IconButton(
          icon: Icon(
            Icons.sentiment_dissatisfied,
            size: 24,
          ),
          onPressed: () {},
        )),
      ],
    ).paddingOnly();
    var episodesList = Container(
      height: ((width / 2) - 36) * (2.5 / 4) + 40,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: episodes.length,
          padding: EdgeInsets.only(
              left: spacing_standard, right: spacing_standard_new),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(left: spacing_standard),
              width: (width / 2) - 36,
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 4 / 2.5,
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: spacing_control_half,
                          margin: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(spacing_control),
                          ),
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: <Widget>[
                              assetImage(episodes[index].thumbnailLocation,
                                  aWidth: double.infinity,
                                  aHeight: double.infinity),
                              Container(
                                decoration: boxDecoration(context,
                                    bgColor: Colors.white.withOpacity(0.8)),
                                padding: EdgeInsets.only(
                                    left: spacing_control,
                                    right: spacing_control),
                                child: text(context,
                                    "EPISODE " + (index + 1).toString(),
                                    fontSize: 10,
                                    textColor: Theme.of(context)
                                        .textTheme
                                        .button
                                        .color,
                                    fontFamily: font_medium),
                              ).paddingAll(spacing_control)
                            ],
                          ),
                        ),
                      ),
                    ),
                    text(context, "Episode " + (index + 1).toString(),
                            textColor:
                                Theme.of(context).textTheme.headline6.color,
                            fontSize: ts_normal)
                        .paddingTop(spacing_control_half),
                    itemSubTitle(context,
                        "S1 E" + (index + 1).toString() + ", 06 Mar 2020",
                        fontsize: ts_medium),
                  ],
                ),
                onTap: () {},
                radius: spacing_control,
              ),
            );
          }),
    );
    var originalsMovieList = mMovieOriginalsList.isNotEmpty
        ? ItemHorizontalList(
            mMovieOriginalsList,
            isMovie: false,
          )
        : Container();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Center(child: moviePoster),
              SafeArea(
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          if (isFullScreen) {
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.portraitUp,
                              DeviceOrientation.portraitDown,
                            ]);
                            isFullScreen = !isFullScreen;
                          } else {
                            finish(context);
                          }
                        },
                      ),
                      toolBarTitle(context, "Jumanji: The Next Level")
                          .visible(isFullScreen)
                    ],
                  ),
                ),
              ).visible(showOverLay),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: headingText(
                        context,
                        widget.title,
                      )),
                      IconButton(
                        icon: Icon(!isExpanded
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up),
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ).paddingOnly(
                    left: spacing_standard_new,
                    right: spacing_control_half,
                  ),
                  itemSubTitle(context, "S1 E1, 06 Mar 2020").paddingOnly(
                      left: spacing_standard_new, right: spacing_standard_new),
                  itemSubTitle(context, "Episode 1").paddingOnly(
                      left: spacing_standard_new, right: spacing_standard_new),
                  Container(
                    decoration: boxDecoration(context,
                        bgColor: Theme.of(context).primaryColor,
                        radius: spacing_control),
                    padding: EdgeInsets.only(
                        left: spacing_standard,
                        right: spacing_standard,
                        top: spacing_control,
                        bottom: spacing_control),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          ic_play_outlined,
                          width: 16,
                          height: 16,
                          color: Colors.white,
                        ),
                        text(context, "Trailer",
                                fontSize: ts_15,
                                fontFamily: font_medium,
                                textColor:
                                    Theme.of(context).textTheme.button.color)
                            .paddingLeft(spacing_standard),
                      ],
                    ),
                  ).paddingAll(spacing_standard_new),
                  actorsList,
                  Column(
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
                  )
                      .paddingOnly(
                          left: spacing_standard_new,
                          right: spacing_standard_new,
                          bottom: spacing_standard_new)
                      .visible(isExpanded),
                  buttons,
                  Divider(
                    thickness: 1,
                    height: 1,
                  ).paddingTop(spacing_standard),
                  headingWidViewAll(context, "Episodes", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ViewSeriesEpisodeScreen(title: "Episodes")));
                  }).paddingAll(spacing_standard_new),
                  episodesList,
                  headingWidViewAll(
                      context, keyString(context, "show_recommend"), () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewAllVideoScreen(
                                title: keyString(context, "show_recommend"))));
                  }).paddingAll(spacing_standard_new),
                  originalsMovieList.paddingBottom(spacing_standard_new)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void getData() async {
    setState(() {
    });
  }
}
