import 'dart:io';

import 'package:eventklip/models/v2/event_model.dart';
import 'package:eventklip/screens/v2/create_event/widgets/profile_cover.dart';
import 'package:eventklip/screens/v2/create_event_review/create_event_review_screen.dart';
import 'package:eventklip/ui/widgets/v2/drop_down.dart';
import 'package:eventklip/ui/widgets/v2/eventklip_app_bar.dart';
import 'package:eventklip/ui/widgets/v2/primary_button.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

enum ImageOrCover { IMAGE, COVER }

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final contactController = TextEditingController();
  final descriptionController = TextEditingController();
  final scanController = TextEditingController();
  final durationController = TextEditingController();
  final imageCountController = TextEditingController();
  final videoCountController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  final titleFocus = FocusNode();
  final locationFocus = FocusNode();
  final contactFocus = FocusNode();
  final descriptionFocus = FocusNode();
  final scanFocus = FocusNode();
  final durationFocus = FocusNode();
  final imageCountFocus = FocusNode();
  final videoCountFocus = FocusNode();
  final startDateFocus = FocusNode();
  final endDateFocus = FocusNode();

  String _name = '';
  String _description = '';
  String _noOfScans = '';
  String _duration = '';
  String _videoCount = '';
  String _imageCount = '';
  String _expiryDate = '';
  String _createdDate = '';
  String _location = '';
  String _contact = '';
  String _type = '';

  File profileCover;
  File profileImage;

  DateTime currentTime = DateTime.now();
  List<String> eventTypes = [
    "Engagement",
    "Sports",
    "Conference",
    "Others",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EventklipAppBar(label: 'Create Event'),
      body: Container(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProfileCover(
                  profileCover: this.profileCover,
                  profileImage: this.profileImage,
                  onCoverTap: () => handlePickImageOrCover(ImageOrCover.COVER),
                  onImageTap: () => handlePickImageOrCover(ImageOrCover.IMAGE),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing_large,
                    vertical: spacing_middle,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      formField(
                        context,
                        "hint_name",
                        maxLine: 1,
                        isRequired: true,
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        validator: (value) => value.isEmpty ? "Required" : null,
                        onSaved: (value) => _name = value,
                        textInputAction: TextInputAction.next,
                        focusNode: titleFocus,
                        nextFocus: startDateFocus,
                      ).paddingBottom(spacing_standard_new),
                      Dropdown(
                                                options: eventTypes,
                        onSelect: handleEventTypeSelection,
                        label: "Event Type",
                        isRequired: true,
                      ).paddingBottom(spacing_standard_new),
                      formField(
                        context,
                        "hint_event_from",
                        readOnly: true,
                        showCursor: false,
                        isRequired: true,
                        onTap: () => handleStartDateSelection(context),
                        maxLine: 1,
                        controller: startDateController,
                        keyboardType: TextInputType.number,
                        validator: (value) => value.isEmpty ? "Required" : null,
                        textInputAction: TextInputAction.next,
                        focusNode: startDateFocus,
                        nextFocus: endDateFocus,
                      ).paddingBottom(spacing_standard_new),
                      formField(
                        context,
                        "hint_event_to",
                        readOnly: true,
                        showCursor: false,
                        isRequired: true,
                        onTap: () => handleEndDateSelection(context),
                        maxLine: 1,
                        controller: endDateController,
                        keyboardType: TextInputType.number,
                        validator: (value) => value.isEmpty ? "Required" : null,
                        textInputAction: TextInputAction.next,
                        focusNode: endDateFocus,
                        nextFocus: locationFocus,
                      ).paddingBottom(spacing_standard_new),
                      formField(
                        context,
                        "hint_event_location",
                        maxLine: 1,
                        controller: locationController,
                        keyboardType: TextInputType.text,
                        onSaved: (value) => _location = value,
                        textInputAction: TextInputAction.next,
                        focusNode: locationFocus,
                        nextFocus: contactFocus,
                      ).paddingBottom(spacing_standard_new),
                      formField(
                        context,
                        "hint_contact",
                        maxLine: 1,
                        maxLength: 10,
                        controller: contactController,
                        keyboardType: TextInputType.phone,
                        onSaved: (value) => _contact = value,
                        textInputAction: TextInputAction.next,
                        focusNode: contactFocus,
                        nextFocus: descriptionFocus,
                      ).paddingBottom(spacing_standard_new),
                      formField(
                        context,
                        "hint_description",
                        maxLine: null,
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) => _description = value,
                        textInputAction: TextInputAction.next,
                        focusNode: descriptionFocus,
                        nextFocus: scanFocus,
                      ).paddingBottom(spacing_standard_new),
                      formField(
                        context,
                        "hint_no_of_scans",
                        maxLine: null,
                        controller: scanController,
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _noOfScans = value,
                        textInputAction: TextInputAction.next,
                        focusNode: scanFocus,
                        nextFocus: durationFocus,
                      ).paddingBottom(spacing_standard_new),
                      formField(
                        context,
                        "hint_multimedia_limits",
                        hint: "Cannot be greater than 25",
                        isRequired: true,
                        maxLength: 2,
                        controller: durationController,
                        keyboardType: TextInputType.number,
                        validator: (value) => value.isEmpty
                            ? "Required"
                            : int.parse(value) > 25
                                ? "cannot be greater than 25"
                                : null,
                        onSaved: (value) => _duration = value,
                        textInputAction: TextInputAction.next,
                        focusNode: durationFocus,
                      ).paddingBottom(spacing_standard_new),
                      PrimaryButton(
                        text: 'Next',
                        onPressed: handleCreateFolder,
                      ).paddingBottom(spacing_standard_new),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleStartDateSelection(BuildContext context) {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: currentTime,
      onConfirm: (date) {
        _createdDate =
            DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(date.toUtc());
        startDateController.text =
            DateFormat("MM-dd-yyyy | hh:mm a").format(date.toLocal());
      },
      currentTime: currentTime,
      locale: LocaleType.en,
    );
  }

  void handleEndDateSelection(BuildContext context) {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: currentTime,
      onConfirm: (date) {
        _expiryDate =
            DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(date.toUtc());
        endDateController.text =
            DateFormat("MM-dd-yyyy | hh:mm a").format(date.toLocal());
      },
      currentTime: currentTime,
      locale: LocaleType.en,
    );
  }

  void handleCreateFolder() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      // final payload = {
      //   "id": "",
      //   "name": _name,
      //   "description": _description,
      //   "isActive": true,
      //   "accessCode": "",
      //   "parentFolder": "",
      //   "createdById": "string",
      //   "createdDate": _createdDate,
      //   "noOfScans": int.parse(_noOfScans),
      //   "expiryDate": _expiryDate,
      //   "duration": int.parse(_duration),
      //   "noOfVideoLimit": int.parse(_videoCount),
      //   "noOfImgLimit": int.parse(_imageCount)
      // };
      EventModel event = EventModel()
        ..eventName = _name
        ..description = _description
        ..date = _expiryDate
        ..location = _location
        ..contact = _contact
        ..eventType = _type
        ..noOfAttendees = _noOfScans
        ..multimediaLimits = _duration
        ..imagePath = profileImage?.path
        ..coverPath = profileCover?.path;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return CreateEventReviewScreen(model: event);
          },
        ),
      );
    }
  }

  void handlePickImageOrCover(ImageOrCover img) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path);
      setState(() {
        img == ImageOrCover.IMAGE ? profileImage = file : profileCover = file;
      });
    }
  }

  handleEventTypeSelection(int index) {
    _type = eventTypes.elementAt(index);
  }
}
