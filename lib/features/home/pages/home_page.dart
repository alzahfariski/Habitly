import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';
import '../models/habit_model.dart';
import '../widgets/add_habit_sheet.dart';
import '../widgets/habit_card.dart';
import '../widgets/home_header.dart';
import '../widgets/horizontal_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();

  // 1. Start with NO Dummy Data
  final List<HabitModel> _habits = [];

  // Logic to filter habits by selected date
  List<HabitModel> get _filteredHabits {
    return _habits.where((h) {
      return h.date.year == _selectedDate.year &&
          h.date.month == _selectedDate.month &&
          h.date.day == _selectedDate.day;
    }).toList();
  }

  // 3. Helper to show BottomSheet for Add/Update
  void _showHabitSheet({HabitModel? habitToEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddHabitSheet(
        initialDate: _selectedDate,
        existingHabit: habitToEdit,
        onSave: (habit) {
          setState(() {
            if (habitToEdit != null) {
              // Update Logic
              final index = _habits.indexWhere((h) => h.id == habit.id);
              if (index != -1) {
                _habits[index] = habit;
              }
            } else {
              _habits.add(habit);
            }
          });
        },
      ),
    );
  }

  void _deleteHabit(String id) {
    setState(() {
      _habits.removeWhere((h) => h.id == id);
    });
  }

  void _toggleHabit(HabitModel habit, bool? val) {
    setState(() {
      habit.isCompleted = val ?? false;
      habit.completedAt = habit.isCompleted ? DateTime.now() : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showHabitSheet(),
        backgroundColor: AppColors.primary500,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),

            HorizontalCalendar(
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
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

                    if (_filteredHabits.isEmpty)
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
                          itemCount: _filteredHabits.length,
                          itemBuilder: (context, index) {
                            final habit = _filteredHabits[index];
                            return HabitCard(
                              habit: habit,
                              onEdit: () => _showHabitSheet(habitToEdit: habit),
                              onDelete: () => _deleteHabit(habit.id),
                              onHighlight: (val) => _toggleHabit(habit, val),
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
