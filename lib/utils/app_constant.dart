import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
initStorage() async{
  sharedPreferences = await SharedPreferences.getInstance();
}