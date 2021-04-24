import 'dart:io';

import 'package:eventklip/screens/v2/create_event/widgets/bottom_label.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter/material.dart';

class ProfileCover extends StatelessWidget {
  final File profileCover;
  final File profileImage;
  final Function() onCoverTap;
  final Function() onImageTap;

  const ProfileCover(
      {Key key,
      @required this.profileCover,
      @required this.profileImage,
      this.onCoverTap,
      this.onImageTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(height: 220),
        Stack(
          children: [
            SizedBox(
              height: 158,
              width: double.infinity,
              child: InkResponse(
                  child: profileCover != null
                      ? Image.file(
                          profileCover,
                          fit: BoxFit.fitWidth,
                        )
                      : Container(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5)),
                  onTap: onCoverTap != null ? onCoverTap : null),
            ),
            onCoverTap != null
                ? BottomLabel(label: "Add Cover", onTap: onCoverTap)
                : SizedBox.shrink()
          ],
        ),
        Positioned(
          left: spacing_large,
          top: 100,
          child: Stack(
            children: [
              SizedBox(
                height: 110,
                width: 110,
                child: InkResponse(
                    child: profileImage != null
                        ? Image.file(
                            profileImage,
                            fit: BoxFit.fill,
                          )
                        : Container(color: Colors.grey),
                    onTap: onImageTap != null ? onImageTap : null),
              ),
              onImageTap != null
                  ? BottomLabel(label: "Add Profile", onTap: onImageTap)
                  : SizedBox.shrink()
            ],
          ),
        ),
      ],
    );
  }
}
