/// Input validators for Doglio Marketplace
///
/// This file contains all validation logic for forms and user inputs
/// throughout the application.
library;

class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one digit
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  // Confirm password validation
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Required field validation
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  // Name validation
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters long';
    }

    if (value.trim().length > 50) {
      return 'Name must not exceed 50 characters';
    }

    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    final nameRegex = RegExp(r"^[a-zA-ZÀ-ÿ\s\-']+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return 'Name contains invalid characters';
    }

    return null;
  }

  // Phone number validation
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // Price validation
  static String? price(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value);
    if (price == null) {
      return 'Please enter a valid price';
    }

    if (price < 0) {
      return 'Price must be positive';
    }

    if (price > 999999.99) {
      return 'Price is too high';
    }

    return null;
  }

  // Quantity validation
  static String? quantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity is required';
    }

    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'Please enter a valid quantity';
    }

    if (quantity < 0) {
      return 'Quantity must be positive';
    }

    if (quantity > 99999) {
      return 'Quantity is too high';
    }

    return null;
  }

  // Product description validation
  static String? productDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }

    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters long';
    }

    if (value.trim().length > 1000) {
      return 'Description must not exceed 1000 characters';
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
