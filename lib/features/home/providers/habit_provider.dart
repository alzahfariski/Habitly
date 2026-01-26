import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/hive_service.dart';
import '../models/habit_model.dart';

// State class to hold the list of habits and loading status
class HabitState {
  final List<HabitModel> habits;
  final bool isLoading;
  final String? error;

  HabitState({this.habits = const [], this.isLoading = false, this.error});

  HabitState copyWith({
    List<HabitModel>? habits,
    bool? isLoading,
    String? error,
  }) {
    return HabitState(
      habits: habits ?? this.habits,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier class to manage the state
class HabitNotifier extends StateNotifier<HabitState> {
  HabitNotifier() : super(HabitState()) {
    loadHabits();
  }

  void loadHabits() {
    state = state.copyWith(isLoading: true);
    try {
      final habits = HiveService.getHabits();
      state = state.copyWith(habits: habits, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addHabit(HabitModel habit) async {
    try {
      await HiveService.addHabit(habit);
      final updatedHabits = [...state.habits, habit];
      state = state.copyWith(habits: updatedHabits);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateHabit(HabitModel habit) async {
    try {
      await HiveService.updateHabit(habit);
      final updatedHabits = state.habits.map((h) {
        return h.id == habit.id ? habit : h;
      }).toList();
      state = state.copyWith(habits: updatedHabits);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteHabit(String id) async {
    try {
      await HiveService.deleteHabit(id);
      final updatedHabits = state.habits.where((h) => h.id != id).toList();
      state = state.copyWith(habits: updatedHabits);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

// Global Providers
final habitProvider = StateNotifierProvider<HabitNotifier, HabitState>((ref) {
  return HabitNotifier();
});

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final filteredHabitsProvider = Provider<List<HabitModel>>((ref) {
  final habitState = ref.watch(habitProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  return habitState.habits.where((h) {
    return h.date.year == selectedDate.year &&
        h.date.month == selectedDate.month &&
        h.date.day == selectedDate.day;
  }).toList();
});
