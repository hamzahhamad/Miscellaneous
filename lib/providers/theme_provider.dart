import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../theme/app_theme.dart';

// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  final Box _settingsBox = Hive.box('settings');

  void _loadThemeMode() {
    final themeIndex = _settingsBox.get('theme_mode', defaultValue: 0);
    state = ThemeMode.values[themeIndex];
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = themeMode;
    await _settingsBox.put('theme_mode', themeMode.index);
  }

  void toggleTheme() {
    switch (state) {
      case ThemeMode.system:
        setThemeMode(ThemeMode.light);
        break;
      case ThemeMode.light:
        setThemeMode(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        setThemeMode(ThemeMode.system);
        break;
    }
  }
}

// App theme provider
final appThemeProvider = Provider<AppTheme>((ref) {
  return AppTheme();
});

// Current brightness provider
final currentBrightnessProvider = Provider<Brightness>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  
  switch (themeMode) {
    case ThemeMode.light:
      return Brightness.light;
    case ThemeMode.dark:
      return Brightness.dark;
    case ThemeMode.system:
      return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }
});

// Dynamic theme provider based on weather
final dynamicThemeProvider = Provider<ThemeData>((ref) {
  final appTheme = ref.watch(appThemeProvider);
  final brightness = ref.watch(currentBrightnessProvider);
  
  // TODO: Implement dynamic theme based on current weather conditions
  // For now, return default theme
  return brightness == Brightness.light ? appTheme.lightTheme : appTheme.darkTheme;
});

// Weather-based color provider
final weatherColorProvider = Provider<Color>((ref) {
  // TODO: Implement weather-based colors
  // For now, return default blue
  return const Color(0xFF74B9FF);
});

// Animation settings provider
final animationSettingsProvider = StateNotifierProvider<AnimationSettingsNotifier, AnimationSettings>((ref) {
  return AnimationSettingsNotifier();
});

class AnimationSettings {
  final bool enableAnimations;
  final bool enableParallax;
  final bool enableGradients;
  final double animationSpeed;

  const AnimationSettings({
    this.enableAnimations = true,
    this.enableParallax = true,
    this.enableGradients = true,
    this.animationSpeed = 1.0,
  });

  AnimationSettings copyWith({
    bool? enableAnimations,
    bool? enableParallax,
    bool? enableGradients,
    double? animationSpeed,
  }) {
    return AnimationSettings(
      enableAnimations: enableAnimations ?? this.enableAnimations,
      enableParallax: enableParallax ?? this.enableParallax,
      enableGradients: enableGradients ?? this.enableGradients,
      animationSpeed: animationSpeed ?? this.animationSpeed,
    );
  }
}

class AnimationSettingsNotifier extends StateNotifier<AnimationSettings> {
  AnimationSettingsNotifier() : super(const AnimationSettings()) {
    _loadAnimationSettings();
  }

  final Box _settingsBox = Hive.box('settings');

  void _loadAnimationSettings() {
    final enableAnimations = _settingsBox.get('enable_animations', defaultValue: true);
    final enableParallax = _settingsBox.get('enable_parallax', defaultValue: true);
    final enableGradients = _settingsBox.get('enable_gradients', defaultValue: true);
    final animationSpeed = _settingsBox.get('animation_speed', defaultValue: 1.0);

    state = AnimationSettings(
      enableAnimations: enableAnimations,
      enableParallax: enableParallax,
      enableGradients: enableGradients,
      animationSpeed: animationSpeed,
    );
  }

  Future<void> setEnableAnimations(bool enable) async {
    state = state.copyWith(enableAnimations: enable);
    await _settingsBox.put('enable_animations', enable);
  }

  Future<void> setEnableParallax(bool enable) async {
    state = state.copyWith(enableParallax: enable);
    await _settingsBox.put('enable_parallax', enable);
  }

  Future<void> setEnableGradients(bool enable) async {
    state = state.copyWith(enableGradients: enable);
    await _settingsBox.put('enable_gradients', enable);
  }

  Future<void> setAnimationSpeed(double speed) async {
    state = state.copyWith(animationSpeed: speed);
    await _settingsBox.put('animation_speed', speed);
  }
}