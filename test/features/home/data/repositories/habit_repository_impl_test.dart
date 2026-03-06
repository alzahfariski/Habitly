import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:habitly/features/home/domain/entities/habit_entity.dart';
import 'package:habitly/features/home/data/models/habit_model.dart';
import 'package:habitly/features/home/data/datasources/habit_remote_data_source.dart';
import 'package:habitly/features/home/data/repositories/habit_repository_impl.dart';

class MockHabitRemoteDataSource extends Mock implements HabitRemoteDataSource {
  @override
  Stream<List<HabitModel>> getHabitsStream(String? uid) {
    return super.noSuchMethod(
      Invocation.method(#getHabitsStream, [uid]),
      returnValue: Stream<List<HabitModel>>.empty(),
    );
  }

  @override
  Future<void> addHabit(String? uid, HabitModel? habit) {
    return super.noSuchMethod(
      Invocation.method(#addHabit, [uid, habit]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }
}

void main() {
  late HabitRepositoryImpl repository;
  late MockHabitRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockHabitRemoteDataSource();
    repository = HabitRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('HabitRepositoryImpl', () {
    final tHabitEntity = HabitEntity(
      id: '1',
      title: 'Workout',
      description: 'Gym',
      category: 'Health',
      date: DateTime(2023, 1, 1),
      time: '06:00 AM',
      isCompleted: false,
    );
    final tUid = 'user_123';

    test(
      'should call remoteDataSource.addHabit when addHabit is called',
      () async {
        when(mockDataSource.addHabit(any, any)).thenAnswer((_) async => {});

        await repository.addHabit(tUid, tHabitEntity);

        // Verify that the data source was called once
        verify(mockDataSource.addHabit(tUid, any)).called(1);
        verifyNoMoreInteractions(mockDataSource);
        debugPrint(
          '✅ [Data Test] HabitRepositoryImpl correctly routes addHabit to RemoteDataSource',
        );
      },
    );
  });
}
