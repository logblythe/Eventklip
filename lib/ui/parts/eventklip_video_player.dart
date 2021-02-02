import 'package:eventklip/interface/i_videoplayer.dart';
import 'package:eventklip/ui/parts/video_end_widget.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/resources/colors.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:eventklip/view_models/video_detail_state.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_controller.dart';
import 'package:provider/provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:screen/screen.dart';

class EventklipVideoPlayer extends StatefulWidget {
  final videoUrl;
  final videoTitle;
  final Function(CachedVideoPlayerController) onControllerChanged;
  final Function onVideoEnd;

  const EventklipVideoPlayer(
      {Key key,
      @required this.videoUrl,
      @required this.videoTitle,
      this.onControllerChanged,
      this.onVideoEnd})
      : super(key: key);

  @override
  EventklipVideoPlayerState createState() => EventklipVideoPlayerState();
}

class EventklipVideoPlayerState extends State<EventklipVideoPlayer>
    with WidgetsBindingObserver, IVideoPlayer, SingleTickerProviderStateMixin {
  CachedVideoPlayerController _controller;
  bool _showOverLay = false;
  bool _isFullScreen = false;
  bool _isBuffering = false;
  AnimationController _animationController;
  Animation<double> timerOffset;
  var videoEnd = false;

  CountdownController _countdownController;

  @override
  void didUpdateWidget(covariant EventklipVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _initializeAndPlay(widget.videoUrl);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _initializeAnimator();
    _initializeAndPlay(widget.videoUrl);
    Screen.keepOn(true);
  }

  void _initializeAndPlay(String videoUrl) async {
    final controller =
        CachedVideoPlayerController.network("$assetUrl${widget.videoUrl}");

    final old = _controller;
    final oldAspectRatio = old?.value?.aspectRatio;
    if (old != null) {
      old.removeListener(_videoControllerListener);
      old.pause(); // mute instantly
    }
    _controller = controller;
    setState(() {});

    controller
      ..initialize().then((_) {
        old?.dispose();
        controller.addListener(_videoControllerListener);
        controller.play();
        final newAspectRatio = controller.value.aspectRatio;

        if (_isFullScreen &&
            oldAspectRatio != null &&
            needChangeFullScreenOrientation(oldAspectRatio, newAspectRatio)) {
          toggleOrientation(controller);
        }
        setState(() {
          _showOverLay = false;
        });
      });

    widget.onControllerChanged(_controller);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      if (mounted) {
        _controller.pause();
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = _isFullScreen
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width * 9 / 16;
    var width = MediaQuery.of(context).size.width;
    print("width $width $height}");
    var overlay = Container(
      color: Colors.black38,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Consumer<VideoDetailState>(builder: (context, state, child) {
                    return text(context,
                            state.currentPosition + " / " + state.duration,
                            textColor:
                                Theme.of(context).textTheme.headline6.color)
                        .paddingLeft(spacing_standard);
                  }),
                  IconButton(
                    icon: Icon(_isFullScreen
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen),
                    onPressed:
                        _controller.value.initialized ? toggleFullScreen : null,
                  ),
                ],
              ),
              VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                    backgroundColor: Colors.grey[400],
                    bufferedColor: Colors.white,
                    playedColor: colorPrimary),
                padding: EdgeInsets.symmetric(vertical: 3),
              ),
            ],
          ),
          Center(
            child: videoEnd
                ? VideoEndWidget(timerOffset, () {
                    _animationController.stop();
                    onVideoEnd(false);
                    widget.onVideoEnd();
                  })
                : IconButton(
                    icon: Icon(
                      getCenterIcon(),
                      color: Colors.white,
                      size: 56.0,
                    ),
                    onPressed: () {
                      setState(() {
                        print(
                            "_controller.value.isPlaying, ${_controller.value.isPlaying}");
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                  ).visible(!_isBuffering),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
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
                        if (_isFullScreen) {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                            DeviceOrientation.portraitDown,
                          ]);
                          _isFullScreen = !_isFullScreen;
                          SystemChrome.setEnabledSystemUIOverlays(
                              [SystemUiOverlay.bottom]);
                        } else {
                          finish(context);
                        }
                      },
                    ),
                    toolBarTitle(context, widget.videoTitle)
                        .visible(_isFullScreen)
                  ],
                ),
              ),
            ).visible(_showOverLay),
          )
        ],
      ),
    ).onTap(toggleOverlay);
    var moviePoster = AnimatedContainer(
      width: width,
      height: height,
      // aspectRatio: _controller.value.aspectRatio,
      duration: Duration(milliseconds: 400),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[

          _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: CachedVideoPlayer(
                    _controller,
                  ),
                )
              : Container(),
          Stack(
            children: <Widget>[
              GestureDetector(onTap: toggleOverlay),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 50),
                reverseDuration: Duration(milliseconds: 200),
                child: _showOverLay ? overlay : SizedBox.shrink(),
              ),
            ],
          ),
          Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ).visible(_isBuffering),
        ],
      ),
    );
    // return moviePoster;
    ///aspect ratio = width/height
    return moviePoster;
    // return SizedBox(height: height, child: moviePoster);
  }

  IconData getCenterIcon() {
    return _controller.value.isPlaying ? Icons.pause : Icons.play_arrow;
  }

  @override
  void dispose() {
    super.dispose();
    Screen.keepOn(false);
    _animationController?.dispose();
    _controller?.dispose();
    _countdownController?.dispose();
  }

  void _videoControllerListener() {
    setBuffering();
    if (_controller.value.duration == null ||
        _controller.value.position == null) {
      return;
    }
    if (mounted) {
      final provider = Provider.of<VideoDetailState>(context, listen: false);
      provider.setCurrentPosition(_controller.value.position.inMilliseconds);
      provider.setDuration(_controller.value.duration.inMilliseconds);

      if (_controller.value.position == _controller.value.duration) {
        onVideoEnd(true);
      } else {
        if (videoEnd) {
          if (!_controller.value.isPlaying) {
            _controller.play();
          }
        }
        onVideoEnd(false);
      }
    }
  }

  @override
  void pause() {
    _controller.pause();
  }

  @override
  void forcePlay(String videoUrl) {
    _initializeAndPlay(videoUrl);
  }

  @override
  void seekTo(Duration duration) {
    _controller.seekTo(duration);
    // ignore: unnecessary_statements
    !_controller.value.isPlaying ? _controller.play() : {};
  }

  void _initializeAnimator() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    timerOffset =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.completed) {
        widget.onVideoEnd();
      }
    });
  }

  bool get isFullScreen => _isFullScreen;

  void toggleFullScreen() {
    if (isFullScreen) {

      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    } else {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    }
    if (_controller.value.aspectRatio >= 1) {
      setState(() {
        !_isFullScreen
            ? SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeRight,
                DeviceOrientation.landscapeLeft,
              ])
            : SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
        _isFullScreen = !_isFullScreen;
      });
    } else {
      setState(() {
        _isFullScreen = !_isFullScreen;
      });
    }
  }

  void setBuffering() {
    if (_isBuffering != _controller.value.isBuffering) {
      setState(() {
        _isBuffering = _controller.value.isBuffering;
      });
    }
  }

  void onVideoEnd(bool videoEnd) {
    if (this.videoEnd == videoEnd) return;
    setState(() {
      this.videoEnd = videoEnd;
      toggleOverlay(force: true);
    });

    if (videoEnd) {
      _animationController.forward();
    } else {
      _animationController.reset();
    }
  }

  void toggleOverlay({bool force}) {
    if (!_showOverLay) {
      _initializeAndStartCountdown();
    }
    setState(() {
      _showOverLay = force ?? !_showOverLay;
    });
  }

  void _initializeAndStartCountdown() {
    final old = _countdownController;
    final countDown = CountdownController(
        duration: Duration(seconds: OVERLAY_TIMER_DURATION));
    _countdownController = countDown;
    old?.removeListener(_countDownListener);
    old?.dispose();
    _countdownController.addListener(_countDownListener);
    _countdownController.start();
  }

  void _countDownListener() {
    if (_countdownController.currentRemainingTime.sec == 0 &&
        _showOverLay &&
        !videoEnd) toggleOverlay(force: false);
  }

  bool needChangeFullScreenOrientation(
      double oldAspectRatio, double newAspectRatio) {
    if (oldAspectRatio >= 1) {
      if (newAspectRatio >= 1) {
        return false;
      }
      return true;
    } else {
      if (newAspectRatio <= 1) {
        return false;
      }
      return true;
    }
  }

  void toggleOrientation(CachedVideoPlayerController _controller) {
    if (_controller.value.aspectRatio >= 1) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }
}
