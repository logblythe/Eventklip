import 'package:eventklip/models/homemovie_model.dart';
import 'package:eventklip/screens/eventklip_movie_detail_screen.dart';
import 'package:eventklip/skeletons/movietile_skeleton.dart';
import 'package:eventklip/ui/widgets/animated_tile.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/resources/colors.dart';
import 'package:eventklip/view_models/app_state.dart';
import 'package:eventklip/view_models/home_app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:eventklip/screens/view_all_movies_screen.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomeCategoryFragment extends StatefulWidget {
  static String tag = '/SubHomeFragment';
  var type;

  HomeCategoryFragment({this.type});

  @override
  HomeCategoryFragmentState createState() => HomeCategoryFragmentState();
}

class HomeCategoryFragmentState extends State<HomeCategoryFragment> {
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  showLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeAppState>(
      builder: (context, state, child) {
        final video = state.homeMovieModel?.featuredVideo;
        return Scaffold(
          key: _scaffoldKey,
          body: Stack(
            children: <Widget>[
              RefreshIndicator(
                onRefresh: () async {
                  final success = await state.fetchMovies();
                  if (!success) {
                    if (state.upcomingMoviesError.statusCode == 401) {
                      final storage = FlutterSecureStorage();
                      String email = await storage.read(key: USER_EMAIL);
                      String password = await storage.read(key: PASSWORD);
                      await Provider.of<EventklipAppState>(context, listen: false)
                          .getUserProfile(email, password);
                      showSnackbarMessage(
                        "Retrying... Please wait..",
                      );
                      await state.fetchMovies();
                    } else {
                      showSnackbarMessage(
                        "Error fetching movies!",
                      );
                    }
                  }
                },
                child: ListView(children: [
                  state.homeMovieModel != null
                      ? RefreshIndicator(
                          key: _refreshIndicatorKey,
                          onRefresh: () async {},
                          child: Column(
                            children: [
                              HomeSliderWidget([video])
                                  .paddingTop(spacing_standard_new),
                              ...renderMovieGroups(state.groups, state.videos)
                            ],
                          ),
                        )
                      : MovieTileSkeleton(
                          state.movieFetchStatus,
                          skeletonType: SkeletonType.homepage,
                        )
                ]),
              ),
              Center(child: loadingWidgetMaker().visible(isLoading))
            ],
          ),
        );
      },
    );
  }

  List<Widget> renderMovieGroups(
      List<ApplicationGroups> groups, List<VideoDetails> videos) {
    return groups.map((group) {
      final groupedVideos =
          videos.where((element) => element.grpId.contains(group.id)).toList();
      return Column(
        children: [
          headingWidViewAll(context, group.name, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewAllVideoScreen(
                        title: group.name, videos: groupedVideos)));
          }, showViewAll: groupedVideos.length > 4)
              .paddingAll(spacing_standard_new),
          ItemHorizontalList(
            groupedVideos.length > 4
                ? groupedVideos.sublist(0, 4)
                : groupedVideos,
            isMovie: true,
          ),
        ],
      );
    }).toList();
  }

  void showSnackbarMessage(message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(message),
          Icon(
            Icons.error_outline,
            color: Colors.white,
          )
        ],
      ),
      backgroundColor: colorPrimary,
    ));
  }
}

class HomeSliderWidget extends StatefulWidget {
  final List<VideoDetails> mSliderList;

  HomeSliderWidget(this.mSliderList);

  @override
  _HomeSliderWidgetState createState() => _HomeSliderWidgetState();
}

class _HomeSliderWidgetState extends State<HomeSliderWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<dynamic> animationOwner;
  Animation<dynamic> animationTitle;
  Animation<dynamic> animationViews;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animationOwner = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval((1 / 3) * 0, 1.0, curve: Curves.fastOutSlowIn)));
    animationTitle = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval((1 / 3) * 1, 1.0, curve: Curves.fastOutSlowIn)));
    animationViews = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval((1 / 3) * 2, 1.0, curve: Curves.fastOutSlowIn)));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slider = widget.mSliderList.first;
    var width = MediaQuery.of(context).size.width;
    final Size cardSize = Size(width, width / 1.8);

    return Container(
        height: cardSize.height,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: cardSize.height,
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 0,
            margin: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(spacing_control),
            ),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                networkImage(slider.thumbnailLocation,
                    aWidth: cardSize.width,
                    aHeight: cardSize.height,
                    fit: BoxFit.cover),
                Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                      gradient: new LinearGradient(
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor,
                      Colors.transparent,
                    ],
                  )),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AnimatedTile(
                        animation: animationOwner,
                        animationController: _animationController,
                        widget: Container(
                            decoration: BoxDecoration(
                                gradient: new LinearGradient(
                              colors: [
                                Colors.brown,
                                Colors.brown.withAlpha(45),
                              ],
                              stops: [0.0, 1.0],
                            )),
                            child: itemTitle(context, "${slider.owner}'s",
                                    fontSize: ts_normal)
                                .paddingAll(4)),
                      ),
                      AnimatedTile(
                          animation: animationTitle,
                          animationController: _animationController,
                          widget: itemTitle(context, slider.title,
                              fontSize: ts_normal)),
                      AnimatedTile(
                        animationController: _animationController,
                        animation: animationViews,
                        widget: Row(
                          children: <Widget>[
                            viewCountWidget(context, slider.views)
                                .paddingRight(spacing_standard)
                                .visible(slider.isHD),
                            itemSubTitle(context, slider.duration)
                                .paddingLeft(spacing_standard)
                          ],
                        ).paddingTop(spacing_control_half),
                      )
                    ],
                  ).paddingOnly(
                      left: spacing_standard_new,
                      bottom: spacing_standard_new,
                      top: 50),
                )
              ],
            ),
          ).paddingBottom(spacing_control),
        ).onTap(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EventklipVideoDetailScreen(movie: slider)));
        }));
  }

}
