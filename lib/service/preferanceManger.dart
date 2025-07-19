import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static final PreferenceManager  _instance = PreferenceManager._internal();
  factory PreferenceManager(){
    return _instance;
  }
  late final SharedPreferences _preferences;
  init() async{
    _preferences = await SharedPreferences.getInstance();

  }

  PreferenceManager._internal();
  setString (String key , String value){
    _preferences.setString(key, value);
  }
  setBoll (String key , bool value){
    _preferences.setBool(key, value);
  }
  String? getString (String key){
    return _preferences.getString(key) ;
  }
  bool? getbool (String key){
    return _preferences.getBool(key) ;
  }
  void clear(){
    _preferences.clear();
  }



}