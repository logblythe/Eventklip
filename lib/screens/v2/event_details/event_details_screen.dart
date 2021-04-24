import 'package:eventklip/ui/widgets/v2/anim_search_widget.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter/material.dart';
import "package:nb_utils/nb_utils.dart";

class EventDetailsScreen extends StatefulWidget {
  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  TextEditingController searchTextController;
  List<Tab> tabs;
  bool shouldExpand = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    searchTextController = TextEditingController();
  }

  void handleSuffixTap() {
    searchTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    buildTabs(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
          iconSize: 16,
        ),
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Sam's & Sammy's Wedding",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: <Widget>[
          AnimSearchBar(
              rtl: true,
              helpText: "Search via caption",
              width: 336,
              textController: searchTextController,
              onSuffixTap: handleSuffixTap),
          PopupMenuButton<String>(
            itemBuilder: (context) {
              return {'Sort by', 'Select all'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: InkWell(
                      onTap: () => _settingModalBottomSheet(context),
                      child: Text(choice)),
                );
              }).toList();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              isScrollable: true,
              indicatorColor: Theme.of(context).primaryColor,
              controller: tabController,
              tabs: tabs,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Icon(Icons.directions_car),
          Icon(Icons.directions_transit),
          Icon(Icons.directions_bike),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: handleFab,
        label: Text('Camera'),
        icon: Icon(Icons.camera_alt),
      ),
    );
  }

  void buildTabs(BuildContext context) {
    TextStyle bodyText1 = Theme.of(context).textTheme.bodyText1;
    tabs = [
      Tab(child: Text('All', style: bodyText1)),
      Tab(child: Text('Photos', style: bodyText1)),
      Tab(child: Text('Videos', style: bodyText1)),
    ];
  }

  void handleClick(String value) {}

  void _settingModalBottomSheet(context) {
    int indexA = 1;
    int indexB = 2;
    Navigator.of(context).pop();
    TextTheme theme = Theme.of(context).textTheme;
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (BuildContext bc) {
          return Container(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Sort by',
                  style: theme.caption,
                ).paddingBottom(spacing_large),
                Text('Date', style: theme.bodyText1)
                    .paddingBottom(spacing_large),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Newest date first',
                      style: TextStyle(
                        fontSize: 16,
                        color: indexA == 1
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ).paddingBottom(spacing_large),
                    Icon(Icons.check, color: Theme.of(context).primaryColor),
                  ],
                ),
                Text(
                  'Oldest date first',
                  style: TextStyle(
                    fontSize: 16,
                    color: indexA == 2
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                ).paddingBottom(spacing_large),
                Divider(height: 1, thickness: 1).paddingBottom(spacing_large),
                Text(
                  'Time',
                  style: theme.bodyText1,
                ).paddingBottom(spacing_large),
                Text(
                  'Newest date first',
                  style: TextStyle(
                    fontSize: 16,
                    color: indexB == 1
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                ).paddingBottom(spacing_large),
                Text(
                  'Oldest date first',
                  style: TextStyle(
                    fontSize: 16,
                    color: indexB == 2
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                ).paddingBottom(spacing_large),
              ],
            ),
          );
        });
  }

  void handleFab() {}
}
