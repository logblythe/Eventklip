import 'package:eventklip/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'app_localizations.dart';

void launchScreenWithNewTask(context, String tag) {
  Navigator.pushNamedAndRemoveUntil(context, tag, (r) => false);
}

void launchScreen(context, String tag, {Object arguments}) {
  if (arguments == null) {
    Navigator.pushNamed(context, tag);
  } else {
    Navigator.pushNamed(context, tag, arguments: arguments);
  }
}

extension WidgetExtension on Widget {
  Visibility withVisibility(
    bool visible, {
    Widget replacement,
    bool maintainAnimation = false,
    bool maintainState = false,
    bool maintainSize = false,
    bool maintainSemantics = false,
    bool maintainInteractivity = false,
  }) {
    return Visibility(
      visible: visible,
      maintainAnimation: maintainAnimation,
      maintainInteractivity: maintainInteractivity,
      maintainSemantics: maintainSemantics,
      maintainSize: maintainSize,
      maintainState: maintainState,
      key: key,
      child: this,
      replacement: replacement ?? Container(),
    );
  }

  Widget opacity({@required double opacity, durationInSecond = 3}) {
    return AnimatedOpacity(
        opacity: opacity,
        duration: Duration(seconds: durationInSecond),
        child: this);
  }

  Widget rotate(
      {@required double angle, bool transformHitTests = true, Offset origin}) {
    return Transform.rotate(
        origin: origin,
        angle: angle,
        transformHitTests: transformHitTests,
        child: this);
  }

  launch<T>(context) {
    if (this is StatelessWidget || this is StatefulWidget) {
      Navigator.of(context).push(MaterialPageRoute<T>(builder: (_) => this));
    } else {
      throw Exception(
          'Error: Widget should be StatelessWidget or StatefulWidget');
    }
  }
}

Widget noDataWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset('assets/images/no_data.png', height: 130),
      Text('No data', style: boldTextStyle(color: Colors.white)),
    ],
  );
}

Widget errorWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset('assets/images/no_data.png', height: 130),
      Text('Something went wrong', style: boldTextStyle(color: Colors.white)),
    ],
  );
}

extension StringExtentions on String {
  String validateEMail(context) {
    if (this.isEmpty) {
      return keyString(context, "error_email_required");
    }
    return RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(this)
        ? null
        : keyString(context, "error_invalid_email");
  }
}

extension CommentListExtension on List<Comment> {
  sortByTimeAscending() {
    this?.sort((a, b) =>
        b.commentedOn.millisecondsSinceEpoch -
        a.commentedOn.millisecondsSinceEpoch);
  }
}
