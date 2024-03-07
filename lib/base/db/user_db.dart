import 'package:shared_preferences/shared_preferences.dart';

class UserDB {
  final String KeyRemember = "KeyRemember";
  final String KeyToken = "KeyToken";
  final String KeyUsername = "KeyUsername";
  final String KeyPassword = "KeyPassword";
  final String KeyAgentSetting = "KeyAgentSetting";
  final String KeyPinCode = "KeyPinCode";
  final String KeyRequireChangePassword = "KeyRequireChangePassword";
  final String KeyCounter = "KeyCounter";
  final String KeyFirstLoad = "KeyFirstLoad";

  dynamic setRememberMe(bool isRemember) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KeyRemember, isRemember);
  }

  dynamic setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KeyToken, token);
  }

  dynamic setUserName(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KeyUsername, token);
  }

  dynamic setUserPassword(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KeyPassword, token);
  }

  dynamic setAgentSetting(bool isIncrease) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KeyAgentSetting, isIncrease);
  }

  dynamic setRequirePinCode(bool isPinCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KeyPinCode, isPinCode);
  }

  dynamic setRequirePassword(bool isRequirePassword) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KeyRequireChangePassword, isRequirePassword);
  }

  dynamic saveAmountNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt(KeyCounter) ?? 0) + 1;
    await prefs.setInt(KeyCounter, counter);
  }

  dynamic setFirstLoad(bool firstLoad) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KeyFirstLoad, firstLoad);
  }

  Future<bool?> getIsFirstLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KeyFirstLoad) ?? true;
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KeyToken) ?? "";
  }

  Future<bool?> getAgentSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KeyAgentSetting) ?? false;
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KeyUsername) ?? "";
  }

  Future<String?> getUserPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KeyPassword) ?? "";
  }

  Future<bool?> getIsRemember() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KeyRemember) ?? true;
  }

  Future<bool?> getIsRequirePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KeyRequireChangePassword) ?? false;
  }

  Future<bool?> getIsRequirePinCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KeyPinCode) ?? false;
  }

  Future<int?> getAmountNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(KeyCounter) ?? 0;
  }

  Future<bool> clearUserDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove(KeyRemember);
    await prefs.remove(KeyToken);
    // await prefs.remove(KeyUsername);
    await prefs.remove(KeyPassword);
    await prefs.remove(KeyAgentSetting);
    await prefs.remove(KeyPinCode);
    await prefs.remove(KeyRequireChangePassword);
    return true;
  }

  Future<bool> clearAmountNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(KeyCounter, 0);
  }
}
