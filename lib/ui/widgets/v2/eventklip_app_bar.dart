import 'package:flutter/material.dart';

class EventklipAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String label;
  final PreferredSizeWidget bottom;

  const EventklipAppBar({Key key, @required this.label, this.bottom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded),
        onPressed: () => Navigator.of(context).pop(),
        iconSize: 16,
      ),
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(
        label,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
