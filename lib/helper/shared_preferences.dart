import 'package:shared_preferences/shared_preferences.dart';

class SharPreferences {
  static const isLogin = "isLogin";
  static const user = "userData";

  static const userId = "userId";
  static const email = "email";
  static const moduleName = "moduleName";
  static const isQuizComplete = "isQuizComplete";
  static const isFromRetakeQuiz = "isFromRetakeQuiz";
  static const accessToken = "accessToken";
  static const firebaseUid = "firebaseUid";

  static const swipeUpGuide = "swipeUpGuide";

  static const isUniversitySelected = "isUniversitySelected";
  static const isPersonalProfileCompleted = "isPersonalProfileCompleted";

  static const deviceToken = "deviceToken";
  static const appleIdFirstName = "appleIdFirstName";
  static const appleIdLastName = "appleIdLastName";

  static const notificationUnreadCount = "notificationUnreadCount";
  static const currentChatReceiverID = "currentChatReceiverID";
  static const isOnMessageScreen = "isOnMessageScreen";

  //maintenance
  static const isDormMatesAvailable = "isDormMatesAvailable";
  static const isRoomMatesAvailable = "isRoomMatesAvailable";
  static const isTeamMatesAvailable = "isTeamMatesAvailable";
  static const isSoulMatesAvailable = "isSoulMatesAvailable";
  static const isMaintenanceMode = "isMaintenanceMode";

  static Future<bool?> getBoolean(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> setBoolean(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<void> clearSharPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    SharPreferences.setBoolean(SharPreferences.swipeUpGuide, true);
  }
}