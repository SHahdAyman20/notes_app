// shared preferences => its a local database, store data in key&value 'look like map'
// shared preferences singleton useful for me cuz it make my code more clean
// and every time i want make some thing by it, i won't be forced to create a new object
// and load more and more on memory, i just will call this database object for once

import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

// i was writing the key name by my hand, and its not true thing cuz
// maybe more than one work on the same project and maybe one of them write the key
// in wrong way / maybe i forget letter of anything, and tis will make conflict on code
// and won't work => so i should make enum class and i will send this class
//instead of String key

enum PrefKeys{
 loggedIn,
  userData,
}


class PreferenceUtils {

  static Future<SharedPreferences> get _instance async {
    return _prefsInstance ??= await SharedPreferences.getInstance();
  }
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static String getString(PrefKeys key, [String defValue='']) {
    return _prefsInstance!.getString(key.name) ?? defValue;
  }

  static Future<bool> setString(PrefKeys key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key.name, value);
  }


  static bool getBool(PrefKeys key, [bool defValue= false]) {
    return _prefsInstance!.getBool(key.name) ?? defValue;
  }

  static Future<bool> setBool(PrefKeys key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key.name, value);
  }
}