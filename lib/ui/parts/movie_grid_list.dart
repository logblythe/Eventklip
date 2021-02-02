import 'package:eventklip/models/homemovie_model.dart';
import 'package:eventklip/screens/eventklip_movie_detail_screen.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/colors.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class MovieGridList extends StatelessWidget {
  final list;
  final isHorizontal = false;

  MovieGridList(this.list);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 4, right: 4),
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 14 / 9),
        scrollDirection: Axis.vertical,
        controller: ScrollController(keepScrollOffset: false),
        itemBuilder: (context, index) {
          VideoDetails video = list[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventklipVideoDetailScreen(
                        movie: video,
                      )));
            },
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: spacing_control_half,
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing_control),
              ),
              child: Stack(
                children: [
                  Positioned(
                    child: networkImage(
                        video.thumbnailLocation,
                        fit: BoxFit.cover,aHeight: double.infinity,aWidth: double.infinity
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.only(left: 4),
                      width: MediaQuery.of(context).size.width/2,
                      color: Colors.black.withOpacity(0.3),
                      child: Text(list[index].title,style: TextStyle(color: textColorPrimary),),
                    ),
                  )
                ],
              ),
            ),
          ).paddingAll(6);
        },
      ),
    );
  }
}