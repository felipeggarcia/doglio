/// Text and number formatters for Doglio Marketplace
///
/// This file provides utility functions for formatting various types of data
/// displayed throughout the application.
library;

class AppFormatters {
  /// Format currency based on locale
  static String formatCurrency(double amount, {String locale = 'en'}) {
    if (locale == 'pt') {
      return 'R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',')}';
    }
    return '\$${amount.toStringAsFixed(2)}';
  }

  /// Format number with thousands separator
  static String formatNumber(int number) {
    final str = number.toString();
    final result = StringBuffer();

    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        result.write(',');
      }
      result.write(str[i]);
    }

    return result.toString();
  }

  /// Format percentage
  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  /// Format date based on locale
  static String formatDate(DateTime date, {String locale = 'en'}) {
    if (locale == 'pt') {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Format time
  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Format date and time based on locale
  static String formatDateTime(DateTime dateTime, {String locale = 'en'}) {
    return '${formatDate(dateTime, locale: locale)} ${formatTime(dateTime)}';
  }

  /// Format relative time (e.g., "2 hours ago", "3 days ago")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Format phone number (XXX) XXX-XXXX
  static String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length == 10) {
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
    } else if (digitsOnly.length == 11) {
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
    }

    return phoneNumber; // Return original if can't format
  }

  /// Format credit card number (XXXX XXXX XXXX XXXX)
  static String formatCreditCardNumber(String cardNumber) {
    // Remove all non-digit characters
    final digitsOnly = cardNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length <= 4) {
      return digitsOnly;
    } else if (digitsOnly.length <= 8) {
      return '${digitsOnly.substring(0, 4)} ${digitsOnly.substring(4)}';
    } else if (digitsOnly.length <= 12) {
      return '${digitsOnly.substring(0, 4)} ${digitsOnly.substring(4, 8)} ${digitsOnly.substring(8)}';
    } else {
      return '${digitsOnly.substring(0, 4)} ${digitsOnly.substring(4, 8)} ${digitsOnly.substring(8, 12)} ${digitsOnly.substring(12)}';
    }
  }

  /// Format file size (bytes to KB, MB, GB)
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Format product rating (e.g., "4.5" from 4.523)
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  /// Format discount percentage
  static String formatDiscount(double originalPrice, double discountedPrice) {
    final discount = ((originalPrice - discountedPrice) / originalPrice) * 100;
    return '${discount.round()}% OFF';
  }

  /// Capitalize first letter of each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;

    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Format order status
  static String formatOrderStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      case 'refunded':
        return 'Refunded';
      default:
        return capitalizeWords(status);
    }
  }
}
