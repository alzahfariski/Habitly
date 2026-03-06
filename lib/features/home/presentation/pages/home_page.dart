import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_color.dart';
import '../../domain/entities/habit_entity.dart';
import '../widgets/add_habit_sheet.dart';
import '../widgets/habit_card.dart';
import '../widgets/home_header.dart';
import '../widgets/horizontal_calendar.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_progress_chart.dart';
import '../../../../core/widgets/confirm_dialog.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  String _getSortText(HabitSortConfig config) {
    switch (config) {
      case HabitSortConfig.timeAsc:
        return 'Earliest first';
      case HabitSortConfig.timeDesc:
        return 'Latest first';
      case HabitSortConfig.nameAsc:
        return 'Name (A-Z)';
      case HabitSortConfig.nameDesc:
        return 'Name (Z-A)';
    }
  }

  void _showHabitSheet(
    BuildContext context,
    WidgetRef ref, {
    HabitEntity? habitToEdit,
  }) {
    final selectedDate = ref.read(selectedDateProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddHabitSheet(
        initialDate: selectedDate,
        existingHabit: habitToEdit,
        onSave: (habit) {
          if (habitToEdit != null) {
            ref.read(habitProvider.notifier).updateHabit(habit);
          } else {
            ref.read(habitProvider.notifier).addHabit(habit);
          }
        },
      ),
    );
  }

  void _deleteHabit(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Delete Habit',
        content: 'Are you sure you want to delete this habit?',
        onConfirm: () {
          ref.read(habitProvider.notifier).deleteHabit(id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final filteredHabits = ref.watch(filteredHabitsProvider);
    final habitState = ref.watch(habitProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showHabitSheet(context, ref),
        backgroundColor: AppColors.primary500,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HomeHeader(),

            HorizontalCalendar(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                ref.read(selectedDateProvider.notifier).state = date;
              },
            ),

            const SizedBox(height: 16),
            const HabitProgressChart(),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Today\'s Tasks',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PopupMenuButton<HabitSortConfig>(
                        offset: const Offset(0, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onSelected: (config) {
                          ref.read(habitSortProvider.notifier).state = config;
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: HabitSortConfig.timeAsc,
                            child: Text('Time (Earliest first)'),
                          ),
                          PopupMenuItem(
                            value: HabitSortConfig.timeDesc,
                            child: Text('Time (Latest first)'),
                          ),
                          PopupMenuItem(
                            value: HabitSortConfig.nameAsc,
                            child: Text('Name (A-Z)'),
                          ),
                          PopupMenuItem(
                            value: HabitSortConfig.nameDesc,
                            child: Text('Name (Z-A)'),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.neutral800
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.sort,
                                size: 16,
                                color: isDark
                                    ? AppColors.neutral400
                                    : Colors.grey[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _getSortText(ref.watch(habitSortProvider)),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.neutral400
                                      : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: HabitStatus.values
                          .where((status) {
                            final now = DateTime.now();
                            final today = DateTime(
                              now.year,
                              now.month,
                              now.day,
                            );
                            final selected = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                            );

                            if (status == HabitStatus.upcoming &&
                                selected.isBefore(today)) {
                              return false; // No upcoming tasks in the past
                            }
                            if (status == HabitStatus.upcoming &&
                                selected.day == today.day) {
                              return false; // No upcoming tasks in the past
                            }
                            if (status == HabitStatus.ongoing &&
                                selected.isAfter(today)) {
                              return false; // No ongoing tasks in the future
                            }
                            return true;
                          })
                          .map((status) {
                            final isActive =
                                ref.watch(habitFilterProvider) == status;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FilterChip(
                                label: Text(
                                  status.name.substring(0, 1).toUpperCase() +
                                      status.name.substring(1),
                                  style: TextStyle(
                                    color: isActive
                                        ? Colors.white
                                        : (isDark
                                              ? AppColors.neutral300
                                              : Colors.black87),
                                    fontWeight: isActive
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                selected: isActive,
                                selectedColor: AppColors.primary500,
                                backgroundColor: isDark
                                    ? AppColors.neutral800
                                    : Colors.grey[200],
                                showCheckmark: false,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: isActive
                                        ? AppColors.primary500
                                        : Colors.transparent,
                                  ),
                                ),
                                onSelected: (isSelected) {
                                  if (isSelected) {
                                    ref
                                            .read(habitFilterProvider.notifier)
                                            .state =
                                        status;
                                  } else if (status != HabitStatus.all) {
                                    // If unselecting a specific filter, default back to 'all'
                                    ref
                                            .read(habitFilterProvider.notifier)
                                            .state =
                                        HabitStatus.all;
                                  }
                                },
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (habitState.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (filteredHabits.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_note,
                              size: 60,
                              color: isDark
                                  ? AppColors.neutral700
                                  : Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No tasks for this day',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.neutral400
                                    : Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      itemCount: filteredHabits.length,
                      itemBuilder: (context, index) {
                        final habit = filteredHabits[index];
                        return HabitCard(
                          habit: habit,
                          onEdit: () =>
                              _showHabitSheet(context, ref, habitToEdit: habit),
                          onDelete: () => _deleteHabit(context, ref, habit.id),
                          onHighlight: (val) {
                            ref
                                .read(habitProvider.notifier)
                                .toggleHabitCompletion(habit, val ?? false);
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }
}
