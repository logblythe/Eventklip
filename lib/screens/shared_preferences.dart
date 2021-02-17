import 'dart:convert';

import 'package:eventklip/models/user_profile.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static Future saveToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(TOKEN, token);
  }

  static Future setIsLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(IS_LOGGED_IN, true);
  }

  static Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(TOKEN);
  }

  static Future<bool> getIsLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(IS_LOGGED_IN) ?? false;
  }

  static Future<bool> setUserProfile(UserProfile userProfile) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(USER_PROFILE, json.encode(userProfile));
  }

  static Future<UserProfile> getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return UserProfile.fromJson(
        json.decode(preferences.getString(USER_PROFILE)));
  }

  static Future<void> clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  static Future<void> setUserType(UserType userType) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(USER_ROLE, userType.toString());
  }

  static Future<UserType> getUserType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(USER_ROLE) as UserType;
  }
}
