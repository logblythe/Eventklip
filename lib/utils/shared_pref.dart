import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> getSharedPref() async {
  return await SharedPreferences.getInstance();
}

setString(String key, String value) async {
  await getSharedPref().then((pref) {
    pref.setString(key, value);
  });
}

setInt(String key, int value) async {
  await getSharedPref().then((pref) {
    pref.setInt(key, value);
  });
}

setBool(String key, bool value) async {
  await getSharedPref().then((pref) {
    pref.setBool(key, value);
  });
}

setDouble(String key, double value) async {
  await getSharedPref().then((pref) {
    pref.setDouble(key, value);
  });
}

Future<String> getString(String key, {defaultValue = ''}) async {
  return await getSharedPref().then((pref) {
    return pref.getString(key) ?? defaultValue;
  });
}

Future<int> getInt(String key, {defaultValue = 0}) async {
  return await getSharedPref().then((pref) {
    return pref.getInt(key) ?? defaultValue;
  });
}

Future<double> getDouble(String key, {defaultValue = 0.0}) async {
  return await getSharedPref().then((pref) {
    return pref.getDouble(key) ?? defaultValue;
  });
}

Future<bool> getBool(String key, {defaultValue = false}) async {
  return await getSharedPref().then((pref) {
    return pref.getBool(key) ?? defaultValue;
  });
}
