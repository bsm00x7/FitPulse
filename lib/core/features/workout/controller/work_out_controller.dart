import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class WorkOutControllerProvider with ChangeNotifier {
  List<String> bodyFocus = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> bodyFocusItem() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://www.exercisedb.dev/api/v1/muscles'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Check if the muscles key exists and is a list
        if (data.containsKey('muscles') && data['muscles'] is List) {
          final List<dynamic> musclesList = data['muscles'];

          bodyFocus = musclesList
              .where((item) => item != null && item['name'] != null)
              .map((item) => item['name'].toString())
              .toList();

          print('Muscles loaded: $bodyFocus');
        } else {
          // Handle case where API structure is different
          print('Unexpected API response structure: $data');
          errorMessage = 'Unexpected data format from API';
        }
      } else {
        errorMessage = 'Failed to load muscles. Status code: ${response.statusCode}';
        print(errorMessage);
      }
    } catch (e) {
      errorMessage = 'Error loading muscles: $e';
      print(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}