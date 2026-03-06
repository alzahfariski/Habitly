import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';
import 'theme_provider.dart';

class NotificationSettings {
  final bool isEnabled;

  const NotificationSettings({required this.isEnabled});

  NotificationSettings copyWith({bool? isEnabled}) {
    return NotificationSettings(isEnabled: isEnabled ?? this.isEnabled);
  }
}

final notificationSettingsProvider =
    NotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
      NotificationSettingsNotifier.new,
    );

class NotificationSettingsNotifier extends Notifier<NotificationSettings> {
  static const _enabledKey = 'notification_enabled';

  @override
  NotificationSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final isEnabled = prefs.getBool(_enabledKey) ?? true;

    return NotificationSettings(isEnabled: isEnabled);
  }

  Future<void> updateSettings({bool? isEnabled}) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final newSettings = state.copyWith(isEnabled: isEnabled);

    state = newSettings;

    if (isEnabled != null) {
      await prefs.setBool(_enabledKey, newSettings.isEnabled);
    }

    // Apply native notifications
    final service = NotificationService();
    if (newSettings.isEnabled) {
      await service.requestPermissions();
    } else {
      await service.cancelAll();
    }
  }
}
