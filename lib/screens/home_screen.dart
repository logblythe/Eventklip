import 'package:eventklip/fragments/folder_fragment/folder_fragment.dart';
import 'package:eventklip/view_models/home_app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventklip/fragments/home_fragment.dart';
import 'package:eventklip/fragments/more_fragment.dart';
import 'package:eventklip/fragments/my_files_fragment.dart';
import 'package:eventklip/fragments/search_fragment.dart';
import 'package:eventklip/utils/bottom_navigation.dart';
import 'package:eventklip/utils/resources/images.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static String tag = '/HomeScreen';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  var _selectedIndex = 0;
  var homeFragment = HomeFragment();
  var searchFragment = SearchFragment();
  var myFilesFragment = MyFilesFragment();
  var moreFragment = MoreFragment();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeAppState>(
      create: (_) => HomeAppState(),
      builder: (context, widget) => WillPopScope(
          onWillPop: () async {
            if (_selectedIndex == 0) return true;
            setState(() {
              _selectedIndex = 0;
            });
            return false;
          },
          child: Scaffold(
              body: IndexedStack(
                children: [
                  HomeFragment(),
                  SearchFragment(),
                  // MyFilesFragment(),
                  MoreFragment(),
                  FolderFragment()
                ],
                index: _selectedIndex,
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).splashColor,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          offset: Offset.fromDirection(3, 1),
                          spreadRadius: 3,
                          blurRadius: 5)
                    ]),
                child: AppBottomNavigationBar(
                  backgroundColor: Theme.of(context).splashColor,
                  items: const <AppBottomNavigationBarItem>[
                    AppBottomNavigationBarItem(icon: ic_home),
                    AppBottomNavigationBarItem(icon: ic_search),
                    // AppBottomNavigationBarItem(
                    //   icon: ic_folder,
                    // ),
                    AppBottomNavigationBarItem(icon: ic_user),
                    AppBottomNavigationBarItem(icon: ic_folder),
                  ],
                  currentIndex: _selectedIndex,
                  unselectedIconTheme: IconThemeData(
                      color: Theme.of(context).textTheme.headline6.color,
                      size: 22),
                  selectedIconTheme: IconThemeData(
                      color: Theme.of(context).primaryColor, size: 22),
                  onTap: (index) async {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  type: AppBottomNavigationBarType.fixed,
                ),
              ))),
    );
  }
}
