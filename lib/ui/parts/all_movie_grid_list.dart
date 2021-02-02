import 'package:eventklip/models/homemovie_model.dart';
import 'package:eventklip/screens/eventklip_movie_detail_screen.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AllMovieGridList extends StatelessWidget {
  final list ;
  final isHorizontal = false;

  AllMovieGridList(this.list);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        padding:
        EdgeInsets.only(left: 11, right: 11, top: spacing_standard_new),
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 9 / 9),
        scrollDirection: Axis.vertical,
        controller: ScrollController(keepScrollOffset: false),
        itemBuilder: (context, index) {
          VideoDetails bookDetail = list[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventklipVideoDetailScreen(
                        movie: list[index],
                      )));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: spacing_control_half,
                    margin: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(spacing_control),
                    ),
                    child: networkImage(bookDetail.thumbnailLocation,
                        aWidth: double.infinity,
                        aHeight: double.infinity,
                        fit: BoxFit.cover),
                  ),
                ),
                itemTitle(context, list[index].title)
                    .paddingTop(spacing_control_half),
                itemSubTitle(context,
                    "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.",
                    isLongText: false),
              ],
            ),
          ).paddingOnly(left: 5, right: 5, bottom: spacing_standard_new);
        },
      ),
    );
  }
}