import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../data/datasources/habit_remote_data_source.dart';
import '../../data/repositories/habit_repository_impl.dart';
import '../../../../core/services/notification_service.dart';

/// Provider for the remote data source
final habitRemoteDataSourceProvider = Provider<HabitRemoteDataSource>((ref) {
  return HabitRemoteDataSourceImpl();
});

/// Provider for the repository
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final remoteDataSource = ref.watch(habitRemoteDataSourceProvider);
  return HabitRepositoryImpl(remoteDataSource: remoteDataSource);
});

class HabitState {
  final List<HabitEntity> habits;
  final bool isLoading;
  final String? error;

  HabitState({this.habits = const [], this.isLoading = false, this.error});

  HabitState copyWith({
    List<HabitEntity>? habits,
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

/// Notifier class to manage the habit state using the Repository
class HabitNotifier extends StateNotifier<HabitState> {
  final HabitRepository _repository;
  final String _uid;
  StreamSubscription? _subscription;

  HabitNotifier(this._repository, this._uid) : super(HabitState()) {
    _listenToHabits();
  }

  void _listenToHabits() {
    if (_uid.isEmpty) {
      state = state.copyWith(isLoading: false, habits: []);
      return;
    }

    state = state.copyWith(isLoading: true);
    _subscription = _repository
        .getHabitsStream(_uid)
        .listen(
          (habits) {
            state = state.copyWith(habits: habits, isLoading: false);
          },
          onError: (e) {
            state = state.copyWith(isLoading: false, error: e.toString());
          },
        );
  }

  Future<void> addHabit(HabitEntity habit) async {
    try {
      final newHabit = HabitEntity(
        id: const Uuid().v4(),
        title: habit.title,
        description: habit.description,
        category: habit.category,
        date: habit.date,
        time: habit.time,
        isCompleted: habit.isCompleted,
        completedAt: habit.completedAt,
      );
      await _repository.addHabit(_uid, newHabit);
      await NotificationService().scheduleHabitReminder(newHabit);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateHabit(HabitEntity habit) async {
    try {
      await _repository.updateHabit(_uid, habit);
      await NotificationService().scheduleHabitReminder(habit);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> toggleHabitCompletion(
    HabitEntity habit,
    bool isCompleted,
  ) async {
    try {
      final updatedHabit = HabitEntity(
        id: habit.id,
        title: habit.title,
        description: habit.description,
        category: habit.category,
        date: habit.date,
        time: habit.time,
        isCompleted: isCompleted,
        completedAt: isCompleted ? DateTime.now() : null,
      );
      await _repository.updateHabit(_uid, updatedHabit);

      if (isCompleted) {
        await NotificationService().cancelHabitReminder(habit.id);
      } else {
        await NotificationService().scheduleHabitReminder(updatedHabit);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteHabit(String id) async {
    try {
      await _repository.deleteHabit(_uid, id);
      await NotificationService().cancelHabitReminder(id);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/// Habit provider that depends on the authenticated user's UID and the repository
final habitProvider = StateNotifierProvider<HabitNotifier, HabitState>((ref) {
  final authState = ref.watch(authStateProvider);
  final uid = authState.value?.uid ?? '';
  final repository = ref.watch(habitRepositoryProvider);
  return HabitNotifier(repository, uid);
});

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

enum HabitSortConfig { timeAsc, timeDesc, nameAsc, nameDesc }

final habitFilterProvider = StateProvider<HabitStatus>(
  (ref) => HabitStatus.all,
);
final habitSortProvider = StateProvider<HabitSortConfig>(
  (ref) => HabitSortConfig.timeAsc,
);

final filteredHabitsProvider = Provider<List<HabitEntity>>((ref) {
  final habitState = ref.watch(habitProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  final filter = ref.watch(habitFilterProvider);
  final sortConfig = ref.watch(habitSortProvider);

  var filtered = habitState.habits.where((h) {
    final matchesDate =
        h.date.year == selectedDate.year &&
        h.date.month == selectedDate.month &&
        h.date.day == selectedDate.day;

    if (!matchesDate) return false;
    if (filter == HabitStatus.all) return true;

    return h.status == filter;
  }).toList();

  filtered.sort((a, b) {
    switch (sortConfig) {
      case HabitSortConfig.timeAsc:
        return _compareTime(a.time, b.time);
      case HabitSortConfig.timeDesc:
        return _compareTime(b.time, a.time);
      case HabitSortConfig.nameAsc:
        return a.title.compareTo(b.title);
      case HabitSortConfig.nameDesc:
        return b.title.compareTo(a.title);
    }
  });

  return filtered;
});

int _compareTime(String time1, String time2) {
  int getMinutes(String time) {
    try {
      if (!time.contains(':')) return 0;
      final parts = time.split(':');
      int h = int.tryParse(parts[0]) ?? 0;
      int m = int.tryParse(parts[1].split(' ')[0]) ?? 0;
      if (time.toLowerCase().contains('pm') && h < 12) h += 12;
      if (time.toLowerCase().contains('am') && h == 12) h = 0;
      return h * 60 + m;
    } catch (_) {
      return 0;
    }
  }

  return getMinutes(time1).compareTo(getMinutes(time2));
}
