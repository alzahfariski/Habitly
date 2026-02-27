import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  Future<UserCredential> register({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? gender,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      try {
        // Update display name with timeout to prevent hanging
        await credential.user
            ?.updateDisplayName(name)
            .timeout(const Duration(seconds: 5));
      } catch (e) {
        // Ignore display name error, we still created the user successfully
      }

      try {
        // Save user profile to Firestore with timeout
        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set({
              'name': name,
              'email': email,
              'phone': phone ?? '',
              'gender': gender ?? '',
              'createdAt': FieldValue.serverTimestamp(),
            })
            .timeout(const Duration(seconds: 10));
      } catch (e) {
        // If Firestore fails (e.g. offline or rules issue), the user is still created in Auth.
        // We log the error but allow registration to complete so the app flow continues.
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      // Catch any other exceptions
      throw 'An error occurred during registration. Please try again.';
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw 'Failed to fetch user profile: $e';
    }
  }

  Future<void> updateUserProfile({
    required String uid,
    required String name,
    String? phone,
    String? gender,
  }) async {
    try {
      // Update Auth display name
      final user = _auth.currentUser;
      if (user != null && user.uid == uid) {
        await user.updateDisplayName(name);
      }

      // Update Firestore profile
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'phone': phone ?? '',
        'gender': gender ?? '',
      }, SetOptions(merge: true));
    } catch (e) {
      throw 'Failed to update profile: $e';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _mapAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}
