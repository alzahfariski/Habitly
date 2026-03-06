import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/wave_clipper.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/providers/notification_settings_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/profile_controller.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedGender;
  final List<String> _genderOptions = ['Pria', 'Wanita'];
  bool _isInitialized = false;

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(profileControllerProvider.notifier)
        .saveProfile(
          name: _nameController.text,
          phone: _phoneController.text,
          gender: _selectedGender,
        );

    if (mounted) {
      final state = ref.read(profileControllerProvider);
      if (!state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await ref.read(profileControllerProvider.notifier).logout();
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProfileAsync = ref.watch(userProfileProvider);
    final profileState = ref.watch(profileControllerProvider);

    // Listen to errors from the controller
    ref.listen<AsyncValue<void>>(
      profileControllerProvider,
      (_, state) => state.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Colors.red[400],
            ),
          );
        },
      ),
    );

    return userProfileAsync.when(
      loading: () => Scaffold(
        backgroundColor: isDark ? AppColors.neutral900 : Colors.white,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary500),
        ),
      ),
      error: (e, st) => Scaffold(
        backgroundColor: isDark ? AppColors.neutral900 : Colors.white,
        body: Center(child: Text('Error: $e')),
      ),
      data: (profileData) {
        final authState = ref.watch(authStateProvider);

        if (!_isInitialized) {
          _nameController.text =
              profileData?['name'] ?? authState.value?.displayName ?? '';
          _phoneController.text = profileData?['phone'] ?? '';
          _selectedGender =
              (profileData?['gender'] == null || profileData?['gender'] == '')
              ? null
              : profileData!['gender'];
          _isInitialized = true;
        }

        final email = profileData?['email'] ?? authState.value?.email ?? '';
        final isSaving = profileState.isLoading;

        return Scaffold(
          backgroundColor: isDark ? AppColors.neutral900 : Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.primary500,
            elevation: 0,
            leading: const BackButton(color: Colors.white),
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipPath(
                      clipper: WaveClipper(),
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.primary500,
                              AppColors.primary700,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: isDark
                            ? AppColors.neutral800
                            : Colors.white,
                        child: CircleAvatar(
                          radius: 46,
                          backgroundColor: AppColors.primary200,
                          child: Text(
                            _nameController.text.isNotEmpty
                                ? _nameController.text[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email (Read-only)
                        TextFormField(
                          initialValue: email,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: isDark
                                  ? AppColors.neutral400
                                  : Colors.grey,
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: isDark
                                  ? AppColors.neutral400
                                  : Colors.grey,
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(
                                color: isDark
                                    ? AppColors.neutral600
                                    : Colors.grey,
                              ),
                            ),
                            filled: true,
                            fillColor: isDark
                                ? AppColors.neutral800
                                : const Color(0xFFF5F5F5),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Full Name
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            labelStyle: TextStyle(color: AppColors.primary600),
                            prefixIcon: Icon(Icons.person_outline),
                            prefixIconColor: AppColors.primary600,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.primary500,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.primary600,
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Please enter your name'
                              : null,
                          onChanged: (val) {
                            // Update UI explicitly if needed for avatar init
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 16),

                        // Phone Number
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(color: AppColors.primary600),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                '+62',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.primary600,
                                ),
                              ),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.primary500,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.primary600,
                                width: 2,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),

                        // Gender
                        DropdownButtonFormField<String>(
                          initialValue: _selectedGender,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            labelStyle: TextStyle(color: AppColors.primary600),
                            prefixIcon: Icon(Icons.wc),
                            prefixIconColor: AppColors.primary600,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.primary500,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.primary600,
                                width: 2,
                              ),
                            ),
                          ),
                          items: _genderOptions.map((String gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedGender = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Theme Mode
                        DropdownButtonFormField<ThemeMode>(
                          initialValue: ref.watch(themeProvider),
                          decoration: const InputDecoration(
                            labelText: 'Theme Mode',
                            labelStyle: TextStyle(color: AppColors.primary600),
                            prefixIcon: Icon(Icons.brightness_6),
                            prefixIconColor: AppColors.primary600,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.primary500,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.primary600,
                                width: 2,
                              ),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: ThemeMode.system,
                              child: Text('System'),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.light,
                              child: Text('Light'),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.dark,
                              child: Text('Dark'),
                            ),
                          ],
                          onChanged: (ThemeMode? newValue) {
                            if (newValue != null) {
                              ref
                                  .read(themeProvider.notifier)
                                  .setTheme(newValue);
                            }
                          },
                        ),
                        const SizedBox(height: 24),

                        // Notification Settings Section
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDark
                                  ? AppColors.neutral700
                                  : AppColors.primary500,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  top: 16,
                                  bottom: 8,
                                ),
                                child: Text(
                                  'Notifications',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary600,
                                  ),
                                ),
                              ),
                              Consumer(
                                builder: (context, ref, child) {
                                  final notifSettings = ref.watch(
                                    notificationSettingsProvider,
                                  );
                                  return SwitchListTile(
                                    title: const Text('Daily Reminders'),
                                    subtitle: const Text(
                                      'Remind me to check my habits',
                                    ),
                                    value: notifSettings.isEnabled,
                                    activeThumbColor: AppColors.primary500,
                                    onChanged: (value) {
                                      ref
                                          .read(
                                            notificationSettingsProvider
                                                .notifier,
                                          )
                                          .updateSettings(isEnabled: value);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        isSaving
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary500,
                                ),
                              )
                            : AppButton(
                                text: 'Save Changes',
                                onPressed: _saveProfile,
                              ),

                        const SizedBox(height: 48),

                        // Logout button
                        OutlinedButton.icon(
                          onPressed: _logout,
                          icon: const Icon(Icons.logout, color: Colors.red),
                          label: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
