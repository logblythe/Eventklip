import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final String label;
  final IconData iconData;
  final Function onPressed;

  const IconTextButton({Key key, this.label, this.iconData, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          Icon(iconData, size: 16, color: Colors.grey),
          SizedBox(width: 10),
          Text(label, style: Theme.of(context).textTheme.bodyText2)
        ],
      ),
      onTap: onPressed,
    );
  }
}
