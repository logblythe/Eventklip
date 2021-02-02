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
class MovieCategoryFragment extends StatefulWidget {
  static String tag = '/MovieCategoryFragment';
  var type;

  MovieCategoryFragment({this.type});

  @override
  MovieCategoryFragmentState createState() => MovieCategoryFragmentState();
}

class MovieCategoryFragmentState extends State<MovieCategoryFragment> {
  var mSliderList = List<VideoDetails>();
  var mBlockbustersLisr = List<VideoDetails>();
  var mRecommended = List<VideoDetails>();
  var mcontinueList = List<VideoDetails>();
  var mBestMovies = List<VideoDetails>();
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
      mSliderList.addAll(getMovieSliders());
      mBlockbustersLisr.addAll(getUpcomingMovie());
      mRecommended.addAll(getTop10());
      mBestMovies.addAll(getContinueMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    var slider = mSliderList.isNotEmpty
        ? HomeSliderWidget(
            mSliderList,
            isMovie: true,
          )
        : Container();

    var blockBustersList = mBlockbustersLisr.isNotEmpty
        ? ItemHorizontalList(
            mBlockbustersLisr,
            isMovie: true,
          )
        : Container();
    var trendingMovieList = mBestMovies.isNotEmpty
        ? ItemHorizontalList(
            mBestMovies,
            isMovie: true,
          )
        : Container();
    var newCinemaList = mRecommended.isNotEmpty
        ? ItemHorizontalList(
            mRecommended,
            isMovie: true,
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
                headingWidViewAll(context, keyString(context, "bolly_block"),
                    () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewAllVideoScreen(
                              title: keyString(context, "bolly_block"))));
                }).paddingAll(spacing_standard_new),
                blockBustersList,
                headingWidViewAll(context, keyString(context, "best_bengali"),
                    () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewAllVideoScreen(
                              title: keyString(context, "best_bengali"))));
                }).paddingAll(spacing_standard_new),
                newCinemaList,
                headingWidViewAll(
                    context, keyString(context, "movie_recommend"), () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewAllVideoScreen(
                              title: keyString(context, "movie_recommend"))));
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
