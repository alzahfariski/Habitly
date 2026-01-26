import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_color.dart';
import '../models/habit_model.dart';
import '../widgets/add_habit_sheet.dart';
import '../widgets/habit_card.dart';
import '../widgets/home_header.dart';
import '../widgets/horizontal_calendar.dart';
import '../providers/habit_provider.dart';
import '../../../core/widgets/confirm_dialog.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void _showHabitSheet(
    BuildContext context,
    WidgetRef ref, {
    HabitModel? habitToEdit,
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

    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showHabitSheet(context, ref),
        backgroundColor: AppColors.primary500,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),

            HorizontalCalendar(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                ref.read(selectedDateProvider.notifier).state = date;
              },
            ),

            const SizedBox(height: 24),

            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Today\'s Tasks',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (habitState.isLoading)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (filteredHabits.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_note,
                                size: 60,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No tasks for this day',
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredHabits.length,
                          itemBuilder: (context, index) {
                            final habit = filteredHabits[index];
                            return HabitCard(
                              habit: habit,
                              onEdit: () => _showHabitSheet(
                                context,
                                ref,
                                habitToEdit: habit,
                              ),
                              onDelete: () =>
                                  _deleteHabit(context, ref, habit.id),
                              onHighlight: (val) {
                                final updatedHabit = HabitModel(
                                  id: habit.id,
                                  title: habit.title,
                                  description: habit.description,
                                  category: habit.category,
                                  date: habit.date,
                                  time: habit.time,
                                  isCompleted: val ?? false,
                                  completedAt: (val ?? false)
                                      ? DateTime.now()
                                      : null,
                                );
                                ref
                                    .read(habitProvider.notifier)
                                    .updateHabit(updatedHabit);
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
