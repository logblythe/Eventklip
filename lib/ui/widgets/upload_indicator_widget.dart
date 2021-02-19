import 'package:flutter/material.dart';

class UploadIndicatorWidget extends StatelessWidget {
  final Widget child;
  final double progress;
  final double height;
  final double width;
  final bool uploaded;
  final uploadedIcon = const Icon(Icons.check_circle, size: 32);

  const UploadIndicatorWidget(
      {Key key,
      this.progress,
      this.height = 400,
      this.width = 400,
      this.child,
      this.uploaded = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
          child: child,
          width: _size.width,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: uploaded
                ? uploadedIcon
                : progress > 0
                    ? progress == 1
                        ? uploadedIcon
                        : CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 2,
                            backgroundColor: Colors.white.withOpacity(0.5),
                          )
                    : SizedBox.shrink(),
          ),
        )
      ],
    );
  }
}
