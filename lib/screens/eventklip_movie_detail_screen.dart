import 'package:eventklip/di/injection.dart';
import 'package:eventklip/fragments/comment_fragment.dart';
import 'package:eventklip/models/homemovie_model.dart';
import 'package:eventklip/screens/view_all_movies_screen.dart';
import 'package:eventklip/services/movie_service.dart';
import 'package:eventklip/skeletons/movietile_skeleton.dart';
import 'package:eventklip/ui/parts/eventklip_video_player.dart';
import 'package:eventklip/ui/widgets/user_avatar_widget.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/resources/colors.dart';
import 'package:eventklip/utils/utility.dart';
import 'package:eventklip/view_models/app_state.dart';
import 'package:eventklip/view_models/video_detail_state.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter_countdown_timer/countdown_controller.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class EventklipVideoDetailScreen extends StatefulWidget {
  static final String tag = '/eventklipVideoDetailScreen';
  final VideoDetails movie;

  EventklipVideoDetailScreen({this.movie});

  @override
  EventklipVideoDetailScreenState createState() =>
      EventklipVideoDetailScreenState();
}

class EventklipVideoDetailScreenState extends State<EventklipVideoDetailScreen>
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

  AnimationController _bottomSheetAnimationController;
  Animation<Offset> offset;

  bool videoEnd = false;

  VideoDetails movie;

  CachedVideoPlayerController videoController;

  VideoDetailState provider;

  GlobalKey<EventklipVideoPlayerState> videoPlayer = new GlobalKey();

  bool _bottomSheetOpened = false;

  @override
  void initState() {
    super.initState();
    movie = widget.movie;
    attachBottomSheet();
    _addCountdownForVideo(movie);
  }

  _addCountdownForVideo(VideoDetails videoDetails) {
    final old = countdownController;
    final countDown = CountdownController(
        duration: Duration(
            seconds:
                convertTimeSpanToDuration(videoDetails.duration).inSeconds ~/
                    5));
    countdownController = countDown;
    countdownController.start();
    old?.removeListener(countdownListener);
    old?.dispose();
    countdownController.addListener(countdownListener);
  }

  countdownListener() {
    if (countdownController.currentRemainingTime.sec == 0) {
      MovieService _movieService = getIt.get<MovieService>();
      _movieService.createView(movie.id, provider.currentPosition);
    }
  }

  void attachBottomSheet() {
    _bottomSheetAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    offset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(_bottomSheetAnimationController);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    /* var ratio;
    if (isFullScreen) {
      ratio = width / height;
    } else {
      ratio = 16 / 9;
    }*/

    var modalHeight = height - width / (16 / 9);
    return ChangeNotifierProvider<VideoDetailState>(
      create: (BuildContext context) => VideoDetailState(movie.id),
      builder: (context, child) {
        return WillPopScope(
          onWillPop: () async {
            if (!videoPlayer.currentState.isFullScreen) {
              if (!_bottomSheetOpened) return true;
              closeBottomSheet();
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
                        videoTitle: movie.title,
                        videoUrl: "$assetUrl${movie.fileLocation}",
                        onCurrentPositionChanged: (position) {
                          final provider = Provider.of<VideoDetailState>(
                              context,
                              listen: false);
                          provider.setCurrentPosition(position);
                        },
                        onDurationChanged: (duration) {
                          provider.setDuration(duration);
                        },
                        onControllerChanged: (controller) {
                          this.videoController = controller;
                        },
                        onVideoEnd: () {
                          final video = Provider.of<VideoDetailState>(context,
                                  listen: false)
                              .relatedVideos
                              .first;
                          resetScreenWithVideo(video, context);
                        },
                      )),
                    ],
                  ),
                  Expanded(child: _buildBottom(modalHeight, context))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottom(double modalHeight, BuildContext context) {
    return Stack(
      children: [
        _buildMovieDetails(modalHeight, context),
        _buildBottomSheet(modalHeight)
      ],
    );
  }

  Widget _buildBottomSheet(double modalHeight) {
    return SlideTransition(
        position: offset,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Container(
            height: modalHeight,
            color: Theme.of(context).cardColor,
            child: CommentFragment(movie.id, seekVideoTo, closeBottomSheet),
          ),
        ));
  }

  void closeBottomSheet() {
    _bottomSheetAnimationController.reverse();
    _bottomSheetOpened = false;
  }

  Widget _buildMovieDetails(double modalHeight, BuildContext context) {
    var tags = movie.videoTags != null && movie.videoTags.isNotEmpty
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: movie.videoTags
                    .map(
                      (e) => Chip(
                        label: Text(
                          e,
                          style:
                              TextStyle(color: textColorPrimary, fontSize: 12),
                        ),
                        backgroundColor: colorPrimary,
                      ).paddingRight(spacing_standard),
                    )
                    .toList()),
          )
        : Container();
    return Container(
        height: modalHeight,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              headingText(context,
                      "${movie.title} | Views - ${movie.views ?? "0"}" ?? "")
                  .paddingOnly(
                      top: spacing_standard_new,
                      left: spacing_standard_new,
                      right: spacing_standard_new),
              tags.paddingOnly(
                  left: spacing_standard_new, right: spacing_standard_new),
              MoreLessText(movie.description ?? "--").paddingOnly(
                  left: spacing_standard_new,
                  right: spacing_standard_new,
                  bottom: spacing_standard_new),
              Divider(
                color: Colors.grey,
              ),
              // buttons,
              // Divider(
              //   color: Colors.grey,
              // ),
              movie.canComment
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<VideoDetailState>(
                          builder: (context, provider, child) {
                            return headingText(context,
                                    "Comments  ${provider.comments?.length ?? ""}")
                                .paddingOnly(
                              left: spacing_standard_new,
                              right: spacing_standard_new,
                              bottom: spacing_control,
                            );
                          },
                        ),
                        Row(
                          children: [
                            UserAvatarWithInitials(
                              Provider.of<EventklipAppState>(context,
                                      listen: false)
                                  .userProfile
                                  .fullname,
                              size: 35,
                            ).paddingOnly(right: 10),
                            Expanded(
                              child: RaisedButton(
                                color: cardColor,
                                splashColor: colorPrimary,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(ts_medium_small)),
                                onPressed: () => _slideUpCommentSheet(context),
                                child: Text(
                                  "Add a comment",
                                  style: TextStyle(color: textColorPrimary),
                                ),
                              ),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: spacing_standard_new)
                      ],
                    ).onTap(() => _slideUpCommentSheet(context))
                  : text(context, "Comments are turned off for this video",
                          fontStyle: FontStyle.italic)
                      .paddingSymmetric(horizontal: spacing_standard_new),
              Divider(
                color: Colors.grey,
              ),
              Divider(
                thickness: 1,
                height: 1,
              ).paddingTop(spacing_standard),
              Consumer<VideoDetailState>(
                builder: (context, state, child) {
                  provider = state;
                  return state.fetchStatus == FetchStatus.loaded
                      ? Column(
                          children: [
                            headingWidViewAll(context, "Related Videos", () {
                              videoPlayer.currentState?.pause();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewAllVideoScreen(
                                            title: "Related Videos",
                                            videos: state.relatedVideos,
                                          )));
                            },
                                    showViewAll:
                                        (state.relatedVideos?.length ?? 0) >= 4)
                                .paddingOnly(
                                    left: spacing_standard_new,
                                    right: spacing_standard_new,
                                    top: 12,
                                    bottom: spacing_standard_new),
                            ItemHorizontalList(
                                state.relatedVideos.length >= 4
                                    ? state.relatedVideos?.sublist(0, 4)
                                    : state.relatedVideos,
                                isMovie: false, onVideoTap: (video) {
                              resetScreenWithVideo(video, context);
                            }),
                          ],
                        )
                      : MovieTileSkeleton(
                          state.fetchStatus,
                          skeletonType: SkeletonType.relatedVideoTile,
                        );
                },
              ),
            ],
          ),
        ));
  }

  void _slideUpCommentSheet(BuildContext context) {
    Provider.of<VideoDetailState>(context, listen: false).getComments();
    _bottomSheetOpened = true;
    _bottomSheetAnimationController.forward();
  }

  Widget getActionButtons() {
    return Row(
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
            Icons.file_download,
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
      ],
    ).paddingSymmetric(horizontal: spacing_standard_new);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    WidgetsBinding.instance.removeObserver(this);
    _bottomSheetAnimationController.dispose();
    countdownController?.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  seekVideoTo(Duration duration) {
    videoPlayer.currentState.seekTo(duration);
  }

  void resetScreenWithVideo(VideoDetails video, BuildContext context) {
    setState(() {
      movie = video;
    });
    Provider.of<VideoDetailState>(context, listen: false).reset(video.id);
    _addCountdownForVideo(video);
  }
}
