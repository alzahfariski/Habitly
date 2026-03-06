import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/habit_entity.dart';

class HabitModel extends HabitEntity {
  const HabitModel({
    required super.id,
    required super.title,
    required super.description,
    super.isCompleted,
    required super.category,
    required super.date,
    required super.time,
    super.completedAt,
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

  /// Create HabitModel from HabitEntity
  factory HabitModel.fromEntity(HabitEntity entity) {
    return HabitModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
      category: entity.category,
      date: entity.date,
      time: entity.time,
      completedAt: entity.completedAt,
    );
  }
}
