import 'package:eventklip/di/injection.dart';
import 'package:eventklip/models/user_profile.dart';
import 'package:eventklip/screens/shared_preferences.dart';
import 'package:eventklip/services/authentication_service.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EventklipAppState with ChangeNotifier {
  Locale locale = Locale('en');
  var selectedLanguageCode = 'en';
  var wishListCount = 0;
  UserProfile _userProfile;

  bool isDarkTheme = false;
  AuthenticationService _authService = getIt.get<AuthenticationService>();

  UserProfile get userProfile => _userProfile;

  set setThemeData(bool val) {
    if (val) {
      isDarkTheme = true;
    } else {
      isDarkTheme = false;
    }
    notifyListeners();
  }

  EventklipAppState(lang, {isDarkMode = false}) {
    selectedLanguageCode = lang;
    isDarkTheme = isDarkMode;
  }

  void setUserProfile(UserProfile profile, {bool notify = false}) {
    _userProfile = profile;
    if (notify) notifyListeners();
  }

  Locale get getLocale => locale;

  get getSelectedLanguageCode => selectedLanguageCode;

  get getWishListCount => wishListCount;


  setLocale(locale) => this.locale = locale;

  setSelectedLanguageCode(code) => this.selectedLanguageCode = code;

  changeLocale(Locale l) {
    locale = l;
    notifyListeners();
  }

  changeMode(isDarkMode) {
    isDarkTheme = isDarkMode;
    notifyListeners();
  }

  changeLanguageCode(code) {
    selectedLanguageCode = code;
    notifyListeners();
  }

  changeWishListCount(count) {
    wishListCount = count;
    notifyListeners();
  }

  Future<UserProfile> getUserProfile(String email, String password) async {
    final authToken = await _authService.authenticate(email, password);
    print(authToken.toJson());
    print("AuthToken");
    await SharedPreferenceHelper.saveToken(authToken.accessToken);
    final profile = await _authService.getUserProfile();
    if (profile.isPasswordUpdated) {
      await SharedPreferenceHelper.setUserProfile(profile);
      await SharedPreferenceHelper.setIsLoggedIn();
      await SharedPreferenceHelper.setUserType(UserType.ADMIN);
      final storage = FlutterSecureStorage();
      await storage.write(key: USER_EMAIL, value: email);
      await storage.write(key: PASSWORD, value: password);
    }
    return profile;
  }
}
