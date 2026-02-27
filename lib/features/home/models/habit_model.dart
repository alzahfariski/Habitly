import 'package:cloud_firestore/cloud_firestore.dart';

class HabitModel {
  final String id;
  String title;
  String description;
  bool isCompleted;
  String category;
  DateTime date;
  String time;
  DateTime? completedAt;

  HabitModel({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.category,
    required this.date,
    required this.time,
    this.completedAt,
  });

  /// Convert to Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'category': category,
      'date': Timestamp.fromDate(date),
      'time': time,
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null,
    };
  }

  /// Create HabitModel from Firestore document
  factory HabitModel.fromMap(Map<String, dynamic> map, String id) {
    return HabitModel(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      isCompleted: map['isCompleted'] as bool? ?? false,
      category: map['category'] as String? ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      time: map['time'] as String? ?? '',
      completedAt: (map['completedAt'] as Timestamp?)?.toDate(),
    );
  }
}
