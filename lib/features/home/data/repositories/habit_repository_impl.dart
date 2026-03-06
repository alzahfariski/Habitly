import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/habit_remote_data_source.dart';
import '../models/habit_model.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitRemoteDataSource remoteDataSource;

  HabitRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<HabitEntity>> getHabitsStream(String uid) {
    return remoteDataSource.getHabitsStream(uid);
    // HabitModel extends HabitEntity, so this cast works,
    // though usually you'd map or cast explicitly:
    // .map((models) => models.cast<HabitEntity>());
  }

  @override
  Future<void> addHabit(String uid, HabitEntity habit) async {
    final habitModel = HabitModel.fromEntity(habit);
    await remoteDataSource.addHabit(uid, habitModel);
  }

  @override
  Future<void> updateHabit(String uid, HabitEntity habit) async {
    final habitModel = HabitModel.fromEntity(habit);
    await remoteDataSource.updateHabit(uid, habitModel);
  }

  @override
  Future<void> deleteHabit(String uid, String habitId) async {
    await remoteDataSource.deleteHabit(uid, habitId);
  }
}
