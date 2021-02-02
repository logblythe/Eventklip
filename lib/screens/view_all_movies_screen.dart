import 'package:eventklip/models/homemovie_model.dart';
import 'package:eventklip/ui/parts/all_movie_grid_list.dart';
import 'package:flutter/material.dart';
import 'package:eventklip/utils/app_widgets.dart';

// ignore: must_be_immutable
class ViewAllVideoScreen extends StatefulWidget {
  static String tag = '/ViewAllMovieScreen';
  var title = "";
  List<VideoDetails> videos;
  ViewAllVideoScreen({this.title, this.videos});

  @override
  ViewAllVideoScreenState createState() => ViewAllVideoScreenState();
}

class ViewAllVideoScreenState extends State<ViewAllVideoScreen> {
  var movieList = List<VideoDetails>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var allMovieList = AllMovieGridList(widget.videos ?? movieList);
    return Scaffold(
      appBar: appBarLayout(context, widget.title),
      body: allMovieList,
    );
  }
}
