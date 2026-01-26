import 'package:hive_flutter/hive_flutter.dart';
import '../../features/home/models/habit_model.dart';

class HiveService {
  static const String _habitBoxName = 'habits';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HabitModelAdapter());
    await Hive.openBox<HabitModel>(_habitBoxName);
  }

  static Box<HabitModel> get _habitBox => Hive.box<HabitModel>(_habitBoxName);

  static List<HabitModel> getHabits() {
    return _habitBox.values.toList();
  }

  static Future<void> addHabit(HabitModel habit) async {
    await _habitBox.put(habit.id, habit);
  }

  static Future<void> updateHabit(HabitModel habit) async {
    await _habitBox.put(habit.id, habit);
  }

  static Future<void> deleteHabit(String id) async {
    await _habitBox.delete(id);
  }
}
