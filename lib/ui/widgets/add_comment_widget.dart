import 'package:eventklip/ui/widgets/user_avatar_widget.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/resources/colors.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:eventklip/view_models/app_state.dart';
import 'package:eventklip/view_models/video_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class AddCommentWidget extends StatefulWidget {
  final initialValue;

  final Function(String, String) onCommentAddClicked;

  AddCommentWidget(
      {this.initialValue = "", @required this.onCommentAddClicked});

  @override
  _AddCommentWidgetState createState() => _AddCommentWidgetState();
}

class _AddCommentWidgetState extends State<AddCommentWidget> {
  bool checked = false;

  String timespan;
  var comment;

  @override
  void initState() {
    super.initState();
    comment = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            color: Theme.of(context).cardColor,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
                padding: EdgeInsets.zero,
                child: Form(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          UserAvatarWithInitials(
                            Provider.of<EventklipAppState>(context)
                                .userProfile
                                .fullname,
                            size: 35,
                          ).paddingSymmetric(horizontal: spacing_standard,vertical: 4),
                          Expanded(
                            child: TextFormField(
                              maxLines: 3,
                              cursorColor: Theme.of(context).primaryColor,
                              minLines: 1,
                              initialValue: widget.initialValue,
                              onChanged: (value) {
                                comment = value;
                              },
                              style: TextStyle(
                                  fontSize: ts_normal,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color,
                                  fontFamily: font_regular),
                              decoration: InputDecoration(
                                  hintText: "Add a comment ....",
                                  hintStyle: TextStyle(
                                      fontSize: ts_normal,
                                      color: textColorPrimary.withOpacity(0.3),
                                      fontFamily: font_regular),
                                  border: InputBorder.none),
                              autofocus: true,
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.send,
                                color: colorPrimary,
                              ),
                              onPressed: () {
                                widget.onCommentAddClicked(
                                    comment, checked ? timespan : null);
                                Navigator.of(context).pop();
                              })
                        ],
                      ),
                      Divider(
                        height: 1,
                        color: Colors.white,
                      ),
                      Consumer<VideoDetailState>(
                        builder: (context, state, child) {
                          timespan = state.currentPosition;
                          return Theme(
                            data:
                                ThemeData(unselectedWidgetColor: colorPrimary),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  checked = !checked;
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    child: Checkbox(
                                      onChanged: (value) {
                                        setState(() {
                                          checked = !checked;
                                        });
                                      },
                                      value: checked,
                                      checkColor: colorPrimary,
                                      focusColor: colorPrimary,
                                      activeColor: Colors.transparent,
                                    ),
                                    height: 40,
                                    width: 40,
                                  ),
                                  text(
                                    context,
                                    "Add Video Time - ${state.currentPosition}",
                                  )
                                ],
                              ).paddingLeft(spacing_standard),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ))));
  }
}
