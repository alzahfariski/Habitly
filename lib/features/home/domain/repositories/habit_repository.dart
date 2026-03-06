import '../entities/habit_entity.dart';

abstract class HabitRepository {
  Stream<List<HabitEntity>> getHabitsStream(String uid);
  Future<void> addHabit(String uid, HabitEntity habit);
  Future<void> updateHabit(String uid, HabitEntity habit);
  Future<void> deleteHabit(String uid, String habitId);
}
