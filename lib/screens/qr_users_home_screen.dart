import 'package:eventklip/fragments/more_fragment_qr_users.dart';
import 'package:eventklip/fragments/question_answer_fragment.dart';
import 'package:eventklip/fragments/video_images_list_fragment/video_images_list_fragment.dart';
import 'package:eventklip/view_models/home_app_state.dart';
import 'package:eventklip/view_models/qr_user_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventklip/fragments/more_fragment.dart';
import 'package:eventklip/fragments/my_files_fragment.dart';
import 'package:eventklip/utils/bottom_navigation.dart';
import 'package:eventklip/utils/resources/images.dart';
import 'package:provider/provider.dart';

class QrUsersHomeScreen extends StatefulWidget {
  static String tag = '/QrUsersHomeScreen';

  @override
  QrUsersHomeScreenState createState() => QrUsersHomeScreenState();
}

class QrUsersHomeScreenState extends State<QrUsersHomeScreen> {
  var _selectedIndex = 0;
  var myFilesFragment = MyFilesFragment();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QrUserState>(
      create: (_) => QrUserState(),
      builder: (context, widget) => WillPopScope(
        onWillPop: () async {
          if (_selectedIndex == 0) return true;
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        },
        child: Scaffold(
          body: Center(
            child: _selectedIndex == 0
                ? GalleryFragment()
                : _selectedIndex == 1
                    ? QuestionAnswerFragment()
                    : MoreFragmentQrUsers(),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).splashColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    offset: Offset.fromDirection(3, 1),
                    spreadRadius: 3,
                    blurRadius: 5),
              ],
            ),
            child: AppBottomNavigationBar(
              backgroundColor: Theme.of(context).splashColor,
              items: const <AppBottomNavigationBarItem>[
                AppBottomNavigationBarItem(icon: ic_video),
                AppBottomNavigationBarItem(icon: ic_faq),
                AppBottomNavigationBarItem(icon: ic_user),
              ],
              currentIndex: _selectedIndex,
              unselectedIconTheme: IconThemeData(
                  color: Theme.of(context).textTheme.headline6.color, size: 22),
              selectedIconTheme: IconThemeData(
                  color: Theme.of(context).primaryColor, size: 22),
              onTap: (index) async {
                setState(() {
                  _selectedIndex = index;
                });
              },
              type: AppBottomNavigationBarType.fixed,
            ),
          ),
        ),
      ),
    );
  }
}
