import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitly/features/home/domain/entities/habit_entity.dart';

void main() {
  group('HabitEntity status tests', () {
    test('should return HabitStatus.completed if isCompleted is true', () {
      final habit = HabitEntity(
        id: '1',
        title: 'Test',
        description: '',
        category: 'Work',
        date: DateTime.now(),
        time: '09:00 AM',
        isCompleted: true,
      );

      expect(habit.status, HabitStatus.completed);
      debugPrint(
        '✅ [Domain Test] isCompleted=true correctly returns HabitStatus.completed',
      );
    });

    test('should return HabitStatus.ongoing if the date is in the past', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 1));
      final habit = HabitEntity(
        id: '2',
        title: 'Test',
        description: '',
        category: 'Work',
        date: pastDate,
        time: '09:00 AM',
        isCompleted: false,
      );

      expect(habit.status, HabitStatus.ongoing);
      debugPrint(
        '✅ [Domain Test] Past date correctly returns HabitStatus.ongoing',
      );
    });

    test('should return HabitStatus.upcoming if the date is in the future', () {
      final futureDate = DateTime.now().add(const Duration(days: 1));
      final habit = HabitEntity(
        id: '3',
        title: 'Test',
        description: '',
        category: 'Work',
        date: futureDate,
        time: '09:00 AM',
        isCompleted: false,
      );

      expect(habit.status, HabitStatus.upcoming);
      debugPrint(
        '✅ [Domain Test] Future date correctly returns HabitStatus.upcoming',
      );
    });
  });
}
