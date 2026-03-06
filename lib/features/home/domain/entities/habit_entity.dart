import 'package:equatable/equatable.dart';

enum HabitStatus { all, upcoming, ongoing, completed }

class HabitEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String category;
  final DateTime date;
  final String time;
  final DateTime? completedAt;

  const HabitEntity({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.category,
    required this.date,
    required this.time,
    this.completedAt,
  });

  DateTime get targetDateTime {
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

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  HabitStatus get status {
    if (isCompleted) return HabitStatus.completed;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final habitDateOnly = DateTime(date.year, date.month, date.day);

    if (habitDateOnly.isBefore(today)) {
      return HabitStatus.ongoing; // Past missed habits are ongoing
    } else if (habitDateOnly.isAfter(today)) {
      return HabitStatus.upcoming; // Future habits are upcoming
    }

    final habitDateTime = targetDateTime;

    if (habitDateTime.isAfter(now)) {
      return HabitStatus.upcoming;
    } else {
      return HabitStatus.ongoing;
    }
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    isCompleted,
    category,
    date,
    time,
    completedAt,
  ];
}
