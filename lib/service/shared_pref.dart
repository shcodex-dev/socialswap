import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userPicKey = "USERPICKEY";
  static String displaynameKey = "USERDISPLAYNAME";
  // user wallet share pref //
  static final storeKey = "";
  static String addressKey = "";
  static final networkKey = "";
  static final privateKey = "";

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserPic(String getUserPic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userPicKey, getUserPic);
  }

  Future<bool> saveUserDisplayName(String getUserDisplayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(displaynameKey, getUserDisplayName);
  }

  // user wallet shared pref //
  Future<bool> saveStore(String store) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(storeKey, store);
  }

  Future<bool> saveAddress(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(addressKey, address);
  }

  Future<bool> saveNetwork(String network) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(networkKey, network);
  }

  Future<bool> savePrivateKey(String privateKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(privateKey, privateKey);
  }


  // --------------------------------- get user sharef pref ---------------------------------//
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserPic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userPicKey);
  }

  Future<String?> getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(displaynameKey);
  }

  // get user wallet sharef pref //
  Future<String?> getStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(storeKey);
  }

  Future<String?> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(addressKey);
  }

  Future<String?> getNetwork() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(networkKey);
  }

  Future<String?> getPrivateKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(privateKey);
  }
}
