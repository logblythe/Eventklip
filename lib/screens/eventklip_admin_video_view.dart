import 'package:eventklip/models/homemovie_model.dart';
import 'package:eventklip/ui/parts/eventklip_video_player.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_controller.dart';

class VideoViewScreen extends StatefulWidget {
  static final String tag = '/VideoViewScreen';
  final String videoUrl;

  VideoViewScreen({this.videoUrl});

  @override
  VideoViewScreenState createState() => VideoViewScreenState();
}

class VideoViewScreenState extends State<VideoViewScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CountdownController countdownController;

  var mMovieList = List<VideoDetails>();
  var isLoaded = false;
  bool showOverLay = false;
  bool isFullScreen = false;
  bool isBuffering = false;
  var mMovieOriginalsList = List<VideoDetails>();
  var isExpanded = false;

  bool relatedVideoLoading = false;

  Animation<Offset> offset;

  bool videoEnd = false;

  CachedVideoPlayerController videoController;

  GlobalKey<EventklipVideoPlayerState> videoPlayer = new GlobalKey();

  bool _bottomSheetOpened = false;

  @override
  Widget build(BuildContext context) {
    print(widget.videoUrl);
    return WillPopScope(
      onWillPop: () async {
        if (!videoPlayer.currentState.isFullScreen) {
          if (!_bottomSheetOpened) return true;
          return false;
        } else {
          videoPlayer.currentState.toggleFullScreen();
          return false;
        }
      },
      child: SafeArea(
        top: videoPlayer.currentState == null
            ? true
            : !videoPlayer.currentState.isFullScreen,
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).viewInsets.top),
                  color: Colors.green,
                  child: Container()),
              Stack(
                children: <Widget>[
                  Center(
                      child: EventklipVideoPlayer(
                    key: videoPlayer,
                    videoTitle: "Video",
                    videoUrl: widget.videoUrl,
                    onCurrentPositionChanged: (position) {},
                    onDurationChanged: (duration) {},
                    onControllerChanged: (controller) {
                      this.videoController = controller;
                    },
                    onVideoEnd: () {},
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  seekVideoTo(Duration duration) {
    videoPlayer.currentState.seekTo(duration);
  }
}
