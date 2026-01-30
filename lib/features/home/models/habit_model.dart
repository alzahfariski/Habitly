import 'package:hive_flutter/hive_flutter.dart';

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

class HabitAdapter extends TypeAdapter<HabitModel> {
  @override
  final int typeId = 0;

  @override
  HabitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      isCompleted: fields[3] as bool,
      category: fields[4] as String,
      date: fields[5] as DateTime,
      time: fields[6] as String,
      completedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HabitModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.time)
      ..writeByte(7)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
