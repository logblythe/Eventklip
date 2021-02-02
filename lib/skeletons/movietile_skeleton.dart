import 'package:eventklip/utils/resources/size.dart';
import 'package:eventklip/utils/widget_extensions.dart';
import 'package:eventklip/view_models/video_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nb_utils/nb_utils.dart';

class MovieTileSkeleton extends StatelessWidget {
  final fetchStatus;
  final SkeletonType skeletonType;

  MovieTileSkeleton(this.fetchStatus,
      {this.skeletonType = SkeletonType.relatedVideoTile});

  @override
  Widget build(BuildContext context) {
    /*var width = MediaQuery
        .of(context)
        .size
        .width;*/
    return fetchStatus == FetchStatus.loading
        ? getSkeleton()
        : errorWidget();
  }

  Widget getSkeleton() {
    switch (skeletonType) {
      case SkeletonType.homepage:
        return SingleChildScrollView(
            child: Column(
              children: [
                SliderSkeleton(),
                ApplicationGroupTile(),
                ApplicationGroupTile()
              ],
            ));
        break;
      case SkeletonType.relatedVideoTile:
        return ApplicationGroupTile();
        break;
      default:
        return Container();
    }
  }
}

class ApplicationGroupTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer(
            gradient: LinearGradient(colors: [Colors.grey[200], Colors.white]),
            child: Container(
              width: 50,
              height: 20,
              color: Colors.white,
            )).paddingAll(spacing_standard_new),
        Container(
          height: ((width / 1.7) - 36) * (2.5 / 4),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
                left: spacing_standard, right: spacing_standard_new),
            children: [
              Shimmer(
                gradient: LinearGradient(
                    colors: [Colors.grey[200].withOpacity(0.5), Colors.white]),
                child: Container(
                  margin: EdgeInsets.only(left: spacing_standard),
                  width: (width / 1.7) - 36,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: spacing_control_half,
                        margin: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(spacing_control),
                        ),
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ),
              Shimmer(
                gradient: LinearGradient(colors: [
                  Colors.grey[200].withOpacity(0.5).withOpacity(0.5),
                  Colors.white
                ]),
                child: Container(
                  margin: EdgeInsets.only(left: spacing_standard),
                  width: (width / 1.7) - 36,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: spacing_control_half,
                        margin: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(spacing_control),
                        ),
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SliderSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    final Size size = Size(width, width / 1.8);
    return Container(
      width: width,
      height: size.height,
      child: Shimmer(
        gradient: LinearGradient(
            colors: [Colors.grey[200].withOpacity(0.1), Colors.white]),
        period: Duration(milliseconds: 1000),
        child: Container(
          margin: EdgeInsets.only(left: spacing_standard),
          width: (width / 1.7) - 36,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: spacing_control_half,
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing_control),
                ),
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum SkeletonType { homepage, relatedVideoTile }
