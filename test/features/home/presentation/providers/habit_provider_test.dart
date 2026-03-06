import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:habitly/features/home/domain/entities/habit_entity.dart';
import 'package:habitly/features/home/domain/repositories/habit_repository.dart';
import 'package:habitly/features/home/presentation/providers/habit_provider.dart';

class MockHabitRepository extends Mock implements HabitRepository {
  @override
  Stream<List<HabitEntity>> getHabitsStream(String? uid) {
    return super.noSuchMethod(
      Invocation.method(#getHabitsStream, [uid]),
      returnValue: Stream<List<HabitEntity>>.fromIterable([]),
    );
  }

  @override
  Future<void> addHabit(String? uid, HabitEntity? habit) {
    return super.noSuchMethod(
      Invocation.method(#addHabit, [uid, habit]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }
}

void main() {
  late MockHabitRepository mockRepository;
  late HabitNotifier notifier;

  setUp(() {
    mockRepository = MockHabitRepository();
    when(
      mockRepository.getHabitsStream(any),
    ).thenAnswer((_) => Stream<List<HabitEntity>>.value([]));
    notifier = HabitNotifier(mockRepository, 'user_123');
  });

  group('HabitNotifier', () {
    test('initial state should be empty after stream returns', () async {
      await Future.delayed(Duration.zero); // Wait for stream to emit
      expect(notifier.state.habits, isEmpty);
      expect(notifier.state.isLoading, isFalse);
      debugPrint(
        '✅ [Presentation Test] HabitNotifier starts with empty and is False loading status',
      );
    });

    test(
      'addHabit should call repository and not update state manually',
      () async {
        when(mockRepository.addHabit(any, any)).thenAnswer((_) async => {});

        final habit = HabitEntity(
          id: 'new_id',
          title: 'New Habit',
          description: '',
          category: 'Work',
          date: DateTime.now(),
          time: '10:00 AM',
        );

        await notifier.addHabit(habit);

        verify(mockRepository.addHabit('user_123', any)).called(1);
        debugPrint(
          '✅ [Presentation Test] HabitNotifier accurately calls repository addHabit function without manual state errors',
        );
      },
    );
  });
}
