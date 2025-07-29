import 'dart:convert';

class UserModel {
  final String firstName;
  final String lastName;
  final String birthday;
  final double height; // Corrected typo from 'higth' to 'height'
  final double weight;
  final String gender;


  UserModel({
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.height,
    required this.weight,
    required this.gender, // Made required to match constructor parameters
  });

  // Convert UserModel to JSON string
  String toJson() {
    return jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday,
      'height': height,
      'weight': weight,
      'gender': gender,
    });
  }

  // Convert JSON string to UserModel
  factory UserModel.fromJson(String user) {
    final Map<String, dynamic> data = jsonDecode(user);
    return UserModel(
      firstName: data['firstName'] as String,
      lastName: data['lastName'] as String,
      birthday: data['birthday'] as String,
      height: (data['height'] as num).toDouble(),
      weight: (data['weight'] as num).toDouble(),
      gender: data['gender'] as String,
    );
  }



  // Convert UserModel to Map (useful for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday,
      'height': height,
      'weight': weight,
      'gender': gender,
    };
  }

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? birthday,
    double? height,
    double? weight,
    String? gender,
  }) {
    return UserModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthday: birthday ?? this.birthday,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
    );
  }
}