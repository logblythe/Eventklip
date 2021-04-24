import 'package:eventklip/ui/widgets/v2/icon_text_button.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

class CreateEventSuccessScreen extends StatefulWidget {
  @override
  _CreateEventSuccessScreenState createState() =>
      _CreateEventSuccessScreenState();
}

class _CreateEventSuccessScreenState extends State<CreateEventSuccessScreen> {
  String accessCode = 'Sam2021E';

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'Success',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              int count = 0;
              Navigator.popUntil(
                context,
                (route) {
                  return count++ == 3;
                },
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          buildCongratulationsCard(context, theme),
          SizedBox(height: spacing_standard_new),
          buildEvent(theme),
        ],
      ),
    );
  }

  Container buildEvent(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      decoration: BoxDecoration(
        color: const Color(0xFF6C62FC).withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Event Access Code', style: theme.textTheme.bodyText1)
                  .paddingRight(spacing_standard),
              Text(accessCode, style: theme.textTheme.headline2),
              Spacer(),
              Row(
                children: [
                  Icon(Icons.copy_sharp, size: 14, color: Colors.grey)
                      .paddingRight(spacing_control),
                  Text('Copy', style: theme.textTheme.bodyText2)
                ],
              )
            ],
          ).paddingBottom(36),
          Text(
            'Event QR Code',
            style: theme.textTheme.headline2,
          ).paddingBottom(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset(
                "assets/images/frame.png",
                height: 64,
                width: 64,
              ),
              Spacer(),
              IconTextButton(
                label: 'Download',
                iconData: Icons.file_download,
                onPressed: handleDownload,
              ),
              Spacer(),
              IconTextButton(
                label: 'Share',
                iconData: Icons.share_sharp,
                onPressed: handleShare,
              ),
            ],
          ).paddingBottom(spacing_large),
          Text(
            'This QR Code takes to a landing page which includes EventKlip Download button and your Event’s Access Code. Do not forget to download it.',
            style: theme.textTheme.bodyText2,
          )
        ],
      ),
    );
  }

  Container buildCongratulationsCard(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xFF6C62FC).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 36,
            color: Theme.of(context).primaryColor,
          ).paddingRight(12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Congratulations!',
                  style: theme.textTheme.headline2,
                ),
                SizedBox(height: spacing_standard),
                Text(
                  'Your event has been successfully published.',
                  style: theme.textTheme.caption,
                )
              ],
            ),
          ),
          SvgPicture.asset(
            'assets/icons/ic_event_creation_success.svg',
            height: 88,
            width: 98,
            fit: BoxFit.contain,
          )
        ],
      ),
    );
  }

  void handleDownload() {}

  void handleShare() {}
}
