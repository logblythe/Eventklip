/*
const ios_appid="ca-app-pub-3940256099942544~1458002511";
const ios_banner_id="ca-app-pub-3940256099942544/2934735716";
const ios_interstitial_id="ca-app-pub-3940256099942544/4411468910";
const android_appid="ca-app-pub-3940256099942544~3347511713";
const android_banner_id="ca-app-pub-3940256099942544/6300978111";
const android_interstitial_id="ca-app-pub-3940256099942544/1033173712";
const error_network_no_internet = "No Internet connection";
*/
import 'package:eventklip/utils/app_localizations.dart';

const app_name = "eventklip";
const walk_titles = [
  "Welcome to " + app_name,
  "Welcome to " + app_name,
  "Welcome to " + app_name
];
const walk_sub_titles = [
  "Look back and reflect on your memories and growth over time",
  "Watch videos from your organizer and have fun and learn",
  "Find amazing topics to get engaged. Upload your own videos and teach people"
];

List<String> getGenders(context) {
  return [
    keyString(context, "male"),
    keyString(context, "female"),
  ];
}
