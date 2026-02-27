import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/home/models/habit_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _habitsCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('habits');
  }

  /// Returns a real-time stream of habits for the given user
  Stream<List<HabitModel>> getHabitsStream(String uid) {
    return _habitsCollection(
      uid,
    ).orderBy('date', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return HabitModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Add a new habit
  Future<void> addHabit(String uid, HabitModel habit) async {
    await _habitsCollection(uid).doc(habit.id).set(habit.toMap());
  }

  /// Update an existing habit
  Future<void> updateHabit(String uid, HabitModel habit) async {
    await _habitsCollection(uid).doc(habit.id).update(habit.toMap());
  }

  /// Delete a habit by ID
  Future<void> deleteHabit(String uid, String habitId) async {
    await _habitsCollection(uid).doc(habitId).delete();
  }
}
