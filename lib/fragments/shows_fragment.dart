import 'package:eventklip/models/homemovie_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventklip/screens/view_all_movies_screen.dart';
import 'package:eventklip/utils/app_localizations.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/data_generator.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class ShowsCategoryFragment extends StatefulWidget {
  static String tag = '/ShowsCategoryFragment';
  var type;

  ShowsCategoryFragment({this.type});

  @override
  ShowsCategoryFragmentState createState() => ShowsCategoryFragmentState();
}

class ShowsCategoryFragmentState extends State<ShowsCategoryFragment> {
  var mSliderList = List<VideoDetails>();
  var mMovieList = List<VideoDetails>();
  var mCinemaMovieList = List<VideoDetails>();
  var mcontinueList = List<VideoDetails>();
  var mTrendingMuviList = List<VideoDetails>();
  var mMadeForYouList = List<VideoDetails>();
  bool isLoading = false;

  showLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    setState(() {
      mSliderList.addAll(getShowsSliders());
      mMovieList.addAll(getPopularShows());
      mCinemaMovieList.addAll(getInternationalShows());
      mTrendingMuviList.addAll(getTrendingOnMovie());
    });
  }

  @override
  Widget build(BuildContext context) {
    var slider =
        mSliderList.isNotEmpty ? HomeSliderWidget(mSliderList) : Container();

    var popularMovieList = mMovieList.isNotEmpty
        ? ItemHorizontalList(
            mMovieList,
            isMovie: false,
          )
        : Container();
    var trendingMovieList = mTrendingMuviList.isNotEmpty
        ? ItemHorizontalList(
            mTrendingMuviList,
            isMovie: false,
          )
        : Container();
    var newCinemaList = mCinemaMovieList.isNotEmpty
        ? ItemHorizontalList(
            mCinemaMovieList,
            isMovie: false,
          )
        : Container();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                slider.paddingTop(spacing_standard_new),
                headingWidViewAll(context, keyString(context, "popular_show"),
                    () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewAllVideoScreen(
                              title: keyString(context, "popular_show"))));
                }).paddingAll(spacing_standard_new),
                popularMovieList,
                headingWidViewAll(context, keyString(context, "best_show"), () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewAllVideoScreen(
                              title: keyString(context, "best_show"))));
                }).paddingAll(spacing_standard_new),
                newCinemaList,
                headingWidViewAll(context, keyString(context, "show_recommend"),
                    () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewAllVideoScreen(
                              title: keyString(context, "show_recommend"))));
                }).paddingAll(spacing_standard_new),
                trendingMovieList.paddingBottom(spacing_standard_new)
              ],
            ),
          ),
          Center(child: loadingWidgetMaker().visible(isLoading))
        ],
      ),
    );
  }
}
