import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventklip/Globals.dart';
import 'package:eventklip/screens/v2/create_event/create_event_screen.dart';
import 'package:eventklip/screens/v2/dashboard/widgets/event_create.dart';
import 'package:eventklip/screens/v2/event_details/event_details_screen.dart';
import 'package:eventklip/ui/widgets/v2/eventklip_bottom_navigation_bar.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime _dateTime = DateTime.now();
  String greetingText = "-";
  String dateText = "-";

  void initialiseGreeting() {
    int hour = _dateTime.hour;
    if (hour < 12) {
      greetingText = "Good Morning!";
    } else if (hour < 17) {
      greetingText = "Good Afternoon!";
    } else if (hour < 20) {
      greetingText = "Good Evening!";
    } else {
      greetingText = "Good Night!";
    }
  }

  void initialiseDateText() {
    String month = months[_dateTime.month-1];
    int date = _dateTime.day;
    String day = days[_dateTime.weekday];
    dateText = "$date $month | $day";
  }

  @override
  void initState() {
    super.initState();
    initialiseGreeting();
    initialiseDateText();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildHeader(primaryColor),
              SizedBox(height: spacing_extra_large),
              buildEvents(primaryColor),
              buildParticipations(primaryColor),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BoxklipBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        child: SvgPicture.asset("assets/icons/ic_scan.svg"),
        onPressed: handleFAB,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildHeader(Color primaryColor) {
    return Material(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Eventklip'),
                Text(
                  greetingText,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: spacing_large),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 32, 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    color: primaryColor.withOpacity(0.1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        child: Icon(
                          Icons.event,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(width: spacing_standard_new),
                      Text(dateText,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        color: primaryColor.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: Colors.grey,
                        size: 32,
                      ),
                    ),
                    SizedBox(width: spacing_standard_new),
                    CircleAvatar(
                      radius: 24,
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://www.clipartmax.com/png/middle/282-2822002_go-present-code-highlighter-golang-avatar.png",
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: spacing_middle),
            Text('No events coming soon.')
          ],
        ),
      ),
    );
  }

  Widget buildEvents(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Events',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(height: spacing_standard_new),
          EventCreateCard(
            assetPath: "assets/icons/ic_create_event.svg",
            subtitle: 'Enter the details and create a wonderful event.',
            title: 'Create an Event',
            leadingIcon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            buttonText: 'Create',
            onPressed: handleEventCreation,
          ),
        ],
      ),
    );
  }

  Widget buildParticipations(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Participations',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(height: spacing_standard_new),
          EventCreateCard(
            assetPath: "assets/icons/ic_enter_event.svg",
            subtitle: 'Enter with just a QR Scan or an access code.',
            title: 'Enter an Event',
            leadingIcon: Icon(
              Icons.event_available,
              color: Colors.white,
            ),
            buttonText: 'Enter',
            onPressed: handleEventParticipation,
          ),
        ],
      ),
    );
  }

  void handleFAB() {}

  handleEventCreation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CreateEventScreen();
        },
      ),
    );
  }

  handleEventParticipation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return EventDetailsScreen();
        },
      ),
    );
  }
}
