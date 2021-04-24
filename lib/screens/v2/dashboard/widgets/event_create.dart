import 'package:eventklip/ui/widgets/v2/primary_button.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventCreateCard extends StatelessWidget {
  final Function onPressed;
  final String title;
  final String subtitle;
  final Icon leadingIcon;
  final String buttonText;
  final String assetPath;

  const EventCreateCard(
      {Key key,
      this.onPressed,
      this.title,
      this.subtitle,
      this.leadingIcon,
      this.buttonText,
      this.assetPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 16),
      decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: primaryColor),
            child: leadingIcon,
          ),
          SizedBox(width: spacing_standard),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: spacing_control),
                Text(subtitle),
                SizedBox(height: spacing_control),
                PrimaryButton(
                  text: buttonText,
                  onPressed: onPressed,
                  height: 28,
                  width: 116,
                )
              ],
            ),
          ),
          SvgPicture.asset(assetPath)
        ],
      ),
    );
  }
}
