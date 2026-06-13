library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides the app-wide [SharedPreferences] instance.
///
/// Must be overridden before use:
/// ```dart
/// final prefs = await SharedPreferences.getInstance();
/// ProviderScope(
///   overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
///   child: const DoglioApp(),
/// )
/// ```
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main.dart',
  ),
);
