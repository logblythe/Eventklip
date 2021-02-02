import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/colors.dart';
import 'package:flutter/material.dart';

class VideoEndWidget extends StatelessWidget {
  final Animation<double> animationController;
  final Function onTapNext;
  VideoEndWidget(this.animationController, this.onTapNext);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [

            SizedBox(
                width: 50,
                height: 50,
                child: AnimatedBuilder(
                  builder: (BuildContext context, Widget child) {
                    return CircularProgressIndicator(
                        strokeWidth: 4,
                        value: animationController.value);
                  },
                  animation: animationController,
                )),
            Container(
              decoration: BoxDecoration(
                  color: colorPrimary.withAlpha(100),
                  borderRadius: BorderRadius.circular(24)),
              child: IconButton(
                  icon: Icon(Icons.skip_next_outlined), onPressed: onTapNext),
            ),
          ],
        ),
        text(context, "Playing next video")
      ],
    );
  }
}
