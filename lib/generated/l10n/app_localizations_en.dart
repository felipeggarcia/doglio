// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Doglio';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get retry => 'Retry';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get noResults => 'No results found';

  @override
  String get tryAgain => 'Try again';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signOut => 'Sign Out';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email address and we\'ll send you a link to reset your password';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get sendingResetEmail => 'Sending reset email...';

  @override
  String get resendEmail => 'Resend Email';

  @override
  String get resendingEmail => 'Resending email...';

  @override
  String get passwordResetEmailSent =>
      'Password reset email sent successfully!';

  @override
  String get emailResent => 'Password reset email sent again!';

  @override
  String get emailResendFailed => 'Failed to resend email. Please try again';

  @override
  String get rememberPassword => 'Remember your password?';

  @override
  String get emailSent => 'Email Sent!';

  @override
  String get passwordResetLinkSent => 'We\'ve sent a password reset link to:';

  @override
  String get checkEmailInstructions =>
      'Check your email and click the link to reset your password. The link will expire in 1 hour';

  @override
  String get backToSignIn => 'Back to Sign In';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get loginSuccess => 'Login successful!';

  @override
  String get loginSubtitle => 'Sign in to access your account';

  @override
  String get registerSubtitle => 'Create your account to start shopping';

  @override
  String get joinDoglio => 'Join Doglio';

  @override
  String get createAccount => 'Create Account';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Enter your email address';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Confirm your password';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameHint => 'Enter your full name';

  @override
  String get createPassword => 'Create a strong password';

  @override
  String get createPasswordHint => 'Create a strong password';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get orSignInWith => 'Or sign in with';

  @override
  String get orRegisterWith => 'Or register with';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String fieldRequired(String field) {
    return '$field is required';
  }

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String passwordTooShort(int minLength) {
    return 'Password must be at least $minLength characters';
  }

  @override
  String get passwordMustHaveUppercase =>
      'Password must contain at least one uppercase letter';

  @override
  String get passwordMustHaveLowercase =>
      'Password must contain at least one lowercase letter';

  @override
  String get passwordMustHaveNumber =>
      'Password must contain at least one number';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get nameInvalidCharacters => 'Name contains invalid characters';

  @override
  String nameTooShort(Object minLength) {
    return 'Name must be at least $minLength characters long';
  }

  @override
  String nameTooLong(Object maxLength) {
    return 'Name must not exceed $maxLength characters';
  }

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneInvalid => 'Please enter a valid phone number';

  @override
  String get priceRequired => 'Price is required';

  @override
  String get priceInvalid => 'Please enter a valid price';

  @override
  String get priceMustBePositive => 'Price must be positive';

  @override
  String get pricePositive => 'Price must be positive';

  @override
  String get priceTooHigh => 'Price is too high';

  @override
  String get quantityRequired => 'Quantity is required';

  @override
  String get quantityInvalid => 'Please enter a valid quantity';

  @override
  String get quantityMustBePositive => 'Quantity must be positive';

  @override
  String get quantityPositive => 'Quantity must be positive';

  @override
  String get quantityTooHigh => 'Quantity is too high';

  @override
  String get descriptionRequired => 'Description is required';

  @override
  String descriptionTooShort(int minLength) {
    return 'Description must be at least $minLength characters';
  }

  @override
  String descriptionTooLong(int maxLength) {
    return 'Description must be at most $maxLength characters';
  }

  @override
  String get cardNumberRequired => 'Card number is required';

  @override
  String get cardNumberInvalid => 'Please enter a valid card number';

  @override
  String get cvvRequired => 'CVV is required';

  @override
  String get cvvInvalid => 'Please enter a valid CVV';

  @override
  String get expiryDateRequired => 'Expiry date is required';

  @override
  String get cardExpired => 'Card has expired';

  @override
  String get pleaseAcceptTerms => 'Please accept the terms and conditions';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get userNotFound => 'User not found';

  @override
  String get emailAlreadyInUse => 'Email already in use';

  @override
  String get weakPassword => 'Password is too weak';

  @override
  String get networkError => 'Network error. Please check your connection';

  @override
  String get accountInactive => 'Account is inactive';

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String get validationFailed => 'Validation failed';

  @override
  String get passwordResetFailed => 'Password reset failed';

  @override
  String get updateFailed => 'Update failed';

  @override
  String get deleteFailed => 'Delete failed';

  @override
  String get store => 'Store';

  @override
  String get products => 'Products';

  @override
  String get categories => 'Categories';

  @override
  String get featured => 'Featured';

  @override
  String get featuredProducts => 'Featured Products';

  @override
  String get viewAll => 'View all';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get cart => 'Cart';

  @override
  String get checkout => 'Checkout';

  @override
  String get myOrders => 'My Orders';

  @override
  String get searchProducts => 'Search products...';

  @override
  String get noCategoriesAvailable => 'No categories available';

  @override
  String get noProductsAvailable => 'No products available';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get outOfStock => 'Out of Stock';

  @override
  String get inStock => 'In Stock';

  @override
  String get unavailable => 'Unavailable';

  @override
  String stockCount(int count) {
    return '$count in stock';
  }

  @override
  String get productDetails => 'Product Details';

  @override
  String get description => 'Description';

  @override
  String get noDescriptionAvailable => 'No description available';

  @override
  String get price => 'Price';

  @override
  String get quantity => 'Quantity';

  @override
  String get total => 'Total';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get about => 'About';

  @override
  String get help => 'Help';

  @override
  String get contact => 'Contact';

  @override
  String get currency => 'R\$';

  @override
  String get currencySymbol => 'R\$';

  @override
  String get monthJan => 'Jan';

  @override
  String get monthFeb => 'Feb';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Apr';

  @override
  String get monthMay => 'May';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Aug';

  @override
  String get monthSep => 'Sep';

  @override
  String get monthOct => 'Oct';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dec';

  @override
  String get myAccount => 'My Account';

  @override
  String drawerWelcome(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get myAddresses => 'My Addresses';

  @override
  String get favorites => 'Favorites';

  @override
  String get noFavorites => 'You have no favorites yet';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get favoriteAdded => 'Added to favorites';

  @override
  String get favoriteRemoved => 'Removed from favorites';

  @override
  String get orders => 'Orders';

  @override
  String get noOrders => 'You haven\'t placed any orders yet';

  @override
  String get orderDetails => 'Order Details';

  @override
  String get orderDate => 'Date';

  @override
  String get orderTotal => 'Order total';

  @override
  String get orderHistory => 'History';

  @override
  String get orderItems => 'Items';

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusProcessing => 'Processing';

  @override
  String get orderStatusShipped => 'Shipped';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get paymentInfo => 'Payment';

  @override
  String get deliveryInfo => 'Delivery';

  @override
  String get deliveryPickup => 'Store pickup';

  @override
  String get deliveryHome => 'Home delivery';

  @override
  String get addresses => 'Addresses';

  @override
  String get noAddresses => 'No addresses saved yet';

  @override
  String get addAddress => 'Add address';

  @override
  String get editAddress => 'Edit address';

  @override
  String get deleteAddress => 'Delete address';

  @override
  String get primaryAddress => 'Primary';

  @override
  String get setPrimaryAddress => 'Set as primary';

  @override
  String get addressLabel => 'Label (e.g., Home, Work)';

  @override
  String get addressStreet => 'Street / Avenue';

  @override
  String get addressNumber => 'Number';

  @override
  String get addressComplement => 'Complement (optional)';

  @override
  String get addressCity => 'City';

  @override
  String get addressState => 'State';

  @override
  String get addressZip => 'ZIP code';

  @override
  String get addressSaved => 'Address saved successfully';

  @override
  String get addressDeleted => 'Address deleted';

  @override
  String get addressDistrict => 'District';

  @override
  String get newAddressTitle => 'New Address';

  @override
  String get editAddressTitle => 'Edit Address';

  @override
  String get confirmDeleteAddressMessage =>
      'Are you sure you want to delete this address?';

  @override
  String zipCodeLabel(String zip) {
    return 'ZIP: $zip';
  }

  @override
  String get requiredField => 'Required';

  @override
  String get shippingAddress => 'Shipping address';

  @override
  String get orderStatusTitle => 'Status';

  @override
  String trackingCodeLabel(String code) {
    return 'Tracking code: $code';
  }

  @override
  String orderNumber(String id) {
    return 'Order #$id';
  }

  @override
  String get favoriteUpdateError =>
      'Failed to update favorites. Please try again.';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartEmptySubtitle => 'Add products to start shopping';

  @override
  String get clearCart => 'Clear cart';

  @override
  String get clearCartConfirm => 'Remove all items from your cart?';

  @override
  String get cartCleared => 'Cart cleared';

  @override
  String get cartItemAdded => 'Product added to cart';

  @override
  String get continueShopping => 'Continue shopping';

  @override
  String get stockWarning => 'Some items have stock issues';

  @override
  String get priceChanged => 'Some item prices have changed';
}
