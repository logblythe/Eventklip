import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter/material.dart';
import 'package:eventklip/utils/resources/colors.dart' as colors;

class NoFolderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const NoFolderWidget({Key key, this.title, this.subtitle, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(spacing_standard_new),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon ?? Icons.delete_outline_rounded),
            SizedBox(height: spacing_standard),
            text(context, title ?? 'No folders found',
                fontSize: ts_extra_normal,
                fontFamily: font_bold,
                textColor: colors.textColorPrimary),
            Flexible(
              child: text(
                context,
                subtitle ??
                    "You can create a folder by clicking on the '+' button",
                fontSize: ts_medium,
                maxLine: 4,
                isCentered: true,
                textColor: colors.textColorPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
