import 'package:eventklip/utils/app_widgets.dart';
import 'package:flutter/material.dart';

class TitleWithContentWidget extends StatelessWidget {
  final String title;
  final String content;
  final int index;

  const TitleWithContentWidget({Key key,this.index, this.title, this.content}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        itemTitle(context, "- $title"),
        itemSubTitle(context, content),
        Padding(padding: EdgeInsets.only(bottom: 8))
      ],
    );
  }
}
