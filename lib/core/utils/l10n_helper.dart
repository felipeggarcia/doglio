/// I18n Helper Extension
///
/// Provides easy access to localized strings throughout the app
/// Usage: context.l10n.signIn
library;

import 'package:flutter/widgets.dart';
import '../../generated/l10n/app_localizations.dart';

/// Extension on BuildContext to access localized strings easily
extension LocalizationExtension on BuildContext {
  /// Get the localized strings for the current locale
  ///
  /// Example:
  /// ```dart
  /// Text(context.l10n.signIn) // Returns "Entrar" in pt_BR
  /// ```
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Get the current locale
  Locale get locale => Localizations.localeOf(this);

  /// Check if current locale is Portuguese
  bool get isPortuguese => locale.languageCode == 'pt';

  /// Check if current locale is English
  bool get isEnglish => locale.languageCode == 'en';
}

/// Example usage in a widget:
///
/// ```dart
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Column(
///       children: [
///         Text(context.l10n.appName),
///         ElevatedButton(
///           onPressed: () {},
///           child: Text(context.l10n.signIn),
///         ),
///         Text(context.l10n.passwordTooShort(6)), // With parameter
///       ],
///     );
///   }
/// }
/// ```
