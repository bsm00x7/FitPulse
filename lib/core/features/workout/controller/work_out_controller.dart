import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../data/models/exercie_random_model.dart';

class WorkOutControllerProvider with ChangeNotifier {
  List<String> _bodyFocus = [];
  List<String> get bodyFocus => _bodyFocus;
  List <ExerciseModel> _random = [];
  List <ExerciseModel> get random =>_random;



  WorkOutControllerProvider(){
    allMuscles();
    initialRandomExercie();
  }
  Future <void> initialRandomExercie()async{
    try{
      final response = await http.get(Uri.parse('https://www.exercisedb.dev/api/v1/exercises/filter?limit=10&muscles=triceps'));
      debugPrint(response.statusCode.toString());
      if(response.statusCode ==200) {
        final List<dynamic>decoded = jsonDecode(response.body)['data'];
        _random = decoded.map((element) => ExerciseModel.fromMap(element)).toList();
        debugPrint(_random[0].name);
        debugPrint(_random[0].gifUrl);
      }

    }catch(e){
    debugPrint('Error fetching muscles: $e');
  }
  }
  // Fetch all Muscles for add in container in top
  Future<void> allMuscles() async {
    try {
      final url = Uri.parse('https://www.exercisedb.dev/api/v1/muscles');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> muscleList = decoded['data'] ?? [];
        _bodyFocus.clear();
        _bodyFocus = muscleList.map((e) => e['name'].toString()).toList();
        _bodyFocus.reversed;

        notifyListeners();
      } else {
        debugPrint('Failed to fetch muscles. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching muscles: $e');
    }
  }
  Future <void> randomExercice({required String nameMuscle}) async{
      final response = await http.get(Uri.parse('https://www.exercisedb.dev/api/v1/exercises/filter?limit=10&muscles=${nameMuscle.toLowerCase()}'));
      debugPrint(response.statusCode.toString());
      if(response.statusCode ==200) {
        final List<dynamic>decoded = jsonDecode(response.body)['data'];
        _random = decoded.map((element) => ExerciseModel.fromMap(element)).toList();
      }
    }

}