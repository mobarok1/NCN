import 'app_constant.dart';


class SharedPrefManager{
  static SharedPrefManager? _instance;
  static SharedPrefManager get instance=>_instance??SharedPrefManager();
  String passwordString="walletPassword";
  String emailString="emailString";
  String accountPasswordString="accountPasswordString";

  Future<bool> logout() async{
    return await sharedPreferences!.clear();
  }
  Future<bool> setAccountUserName(String email) async{
    return await sharedPreferences!.setString(emailString,email);
  }
  Future<bool> setAccountPassword(String password) async{
    return await sharedPreferences!.setString(accountPasswordString,password);
  }

  Future<String> getAccountUserName() async{
    return  sharedPreferences!.getString(emailString)??"";
  }
  Future<String> getAccountPassword() async{
    return  sharedPreferences!.getString(accountPasswordString)??"";
  }
}