// activity_model.dart
class ActivityModel {
  final String sourceImage;
  final String title;
  final String subTitle;
  final DateTime timestamp;

  ActivityModel({
    required this.sourceImage,
    required this.title,
    required this.subTitle,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'sourceImage': sourceImage,
      'title': title,
      'subTitle': subTitle,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      sourceImage: map['sourceImage'],
      title: map['title'],
      subTitle: map['subTitle'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}