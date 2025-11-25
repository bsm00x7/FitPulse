import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager with ChangeNotifier {
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
  setDouble (String key, double value)async{
    await _preferences.setDouble(key, value);
  }
  setInt (String key, int value)async{
     await _preferences.setInt(key, value);
  }
  int? getInt (String key){
    return _preferences.getInt(key);
  }
  double? getDouble (String key ){
    final value = _preferences.get(key);
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return null;
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