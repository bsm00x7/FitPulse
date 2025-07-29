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
  setString (String key , String value)async{
    await _preferences.setString(key, value);
  }
  setBool (String key , bool value)async{
    await _preferences.setBool(key, value);
  }
  String? getString (String key){
    return _preferences.getString(key) ;
  }
  setDouble (String key, double value){
    return _preferences.setDouble(key, value);
  }
  getDouble (String key ){
    return _preferences.getDouble(key);
  }
  remove(String key){
    return _preferences.remove(key);
  }
  bool? getbool (String key){
    return _preferences.getBool(key) ;
  }
  void clear(){
    _preferences.clear();
  }



}