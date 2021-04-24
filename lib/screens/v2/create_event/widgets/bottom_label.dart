import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BottomLabel extends StatelessWidget {
  final String label;
  final Function onTap;

  const BottomLabel({Key key, this.label, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: InkWell(
        child: Container(
          width: 110,
          padding: const EdgeInsets.all(spacing_standard),
          color: Colors.black.withOpacity(0.3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.image, color: Colors.white, size: 14),
              Text(
                label,
                style: TextStyle(color: Colors.white, fontSize: 10),
              ).paddingLeft(spacing_standard),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
