import 'dart:io';

import 'package:eventklip/models/v2/event_model.dart';
import 'package:eventklip/screens/v2/create_event/widgets/profile_cover.dart';
import 'package:eventklip/screens/v2/create_event_success/create_event_success_screen.dart';
import 'package:eventklip/ui/widgets/v2/eventklip_app_bar.dart';
import 'package:eventklip/ui/widgets/v2/primary_button.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';

class CreateEventReviewScreen extends StatefulWidget {
  final EventModel model;

  const CreateEventReviewScreen({Key key, @required this.model})
      : super(key: key);

  @override
  _CreateEventReviewScreenState createState() =>
      _CreateEventReviewScreenState();
}

class _CreateEventReviewScreenState extends State<CreateEventReviewScreen> {
  ThemeData theme;
  EventModel _model;
  List<TableRow> _tableRows;

  @override
  void initState() {
    super.initState();
    _model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    prepareTableRows(theme);
    return Scaffold(
      appBar: EventklipAppBar(label: 'Review'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileCover(
              profileImage:
                  _model.imagePath != null ? File(_model.imagePath) : null,
              profileCover:
                  _model.coverPath != null ? File(_model.coverPath) : null,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing_large,
                vertical: spacing_middle,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Event Details', style: theme.textTheme.headline2)
                      .paddingBottom(spacing_large),
                  Table(children: _tableRows)
                      .paddingBottom(spacing_standard_new),
                  Divider(thickness: 1).paddingBottom(spacing_large),
                  Text('If the details are correct, go ahead and publish',
                          style: theme.textTheme.bodyText1)
                      .paddingBottom(spacing_large),
                  PrimaryButton(
                    text: 'Publish',
                    onPressed: handlePublish,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void handlePublish() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CreateEventSuccessScreen();
        },
      ),
    );
  }

  void prepareTableRows(ThemeData theme) {
    TextStyle headline2 = theme.textTheme.headline2;
    TextStyle lightText = headline2.copyWith(fontWeight: FontWeight.w300);
    _tableRows = [
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Event Name', style: lightText),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(_model.eventName, style: headline2),
        )
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Event Type', style: lightText),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(_model.eventType, style: headline2),
        )
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Date', style: lightText),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(_model.date, style: headline2),
        )
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Location', style: lightText),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(_model.location, style: headline2),
        )
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Contact', style: lightText),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(_model.contact, style: headline2),
        )
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Description', style: lightText),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(_model.description, style: headline2),
        )
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Attendees', style: lightText),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(_model.noOfAttendees, style: headline2),
        )
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Multimedia Limits', style: lightText),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(_model.multimediaLimits, style: headline2),
        )
      ]),
    ];
  }
}
