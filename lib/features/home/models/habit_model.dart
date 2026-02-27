import 'package:cloud_firestore/cloud_firestore.dart';

enum HabitStatus { all, upcoming, ongoing, completed }

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

  HabitStatus get status {
    if (isCompleted) return HabitStatus.completed;

    final now = DateTime.now();
    int hour = 0;
    int minute = 0;

    try {
      if (time.contains(':')) {
        final parts = time.split(':');
        hour = int.tryParse(parts[0]) ?? 0;
        final minutePart = parts[1].split(' ')[0];
        minute = int.tryParse(minutePart) ?? 0;

        if (time.toLowerCase().contains('pm') && hour < 12) {
          hour += 12;
        } else if (time.toLowerCase().contains('am') && hour == 12) {
          hour = 0;
        }
      }
    } catch (e) {
      // Fallback
    }

    final today = DateTime(now.year, now.month, now.day);
    final habitDateOnly = DateTime(date.year, date.month, date.day);

    if (habitDateOnly.isBefore(today)) {
      return HabitStatus.ongoing; // Past missed habits are ongoing
    } else if (habitDateOnly.isAfter(today)) {
      return HabitStatus.upcoming; // Future habits are upcoming
    }

    final habitDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );

    if (habitDateTime.isAfter(now)) {
      return HabitStatus.upcoming;
    } else {
      return HabitStatus.ongoing;
    }
  }

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
