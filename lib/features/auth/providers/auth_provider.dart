import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth_service.dart';

/// Singleton instance of AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Stream of auth state changes — emits User? whenever login/logout occurs
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Future provider to fetch the logged-in user's profile from Firestore
final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final uid = authState.value?.uid;
  if (uid == null) return null;

  final authService = ref.watch(authServiceProvider);
  return await authService.getUserProfile(uid);
});
