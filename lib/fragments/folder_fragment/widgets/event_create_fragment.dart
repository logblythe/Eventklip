import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:eventklip/view_models/folder_state.dart';
import 'package:flutter/material.dart';
import 'package:eventklip/utils/resources/colors.dart' as colors;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class EventCreateFragment extends StatefulWidget {
  @override
  _EventCreateFragmentState createState() => _EventCreateFragmentState();
}

class _EventCreateFragmentState extends State<EventCreateFragment> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final scanController = TextEditingController();
  final durationController = TextEditingController();
  final imageCountController = TextEditingController();
  final videoCountController = TextEditingController();
  final dateController = TextEditingController();
  final titleFocus = FocusNode();
  final descriptionFocus = FocusNode();
  final scanFocus = FocusNode();
  final durationFocus = FocusNode();
  final imageCountFocus = FocusNode();
  final videoCountFocus = FocusNode();
  final dateFocus = FocusNode();
  String _name = '';
  String _description = '';
  String _noOfScans = '';
  String _duration = '';
  String _videoCount = '';
  String _imageCount = '';
  String _expiryDate = '';
  String _createdDate = '';
  FolderState provider;

  @override
  Widget build(BuildContext context) {
    return Consumer<FolderState>(
      builder: (context, model, child) {
        provider = model;
        return Scaffold(
          appBar: AppBar(),
          body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: spacing_large, vertical: spacing_middle),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(
                      context,
                      "Folder information",
                      fontFamily: font_bold,
                      fontSize: ts_large,
                      textColor: colors.textColorPrimary,
                      isCentered: false,
                    ).paddingBottom(spacing_standard_new),
                    formField(
                      context,
                      "hint_name",
                      maxLine: 1,
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      validator: (value) => value.isEmpty ? "Required" : null,
                      onSaved: (value) => _name = value,
                      textInputAction: TextInputAction.next,
                      focusNode: titleFocus,
                      nextFocus: descriptionFocus,
                    ).paddingBottom(spacing_standard_new),
                    formField(
                      context,
                      "hint_description",
                      maxLine: null,
                      controller: descriptionController,
                      keyboardType: TextInputType.multiline,
                      validator: (value) => value.isEmpty ? "Required" : null,
                      onSaved: (value) => _description = value,
                      textInputAction: TextInputAction.next,
                      focusNode: descriptionFocus,
                      nextFocus: dateFocus,
                    ).paddingBottom(spacing_standard_new),
                    formField(
                      context,
                      "hint_event_expiry",
                      readOnly: true,
                      showCursor: false,
                      onTap: () => handleDateSelection(context),
                      maxLine: 1,
                      controller: dateController,
                      keyboardType: TextInputType.number,
                      validator: (value) => value.isEmpty ? "Required" : null,
                      textInputAction: TextInputAction.next,
                      focusNode: dateFocus,
                      nextFocus: scanFocus,
                    ).paddingBottom(spacing_standard_new),
                    formField(
                      context,
                      "hint_no_of_scans",
                      maxLine: null,
                      controller: scanController,
                      keyboardType: TextInputType.number,
                      validator: (value) => value.isEmpty ? "Required" : null,
                      onSaved: (value) => _description = value,
                      textInputAction: TextInputAction.next,
                      focusNode: scanFocus,
                      nextFocus: durationFocus,
                    ).paddingBottom(spacing_standard_new),
                    formField(
                      context,
                      "hint_video_duration",
                      maxLine: null,
                      controller: durationController,
                      keyboardType: TextInputType.number,
                      validator: (value) => value.isEmpty ? "Required" : null,
                      onSaved: (value) => _description = value,
                      textInputAction: TextInputAction.next,
                      focusNode: durationFocus,
                      nextFocus: videoCountFocus,
                    ).paddingBottom(spacing_standard_new),
                    formField(
                      context,
                      "hint_video_limit",
                      maxLine: null,
                      controller: videoCountController,
                      keyboardType: TextInputType.number,
                      validator: (value) => value.isEmpty ? "Required" : null,
                      onSaved: (value) => _description = value,
                      textInputAction: TextInputAction.next,
                      focusNode: videoCountFocus,
                      nextFocus: imageCountFocus,
                    ).paddingBottom(spacing_standard_new),
                    formField(
                      context,
                      "hint_image_limit",
                      maxLine: null,
                      controller: imageCountController,
                      keyboardType: TextInputType.number,
                      validator: (value) => value.isEmpty ? "Required" : null,
                      onSaved: (value) => _description = value,
                      textInputAction: TextInputAction.next,
                      focusNode: imageCountFocus,
                    ).paddingBottom(spacing_standard_new),
                    Align(
                      child: button(context, 'Create', handleCreateFolder),
                      alignment: Alignment.centerRight,
                    ).paddingTop(spacing_standard_new)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void handleDateSelection(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime(2019, 6, 7),
      onChanged: (date) {
        print('change $date');
      },
      onConfirm: (date) {
        _expiryDate =
            DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(date.toUtc());
        dateController.text = DateFormat('MM-dd-yyyy').format(date.toLocal());
      },
      currentTime: DateTime.now(),
    );
  }

  void handleCreateFolder() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      _createdDate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now());
      final payload = {
        "id": "",
        "name": _name,
        "description": _description,
        "isActive": true,
        "accessCode": "",
        "parentFolder": "",
        "createdById": "string",
        "createdDate": _createdDate,
        "noOfScans": int.parse(_noOfScans),
        "expiryDate": _expiryDate,
        "duration": int.parse(_duration),
        "noOfVideoLimit": int.parse(_videoCount),
        "noOfImgLimit": int.parse(_imageCount)
      };
      provider.createFolder(payload).then((res) {
        _name = '';
        _description = '';
        provider.getFolders();
      });
      Navigator.pop(context, true);
    }
  }
}
