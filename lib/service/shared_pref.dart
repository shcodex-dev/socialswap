import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userPicKey = "USERPICKEY";
  static String displaynameKey = "USERDISPLAYNAME";
  
  // user wallet share pref //
  static String userAddressKey = "USERADDRESSKEY";
  static String userPrivateKey = "USERPRIVATEKEY";

  static String storeCheckKey = "STORECHECKKEY";

  // wallet balance //
  static String walletBalanceKey = "WALLETBALANCEKEY";

  // --------------------------------- save user sharef pref ---------------------------------//

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
  Future<bool> saveUserAddress(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userAddressKey, address);
  }

  Future<bool> saveUserPrivateKey(String privateK) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userPrivateKey, privateK);
  }

  Future<bool> saveStoreCheck(String storeCheck) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(storeCheckKey, storeCheck);
  }

  // wallet balance //
  Future<bool> saveWalletBalance(String balance) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(walletBalanceKey, balance);
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
  Future<String?> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userAddressKey);
  }

  Future<String?> getPrivateKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userPrivateKey);
  }

  Future<String?> getStoreCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(storeCheckKey);
  }

  // wallet balance //
  Future<String?> getWalletBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(walletBalanceKey);
  }
}
