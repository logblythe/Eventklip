import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final double height;
  final double width;

  const PrimaryButton({this.text, this.onPressed,this.height,this.width});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(spacing_standard),
      ),
      height: height ?? 46,
      minWidth: width ?? double.infinity,
      color: Theme.of(context).primaryColor,
      splashColor: Colors.grey.withOpacity(0.2),
      disabledColor: Theme.of(context).primaryColor,
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
      ),
      onPressed: onPressed,
    );
  }
}
