import 'package:eventklip/ui/widgets/user_avatar_widget.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/resources/colors.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:eventklip/view_models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class AddQuestionSection extends StatefulWidget {
  final initialValue;
  final initialDuration;

  final Function(String, int) onQuestionAddClicked;

  AddQuestionSection(
      {this.initialValue = "",
      @required this.onQuestionAddClicked,
      this.initialDuration});

  @override
  _AddQuestionSectionState createState() => _AddQuestionSectionState();
}

class _AddQuestionSectionState extends State<AddQuestionSection> {
  bool checked = false;

  String question = "";
  String duration = "";

  @override
  void initState() {
    super.initState();
    question = widget.initialValue;
    duration = widget.initialDuration;
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        UserAvatarWithInitials(
                          Provider.of<EventklipAppState>(context)
                              .userProfile
                              .fullname,
                          size: 35,
                        ).paddingSymmetric(
                            horizontal: spacing_standard, vertical: 4),
                        Expanded(
                            child: Column(
                          children: [
                            TextFormField(
                              maxLines: 3,
                              cursorColor: Theme.of(context).primaryColor,
                              minLines: 1,
                              initialValue: widget.initialValue,
                              onChanged: (value) {
                                question = value;
                              },
                              style: TextStyle(
                                  fontSize: ts_normal,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color,
                                  fontFamily: font_regular),
                              decoration: InputDecoration(
                                  hintText: "Add question here....",
                                  hintStyle: TextStyle(
                                      fontSize: ts_normal,
                                      color: textColorPrimary.withOpacity(0.3),
                                      fontFamily: font_regular),
                                  border: InputBorder.none),
                              autofocus: true,
                            ),
                            Divider(
                              height: 1,
                              color: Colors.white,
                            ),
                            TextFormField(
                              maxLines: 1,
                              cursorColor: Theme.of(context).primaryColor,
                              initialValue: widget.initialDuration,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {
                                duration = value;
                              },
                              style: TextStyle(
                                  fontSize: ts_normal,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color,
                                  fontFamily: font_regular),
                              decoration: InputDecoration(
                                  hintText: "Duration for video (in secs)",
                                  hintStyle: TextStyle(
                                      fontSize: ts_normal,
                                      color: textColorPrimary.withOpacity(0.3),
                                      fontFamily: font_regular),
                                  border: InputBorder.none),
                              autofocus: true,
                            )
                          ],
                        )),
                        IconButton(
                            icon: Icon(
                              Icons.add,
                              color: colorPrimary,
                            ),
                            onPressed: () {
                              if (question.isEmpty || duration.isEmpty) {
                                toast("The above fields cannot be empty");
                              } else {
                                widget.onQuestionAddClicked(
                                    question, int.parse(duration));
                                Navigator.of(context).pop();
                              }
                            })
                      ],
                    ),
                  ],
                ))));
  }
}
