import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';

final profileControllerProvider =
    AsyncNotifierProvider.autoDispose<ProfileController, void>(() {
      return ProfileController();
    });

class ProfileController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null; // Initial state
  }

  Future<void> saveProfile({
    required String name,
    required String phone,
    String? gender,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      final uid = ref.read(authStateProvider).value?.uid;

      if (uid != null) {
        await authService.updateUserProfile(
          uid: uid,
          name: name.trim(),
          phone: phone.trim(),
          gender: gender,
        );
        // Invalidate to notify UI (e.g. HomeHeader) about the change
        ref.invalidate(userProfileProvider);
      } else {
        throw Exception('User not found');
      }
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
    });
  }
}
