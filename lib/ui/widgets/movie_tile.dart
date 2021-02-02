import 'package:eventklip/models/homemovie_model.dart';
import 'package:eventklip/screens/eventklip_movie_detail_screen.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/colors.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class MovieTile extends StatelessWidget {
  final VideoDetails movie;
  final Function(VideoDetails) onVideoTap;

  MovieTile( this.movie, {this.onVideoTap});


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(left: spacing_standard),
      width: (width / 1.7) - 36,
      child: InkWell(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: spacing_control,
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing_control),
              ),
              child: networkImage(movie.thumbnailLocation, aWidth: double.infinity, aHeight: double.infinity),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                movie.duration!=null ? Container(
                  child: Text(movie.duration, style: boldTextStyle(size: 10,color: textColorPrimary)),
                  decoration: BoxDecoration(color: colorPrimary, borderRadius: radius(4)),
                  padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                ):Container(),
                4.height,
                itemTitle(context, movie.title.validate(),),
              ],
            ).paddingAll(8),
          ],
        ),
        onTap: onVideoTap!=null ? ()=>onVideoTap(movie) :() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventklipVideoDetailScreen(
                    movie: movie,
                  )));
        },
        radius: spacing_control,
      ),
    );
  }
}
