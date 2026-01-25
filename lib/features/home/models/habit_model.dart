class HabitModel {
  final String id;
  String title;
  String description;
  bool isCompleted;
  String category;
  DateTime date;
  String time;
  DateTime? completedAt;

  HabitModel({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.category,
    required this.date,
    required this.time,
    this.completedAt,
  });
}
