import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../../../core/constants/app_color.dart';

class HabitCard extends StatelessWidget {
  final HabitModel habit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool?> onHighlight;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onEdit,
    required this.onDelete,
    required this.onHighlight,
  });

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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary100.withAlpha(10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _getCategoryIcon(habit.category),
              color: AppColors.primary600,
            ),
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    decoration: habit.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      habit.time,
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                    if (habit.isCompleted) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(10),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Checkbox
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: habit.isCompleted,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              activeColor: AppColors.primary500,
              side: BorderSide(color: Colors.grey.shade300, width: 2),
              onChanged: onHighlight,
            ),
          ),

          // Menu
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                onEdit();
              } else if (value == 'delete') {
                onDelete();
              }
            },
            icon: Icon(Icons.more_vert, color: Colors.grey[400]),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
