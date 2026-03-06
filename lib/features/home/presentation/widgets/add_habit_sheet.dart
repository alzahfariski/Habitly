import 'package:flutter/material.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/habit_entity.dart';

class AddHabitSheet extends StatefulWidget {
  final Function(HabitEntity) onSave;
  final DateTime initialDate;
  final HabitEntity? existingHabit;

  const AddHabitSheet({
    super.key,
    required this.onSave,
    required this.initialDate,
    this.existingHabit,
  });

  @override
  State<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<AddHabitSheet> {
  final _titleController = TextEditingController();

  final List<String> _categories = [
    'Work',
    'Health',
    'Learning',
    'Personal',
    'Shopping',
    'Food',
  ];
  String _selectedCategory = 'Work';
  String _selectedTime = '09:00 AM';

  @override
  void initState() {
    super.initState();
    if (widget.existingHabit != null) {
      _titleController.text = widget.existingHabit!.title;
      _selectedCategory = widget.existingHabit!.category;
      if (!_categories.contains(_selectedCategory)) {
        _categories.add(_selectedCategory);
      }
      _selectedTime = widget.existingHabit!.time;
    }
  }

  void _addNewCategory() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Category Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _categories.add(controller.text);
                  _selectedCategory = controller.text;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return Icons.work_outline;
      case 'health':
        return Icons.fitness_center;
      case 'learning':
        return Icons.menu_book;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      case 'food':
        return Icons.restaurant;
      case 'personal':
        return Icons.person_outline;
      default:
        return Icons.star_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral900 : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.existingHabit != null ? 'Edit Task' : 'New Task',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'What is your goal?',
              filled: true,
              fillColor: isDark ? AppColors.neutral800 : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ..._categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary500
                                  : AppColors.primary100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getCategoryIcon(cat),
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primary600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cat,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.primary600
                                  : (isDark
                                        ? AppColors.neutral300
                                        : Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                GestureDetector(
                  onTap: _addNewCategory,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.neutral800
                              : Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: isDark ? AppColors.neutral400 : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('Add', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          InkWell(
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                setState(() {
                  _selectedTime = time.format(context);
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.neutral800 : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: isDark ? AppColors.neutral400 : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Text(_selectedTime, style: const TextStyle(fontSize: 16)),
                  const Spacer(),
                  Icon(
                    Icons.arrow_drop_down,
                    color: isDark ? AppColors.neutral400 : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          AppButton(
            text: widget.existingHabit != null ? 'Save Changes' : 'Create Task',
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                widget.onSave(
                  HabitEntity(
                    id: widget.existingHabit?.id ?? DateTime.now().toString(),
                    title: _titleController.text,
                    description: '',
                    category: _selectedCategory,
                    date: widget.existingHabit?.date ?? widget.initialDate,
                    time: _selectedTime,
                    isCompleted: widget.existingHabit?.isCompleted ?? false,
                    completedAt: widget.existingHabit?.completedAt,
                  ),
                );
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
