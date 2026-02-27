import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/wave_clipper.dart';
import '../../auth/providers/auth_provider.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);
    final authState = ref.watch(authStateProvider);

    final userName = userProfileAsync.maybeWhen(
      data: (profile) =>
          profile?['name'] ?? authState.value?.displayName ?? 'User',
      orElse: () => authState.value?.displayName ?? 'User',
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary400, AppColors.primary600],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $userName',
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your daily goals',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withAlpha(230),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.neutral800 : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary200,
                      child: Icon(
                        Icons.person,
                        size: 28,
                        color: AppColors.primary600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
