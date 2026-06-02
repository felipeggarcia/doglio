/// Input validators for Doglio Marketplace
///
/// This file contains all validation logic for forms and user inputs
/// throughout the application.
library;

import 'package:flutter/widgets.dart';
import 'l10n_helper.dart';

class Validators {
  // Email validation
  static String? email(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.l10n.emailRequired;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return context.l10n.emailInvalid;
    }

    return null;
  }

  // Password validation
  static String? password(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.l10n.passwordRequired;
    }

    if (value.length < 6) {
      return context.l10n.passwordTooShort(6);
    }

    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return context.l10n.passwordMustHaveUppercase;
    }

    // Check for at least one lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return context.l10n.passwordMustHaveLowercase;
    }

    // Check for at least one digit
    if (!value.contains(RegExp(r'[0-9]'))) {
      return context.l10n.passwordMustHaveNumber;
    }

    return null;
  }

  // Confirm password validation
  static String? confirmPassword(
    String? value,
    String? originalPassword,
    BuildContext context,
  ) {
    if (value == null || value.isEmpty) {
      return context.l10n.confirmPasswordRequired;
    }

    if (value != originalPassword) {
      return context.l10n.passwordsDoNotMatch;
    }

    return null;
  }

  // Required field validation
  static String? required(
    String? value,
    BuildContext context, [
    String? fieldName,
  ]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? context.l10n.fieldRequired(fieldName)
          : context.l10n.passwordRequired;
    }
    return null;
  }

  // Name validation
  static String? name(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.nameRequired;
    }

    if (value.trim().length < 2) {
      return context.l10n.nameTooShort(2);
    }

    if (value.trim().length > 50) {
      return context.l10n.nameTooLong(50);
    }

    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    final nameRegex = RegExp(r"^[a-zA-ZÀ-ÿ\s\-']+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return context.l10n.nameInvalidCharacters;
    }

    return null;
  }

  // Phone number validation
  static String? phoneNumber(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.l10n.phoneRequired;
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
      return context.l10n.phoneInvalid;
    }

    return null;
  }

  // Price validation
  static String? price(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.l10n.priceRequired;
    }

    final price = double.tryParse(value);
    if (price == null) {
      return context.l10n.priceInvalid;
    }

    if (price < 0) {
      return context.l10n.priceMustBePositive;
    }

    if (price > 999999.99) {
      return context.l10n.priceTooHigh;
    }

    return null;
  }

  // Quantity validation
  static String? quantity(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.l10n.quantityRequired;
    }

    final quantity = int.tryParse(value);
    if (quantity == null) {
      return context.l10n.quantityInvalid;
    }

    if (quantity < 0) {
      return context.l10n.quantityMustBePositive;
    }

    if (quantity > 99999) {
      return context.l10n.quantityTooHigh;
    }

    return null;
  }

  // Product description validation
  static String? productDescription(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.descriptionRequired;
    }

    if (value.trim().length < 10) {
      return context.l10n.descriptionTooShort(10);
    }

    if (value.trim().length > 1000) {
      return context.l10n.descriptionTooLong(1000);
    }

    return null;
  }

  // Credit card number validation
  static String? creditCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 13 || digitsOnly.length > 19) {
      return 'Please enter a valid card number';
    }

    // Luhn algorithm validation
    if (!_isValidLuhn(digitsOnly)) {
      return 'Please enter a valid card number';
    }

    return null;
  }

  // CVV validation
  static String? cvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }

    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 3 || digitsOnly.length > 4) {
      return 'CVV must be 3 or 4 digits';
    }

    return null;
  }

  // Expiry date validation (MM/YY format)
  static String? expiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }

    final regex = RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$');
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid expiry date (MM/YY)';
    }

    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse('20${parts[1]}');
    final now = DateTime.now();
    final expiryDate = DateTime(year, month + 1, 0); // Last day of expiry month

    if (expiryDate.isBefore(now)) {
      return 'Card has expired';
    }

    return null;
  }

  // Helper method for Luhn algorithm (credit card validation)
  static bool _isValidLuhn(String cardNumber) {
    int sum = 0;
    bool isEven = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (isEven) {
        digit *= 2;
        if (digit > 9) {
          digit = digit ~/ 10 + digit % 10;
        }
      }

      sum += digit;
      isEven = !isEven;
    }

    return sum % 10 == 0;
  }
}
