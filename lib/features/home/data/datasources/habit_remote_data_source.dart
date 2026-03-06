import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit_model.dart';

abstract class HabitRemoteDataSource {
  Stream<List<HabitModel>> getHabitsStream(String uid);
  Future<void> addHabit(String uid, HabitModel habit);
  Future<void> updateHabit(String uid, HabitModel habit);
  Future<void> deleteHabit(String uid, String habitId);
}

class HabitRemoteDataSourceImpl implements HabitRemoteDataSource {
  final FirebaseFirestore _firestore;

  HabitRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _habitsCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('habits');
  }

  @override
  Stream<List<HabitModel>> getHabitsStream(String uid) {
    return _habitsCollection(
      uid,
    ).orderBy('date', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return HabitModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  Future<void> addHabit(String uid, HabitModel habit) async {
    await _habitsCollection(uid).doc(habit.id).set(habit.toMap());
  }

  @override
  Future<void> updateHabit(String uid, HabitModel habit) async {
    await _habitsCollection(uid).doc(habit.id).update(habit.toMap());
  }

  @override
  Future<void> deleteHabit(String uid, String habitId) async {
    await _habitsCollection(uid).doc(habitId).delete();
  }
}
