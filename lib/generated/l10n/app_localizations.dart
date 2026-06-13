import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('pt', 'BR'),
    Locale('en'),
    Locale('pt'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Doglio'**
  String get appName;

  /// No description provided for @adminPanel.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// No description provided for @adminPanelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Management tools'**
  String get adminPanelSubtitle;

  /// Admin dashboard greeting
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String adminGreeting(String name);

  /// No description provided for @adminUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get adminUsers;

  /// No description provided for @adminProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get adminProducts;

  /// No description provided for @adminOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get adminOrders;

  /// No description provided for @adminCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get adminCategories;

  /// No description provided for @adminPromotions.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get adminPromotions;

  /// No description provided for @adminUnderConstruction.
  ///
  /// In en, this message translates to:
  /// **'Under construction'**
  String get adminUnderConstruction;

  /// No description provided for @adminUnderConstructionDesc.
  ///
  /// In en, this message translates to:
  /// **'This section will be available soon.'**
  String get adminUnderConstructionDesc;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get logoutConfirmation;

  /// No description provided for @adminUsersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or email'**
  String get adminUsersSearchHint;

  /// No description provided for @adminFilterRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get adminFilterRole;

  /// No description provided for @adminFilterStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get adminFilterStatus;

  /// No description provided for @adminFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get adminFilterAll;

  /// No description provided for @adminRoleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminRoleAdmin;

  /// No description provided for @adminRoleCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get adminRoleCustomer;

  /// No description provided for @adminStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminStatusActive;

  /// No description provided for @adminStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get adminStatusInactive;

  /// No description provided for @adminUsersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get adminUsersEmpty;

  /// No description provided for @adminLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get adminLoadMore;

  /// No description provided for @adminUserNew.
  ///
  /// In en, this message translates to:
  /// **'New user'**
  String get adminUserNew;

  /// No description provided for @adminUserCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New user'**
  String get adminUserCreateTitle;

  /// No description provided for @adminUserEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit user'**
  String get adminUserEditTitle;

  /// No description provided for @adminFieldRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get adminFieldRole;

  /// No description provided for @adminFieldActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminFieldActive;

  /// No description provided for @adminFieldCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get adminFieldCity;

  /// No description provided for @adminFieldState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get adminFieldState;

  /// No description provided for @adminFieldCpfCnpj.
  ///
  /// In en, this message translates to:
  /// **'Tax ID (CPF/CNPJ)'**
  String get adminFieldCpfCnpj;

  /// No description provided for @adminFieldBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth date'**
  String get adminFieldBirthDate;

  /// No description provided for @adminUserCreated.
  ///
  /// In en, this message translates to:
  /// **'User created.'**
  String get adminUserCreated;

  /// No description provided for @adminUserSaved.
  ///
  /// In en, this message translates to:
  /// **'User updated.'**
  String get adminUserSaved;

  /// No description provided for @adminUserDeleted.
  ///
  /// In en, this message translates to:
  /// **'User removed.'**
  String get adminUserDeleted;

  /// No description provided for @adminUserDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this user?'**
  String get adminUserDeleteConfirm;

  /// No description provided for @adminCategoryNew.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get adminCategoryNew;

  /// No description provided for @adminCategoryCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get adminCategoryCreateTitle;

  /// No description provided for @adminCategoryEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get adminCategoryEditTitle;

  /// No description provided for @adminCategoriesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get adminCategoriesSearchHint;

  /// No description provided for @adminCategoriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get adminCategoriesEmpty;

  /// No description provided for @adminCategoryNoneSelected.
  ///
  /// In en, this message translates to:
  /// **'None selected'**
  String get adminCategoryNoneSelected;

  /// No description provided for @adminCategoryCreated.
  ///
  /// In en, this message translates to:
  /// **'Category created.'**
  String get adminCategoryCreated;

  /// No description provided for @adminCategorySaved.
  ///
  /// In en, this message translates to:
  /// **'Category updated.'**
  String get adminCategorySaved;

  /// No description provided for @adminCategoryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Category removed.'**
  String get adminCategoryDeleted;

  /// No description provided for @adminCategoryDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this category?'**
  String get adminCategoryDeleteConfirm;

  /// No description provided for @adminFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get adminFieldName;

  /// No description provided for @adminFieldHighlighted.
  ///
  /// In en, this message translates to:
  /// **'Highlighted'**
  String get adminFieldHighlighted;

  /// No description provided for @adminCategoryProductsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} products'**
  String adminCategoryProductsCount(int count);

  /// No description provided for @adminProductNew.
  ///
  /// In en, this message translates to:
  /// **'New product'**
  String get adminProductNew;

  /// No description provided for @adminProductCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New product'**
  String get adminProductCreateTitle;

  /// No description provided for @adminProductEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get adminProductEditTitle;

  /// No description provided for @adminProductsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get adminProductsSearchHint;

  /// No description provided for @adminProductsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get adminProductsEmpty;

  /// No description provided for @adminProductStockCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Out of stock} =1{1 in stock} other{{count} in stock}}'**
  String adminProductStockCount(int count);

  /// No description provided for @adminProductFilterHighlighted.
  ///
  /// In en, this message translates to:
  /// **'Highlighted'**
  String get adminProductFilterHighlighted;

  /// No description provided for @adminProductFilterOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get adminProductFilterOutOfStock;

  /// No description provided for @adminProductFiltersButton.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get adminProductFiltersButton;

  /// No description provided for @adminProductFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get adminProductFiltersTitle;

  /// No description provided for @adminProductFilterCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get adminProductFilterCategories;

  /// No description provided for @adminProductFilterPriceMin.
  ///
  /// In en, this message translates to:
  /// **'Min price'**
  String get adminProductFilterPriceMin;

  /// No description provided for @adminProductFilterPriceMax.
  ///
  /// In en, this message translates to:
  /// **'Max price'**
  String get adminProductFilterPriceMax;

  /// No description provided for @adminProductFilterDateFrom.
  ///
  /// In en, this message translates to:
  /// **'From date'**
  String get adminProductFilterDateFrom;

  /// No description provided for @adminProductFilterDateTo.
  ///
  /// In en, this message translates to:
  /// **'To date'**
  String get adminProductFilterDateTo;

  /// No description provided for @adminProductSortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get adminProductSortBy;

  /// No description provided for @adminProductSortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get adminProductSortName;

  /// No description provided for @adminProductSortPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get adminProductSortPrice;

  /// No description provided for @adminProductSortStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get adminProductSortStock;

  /// No description provided for @adminProductSortCreated.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get adminProductSortCreated;

  /// No description provided for @adminProductSortUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated at'**
  String get adminProductSortUpdated;

  /// No description provided for @adminProductSortAsc.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get adminProductSortAsc;

  /// No description provided for @adminProductSortDesc.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get adminProductSortDesc;

  /// No description provided for @adminProductFiltersApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get adminProductFiltersApply;

  /// No description provided for @adminProductFiltersClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get adminProductFiltersClear;

  /// No description provided for @adminFieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get adminFieldDescription;

  /// No description provided for @adminFieldPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get adminFieldPrice;

  /// No description provided for @adminFieldCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get adminFieldCategories;

  /// No description provided for @adminProductImages.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get adminProductImages;

  /// No description provided for @adminProductAddImages.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get adminProductAddImages;

  /// No description provided for @adminProductImageLimit.
  ///
  /// In en, this message translates to:
  /// **'Maximum of {max} images per product.'**
  String adminProductImageLimit(int max);

  /// No description provided for @adminProductCreated.
  ///
  /// In en, this message translates to:
  /// **'Product created.'**
  String get adminProductCreated;

  /// No description provided for @adminProductSaved.
  ///
  /// In en, this message translates to:
  /// **'Product updated.'**
  String get adminProductSaved;

  /// No description provided for @adminProductDeleted.
  ///
  /// In en, this message translates to:
  /// **'Product removed.'**
  String get adminProductDeleted;

  /// No description provided for @adminProductDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this product?'**
  String get adminProductDeleteConfirm;

  /// No description provided for @adminProductStockSection.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get adminProductStockSection;

  /// No description provided for @adminProductStockManage.
  ///
  /// In en, this message translates to:
  /// **'Manage stock'**
  String get adminProductStockManage;

  /// No description provided for @adminProductStockHistory.
  ///
  /// In en, this message translates to:
  /// **'Stock history'**
  String get adminProductStockHistory;

  /// No description provided for @adminProductStockCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current stock'**
  String get adminProductStockCurrent;

  /// No description provided for @adminProductStockEmpty.
  ///
  /// In en, this message translates to:
  /// **'No stock movements'**
  String get adminProductStockEmpty;

  /// No description provided for @adminProductStockMove.
  ///
  /// In en, this message translates to:
  /// **'Adjust stock'**
  String get adminProductStockMove;

  /// No description provided for @adminProductStockModeDelta.
  ///
  /// In en, this message translates to:
  /// **'In/Out'**
  String get adminProductStockModeDelta;

  /// No description provided for @adminProductStockModeAbsolute.
  ///
  /// In en, this message translates to:
  /// **'Set total'**
  String get adminProductStockModeAbsolute;

  /// No description provided for @adminProductStockTypeIn.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get adminProductStockTypeIn;

  /// No description provided for @adminProductStockTypeOut.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get adminProductStockTypeOut;

  /// No description provided for @adminProductStockQuantityField.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get adminProductStockQuantityField;

  /// No description provided for @adminProductStockQuantityInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid quantity'**
  String get adminProductStockQuantityInvalid;

  /// No description provided for @adminProductStockReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get adminProductStockReason;

  /// No description provided for @adminProductReasonPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get adminProductReasonPurchase;

  /// No description provided for @adminProductReasonReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get adminProductReasonReturn;

  /// No description provided for @adminProductReasonManual.
  ///
  /// In en, this message translates to:
  /// **'Manual adjustment'**
  String get adminProductReasonManual;

  /// No description provided for @adminProductReasonLoss.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get adminProductReasonLoss;

  /// No description provided for @adminProductStockNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get adminProductStockNotes;

  /// No description provided for @adminProductStockBeforeAfter.
  ///
  /// In en, this message translates to:
  /// **'{before} → {after}'**
  String adminProductStockBeforeAfter(int before, int after);

  /// No description provided for @adminProductStockSaved.
  ///
  /// In en, this message translates to:
  /// **'Stock updated.'**
  String get adminProductStockSaved;

  /// No description provided for @adminOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get adminOrdersTitle;

  /// No description provided for @adminOrdersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get adminOrdersEmpty;

  /// No description provided for @adminOrdersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by order number'**
  String get adminOrdersSearchHint;

  /// No description provided for @adminOrdersFiltersButton.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get adminOrdersFiltersButton;

  /// No description provided for @adminOrdersFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Order filters'**
  String get adminOrdersFiltersTitle;

  /// No description provided for @adminOrdersFiltersDeliveryType.
  ///
  /// In en, this message translates to:
  /// **'Delivery type'**
  String get adminOrdersFiltersDeliveryType;

  /// No description provided for @adminOrdersFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get adminOrdersFilterAll;

  /// No description provided for @adminOrdersFilterDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get adminOrdersFilterDelivery;

  /// No description provided for @adminOrdersFilterPickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get adminOrdersFilterPickup;

  /// No description provided for @adminOrdersFilterPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get adminOrdersFilterPeriod;

  /// No description provided for @adminOrderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get adminOrderStatusPending;

  /// No description provided for @adminOrderStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get adminOrderStatusConfirmed;

  /// No description provided for @adminOrderStatusPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get adminOrderStatusPreparing;

  /// No description provided for @adminOrderStatusOutForDelivery.
  ///
  /// In en, this message translates to:
  /// **'Out for delivery'**
  String get adminOrderStatusOutForDelivery;

  /// No description provided for @adminOrderStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get adminOrderStatusDelivered;

  /// No description provided for @adminOrderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get adminOrderStatusCancelled;

  /// No description provided for @adminOrderDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Order #{number}'**
  String adminOrderDetailTitle(String number);

  /// No description provided for @adminOrderCustomerSection.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get adminOrderCustomerSection;

  /// No description provided for @adminOrderItemsSection.
  ///
  /// In en, this message translates to:
  /// **'Order items'**
  String get adminOrderItemsSection;

  /// No description provided for @adminOrderPaymentSection.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get adminOrderPaymentSection;

  /// No description provided for @adminOrderHistorySection.
  ///
  /// In en, this message translates to:
  /// **'Status history'**
  String get adminOrderHistorySection;

  /// No description provided for @adminOrderDeliverySection.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get adminOrderDeliverySection;

  /// No description provided for @adminOrderSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get adminOrderSubtotal;

  /// No description provided for @adminOrderDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get adminOrderDiscount;

  /// No description provided for @adminOrderTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get adminOrderTotal;

  /// No description provided for @adminOrderPickupLabel.
  ///
  /// In en, this message translates to:
  /// **'In-store pickup'**
  String get adminOrderPickupLabel;

  /// No description provided for @adminOrderDeliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get adminOrderDeliveryLabel;

  /// No description provided for @adminOrderPaymentPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get adminOrderPaymentPending;

  /// No description provided for @adminOrderPaymentPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get adminOrderPaymentPaid;

  /// No description provided for @adminOrderPaymentApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get adminOrderPaymentApproved;

  /// No description provided for @adminOrderPixCode.
  ///
  /// In en, this message translates to:
  /// **'PIX Code'**
  String get adminOrderPixCode;

  /// No description provided for @adminOrderPixExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires {date}'**
  String adminOrderPixExpires(String date);

  /// No description provided for @adminOrderUpdateStatus.
  ///
  /// In en, this message translates to:
  /// **'Update status'**
  String get adminOrderUpdateStatus;

  /// No description provided for @adminOrderStatusNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get adminOrderStatusNotes;

  /// No description provided for @adminOrderStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Status updated.'**
  String get adminOrderStatusUpdated;

  /// No description provided for @adminOrderStatusUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Error updating status.'**
  String get adminOrderStatusUpdateError;

  /// No description provided for @adminOrderConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm order'**
  String get adminOrderConfirm;

  /// No description provided for @adminOrderStartPreparing.
  ///
  /// In en, this message translates to:
  /// **'Start preparing'**
  String get adminOrderStartPreparing;

  /// No description provided for @adminOrderSendOut.
  ///
  /// In en, this message translates to:
  /// **'Send out for delivery'**
  String get adminOrderSendOut;

  /// No description provided for @adminOrderMarkDelivered.
  ///
  /// In en, this message translates to:
  /// **'Mark as delivered'**
  String get adminOrderMarkDelivered;

  /// No description provided for @adminOrderCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get adminOrderCancel;

  /// No description provided for @adminOrderAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get adminOrderAddItem;

  /// No description provided for @adminOrderEditItem.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get adminOrderEditItem;

  /// No description provided for @adminOrderRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Remove item'**
  String get adminOrderRemoveItem;

  /// No description provided for @adminOrderRemoveItemConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this item from the order?'**
  String get adminOrderRemoveItemConfirm;

  /// No description provided for @adminOrderItemSaved.
  ///
  /// In en, this message translates to:
  /// **'Item updated.'**
  String get adminOrderItemSaved;

  /// No description provided for @adminOrderItemAdded.
  ///
  /// In en, this message translates to:
  /// **'Product added.'**
  String get adminOrderItemAdded;

  /// No description provided for @adminOrderItemRemoved.
  ///
  /// In en, this message translates to:
  /// **'Item removed.'**
  String get adminOrderItemRemoved;

  /// No description provided for @adminOrderSearchProduct.
  ///
  /// In en, this message translates to:
  /// **'Search product...'**
  String get adminOrderSearchProduct;

  /// No description provided for @adminPromotionNew.
  ///
  /// In en, this message translates to:
  /// **'New promotion'**
  String get adminPromotionNew;

  /// No description provided for @adminPromotionCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New promotion'**
  String get adminPromotionCreateTitle;

  /// No description provided for @adminPromotionEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit promotion'**
  String get adminPromotionEditTitle;

  /// No description provided for @adminPromotionsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search promotion'**
  String get adminPromotionsSearchHint;

  /// No description provided for @adminPromotionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No promotions found'**
  String get adminPromotionsEmpty;

  /// No description provided for @adminPromotionTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount type'**
  String get adminPromotionTypeLabel;

  /// No description provided for @adminPromotionTypePercentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage (%)'**
  String get adminPromotionTypePercentage;

  /// No description provided for @adminPromotionTypeFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed amount (R\$)'**
  String get adminPromotionTypeFixed;

  /// No description provided for @adminPromotionDiscountValue.
  ///
  /// In en, this message translates to:
  /// **'Discount value'**
  String get adminPromotionDiscountValue;

  /// No description provided for @adminPromotionStartsAt.
  ///
  /// In en, this message translates to:
  /// **'Starts at'**
  String get adminPromotionStartsAt;

  /// No description provided for @adminPromotionEndsAt.
  ///
  /// In en, this message translates to:
  /// **'Ends at (optional)'**
  String get adminPromotionEndsAt;

  /// No description provided for @adminPromotionMinQuantity.
  ///
  /// In en, this message translates to:
  /// **'Min. quantity'**
  String get adminPromotionMinQuantity;

  /// No description provided for @adminPromotionLinkedProducts.
  ///
  /// In en, this message translates to:
  /// **'Linked products'**
  String get adminPromotionLinkedProducts;

  /// No description provided for @adminPromotionAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get adminPromotionAddProduct;

  /// No description provided for @adminPromotionUseLimit.
  ///
  /// In en, this message translates to:
  /// **'Use limit'**
  String get adminPromotionUseLimit;

  /// No description provided for @adminPromotionUsesCount.
  ///
  /// In en, this message translates to:
  /// **'Uses: {count}'**
  String adminPromotionUsesCount(int count);

  /// No description provided for @adminPromotionCreated.
  ///
  /// In en, this message translates to:
  /// **'Promotion created.'**
  String get adminPromotionCreated;

  /// No description provided for @adminPromotionSaved.
  ///
  /// In en, this message translates to:
  /// **'Promotion saved.'**
  String get adminPromotionSaved;

  /// No description provided for @adminPromotionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Promotion deleted.'**
  String get adminPromotionDeleted;

  /// No description provided for @adminPromotionDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this promotion?'**
  String get adminPromotionDeleteConfirm;

  /// No description provided for @adminPromotionFilterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminPromotionFilterActive;

  /// No description provided for @adminPromotionFilterExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get adminPromotionFilterExpired;

  /// No description provided for @adminProductTabData.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get adminProductTabData;

  /// No description provided for @adminProductTabPromotions.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get adminProductTabPromotions;

  /// No description provided for @adminProductPromotionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No promotions linked'**
  String get adminProductPromotionsEmpty;

  /// No description provided for @adminPromotionUseLimitHint.
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get adminPromotionUseLimitHint;

  /// No description provided for @adminPromotionLinkButton.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get adminPromotionLinkButton;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password'**
  String get forgotPasswordSubtitle;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @sendingResetEmail.
  ///
  /// In en, this message translates to:
  /// **'Sending reset email...'**
  String get sendingResetEmail;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get resendEmail;

  /// No description provided for @resendingEmail.
  ///
  /// In en, this message translates to:
  /// **'Resending email...'**
  String get resendingEmail;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent successfully!'**
  String get passwordResetEmailSent;

  /// No description provided for @emailResent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent again!'**
  String get emailResent;

  /// No description provided for @emailResendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to resend email. Please try again'**
  String get emailResendFailed;

  /// No description provided for @rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get rememberPassword;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'Email Sent!'**
  String get emailSent;

  /// No description provided for @passwordResetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a password reset link to:'**
  String get passwordResetLinkSent;

  /// No description provided for @checkEmailInstructions.
  ///
  /// In en, this message translates to:
  /// **'Check your email and click the link to reset your password. The link will expire in 1 hour'**
  String get checkEmailInstructions;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccess;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your account'**
  String get loginSubtitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account to start shopping'**
  String get registerSubtitle;

  /// No description provided for @joinDoglio.
  ///
  /// In en, this message translates to:
  /// **'Join Doglio'**
  String get joinDoglio;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordHint;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password'**
  String get createPassword;

  /// No description provided for @createPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password'**
  String get createPasswordHint;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingIn;

  /// No description provided for @orSignInWith.
  ///
  /// In en, this message translates to:
  /// **'Or sign in with'**
  String get orSignInWith;

  /// No description provided for @orRegisterWith.
  ///
  /// In en, this message translates to:
  /// **'Or register with'**
  String get orRegisterWith;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String fieldRequired(String field);

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {minLength} characters'**
  String passwordTooShort(int minLength);

  /// No description provided for @passwordMustHaveUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get passwordMustHaveUppercase;

  /// No description provided for @passwordMustHaveLowercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get passwordMustHaveLowercase;

  /// No description provided for @passwordMustHaveNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get passwordMustHaveNumber;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @nameInvalidCharacters.
  ///
  /// In en, this message translates to:
  /// **'Name contains invalid characters'**
  String get nameInvalidCharacters;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least {minLength} characters long'**
  String nameTooShort(Object minLength);

  /// No description provided for @nameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name must not exceed {maxLength} characters'**
  String nameTooLong(Object maxLength);

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneInvalid;

  /// No description provided for @priceRequired.
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get priceRequired;

  /// No description provided for @priceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid price'**
  String get priceInvalid;

  /// No description provided for @priceMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Price must be positive'**
  String get priceMustBePositive;

  /// No description provided for @pricePositive.
  ///
  /// In en, this message translates to:
  /// **'Price must be positive'**
  String get pricePositive;

  /// No description provided for @priceTooHigh.
  ///
  /// In en, this message translates to:
  /// **'Price is too high'**
  String get priceTooHigh;

  /// No description provided for @quantityRequired.
  ///
  /// In en, this message translates to:
  /// **'Quantity is required'**
  String get quantityRequired;

  /// No description provided for @quantityInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid quantity'**
  String get quantityInvalid;

  /// No description provided for @quantityMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be positive'**
  String get quantityMustBePositive;

  /// No description provided for @quantityPositive.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be positive'**
  String get quantityPositive;

  /// No description provided for @quantityTooHigh.
  ///
  /// In en, this message translates to:
  /// **'Quantity is too high'**
  String get quantityTooHigh;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequired;

  /// No description provided for @descriptionTooShort.
  ///
  /// In en, this message translates to:
  /// **'Description must be at least {minLength} characters'**
  String descriptionTooShort(int minLength);

  /// No description provided for @descriptionTooLong.
  ///
  /// In en, this message translates to:
  /// **'Description must be at most {maxLength} characters'**
  String descriptionTooLong(int maxLength);

  /// No description provided for @cardNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Card number is required'**
  String get cardNumberRequired;

  /// No description provided for @cardNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid card number'**
  String get cardNumberInvalid;

  /// No description provided for @cvvRequired.
  ///
  /// In en, this message translates to:
  /// **'CVV is required'**
  String get cvvRequired;

  /// No description provided for @cvvInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid CVV'**
  String get cvvInvalid;

  /// No description provided for @expiryDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Expiry date is required'**
  String get expiryDateRequired;

  /// No description provided for @cardExpired.
  ///
  /// In en, this message translates to:
  /// **'Card has expired'**
  String get cardExpired;

  /// No description provided for @pleaseAcceptTerms.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms and conditions'**
  String get pleaseAcceptTerms;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidCredentials;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'Email already in use'**
  String get emailAlreadyInUse;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get weakPassword;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection'**
  String get networkError;

  /// No description provided for @accountInactive.
  ///
  /// In en, this message translates to:
  /// **'Account is inactive'**
  String get accountInactive;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @validationFailed.
  ///
  /// In en, this message translates to:
  /// **'Validation failed'**
  String get validationFailed;

  /// No description provided for @passwordResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Password reset failed'**
  String get passwordResetFailed;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get updateFailed;

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get deleteFailed;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// No description provided for @featuredProducts.
  ///
  /// In en, this message translates to:
  /// **'Featured Products'**
  String get featuredProducts;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get searchProducts;

  /// No description provided for @noCategoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get noCategoriesAvailable;

  /// No description provided for @noProductsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No products available'**
  String get noProductsAvailable;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStock;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get inStock;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @stockCount.
  ///
  /// In en, this message translates to:
  /// **'{count} in stock'**
  String stockCount(int count);

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @noDescriptionAvailable.
  ///
  /// In en, this message translates to:
  /// **'No description available'**
  String get noDescriptionAvailable;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'R\$'**
  String get currency;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'R\$'**
  String get currencySymbol;

  /// No description provided for @monthJan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get monthJan;

  /// No description provided for @monthFeb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get monthFeb;

  /// No description provided for @monthMar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get monthMar;

  /// No description provided for @monthApr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get monthApr;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get monthJun;

  /// No description provided for @monthJul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get monthJul;

  /// No description provided for @monthAug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get monthAug;

  /// No description provided for @monthSep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get monthSep;

  /// No description provided for @monthOct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get monthOct;

  /// No description provided for @monthNov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get monthNov;

  /// No description provided for @monthDec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get monthDec;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @drawerWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String drawerWelcome(String name);

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @myAddresses.
  ///
  /// In en, this message translates to:
  /// **'My Addresses'**
  String get myAddresses;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'You have no favorites yet'**
  String get noFavorites;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @favoriteAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get favoriteAdded;

  /// No description provided for @favoriteRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get favoriteRemoved;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @noOrders.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t placed any orders yet'**
  String get noOrders;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @orderDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get orderDate;

  /// No description provided for @orderTotal.
  ///
  /// In en, this message translates to:
  /// **'Order total'**
  String get orderTotal;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get orderHistory;

  /// No description provided for @orderItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get orderItems;

  /// No description provided for @orderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderStatusPending;

  /// No description provided for @orderStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get orderStatusProcessing;

  /// No description provided for @orderStatusShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get orderStatusShipped;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// No description provided for @paymentInfo.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentInfo;

  /// No description provided for @deliveryInfo.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get deliveryInfo;

  /// No description provided for @deliveryPickup.
  ///
  /// In en, this message translates to:
  /// **'Store pickup'**
  String get deliveryPickup;

  /// No description provided for @deliveryHome.
  ///
  /// In en, this message translates to:
  /// **'Receive at home'**
  String get deliveryHome;

  /// No description provided for @addresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addresses;

  /// No description provided for @noAddresses.
  ///
  /// In en, this message translates to:
  /// **'No addresses saved yet'**
  String get noAddresses;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get addAddress;

  /// No description provided for @editAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit address'**
  String get editAddress;

  /// No description provided for @deleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Delete address'**
  String get deleteAddress;

  /// No description provided for @primaryAddress.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primaryAddress;

  /// No description provided for @setPrimaryAddress.
  ///
  /// In en, this message translates to:
  /// **'Set as primary'**
  String get setPrimaryAddress;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Label (e.g., Home, Work)'**
  String get addressLabel;

  /// No description provided for @addressStreet.
  ///
  /// In en, this message translates to:
  /// **'Street / Avenue'**
  String get addressStreet;

  /// No description provided for @addressNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get addressNumber;

  /// No description provided for @addressComplement.
  ///
  /// In en, this message translates to:
  /// **'Complement (optional)'**
  String get addressComplement;

  /// No description provided for @addressCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get addressCity;

  /// No description provided for @addressState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get addressState;

  /// No description provided for @addressZip.
  ///
  /// In en, this message translates to:
  /// **'ZIP code'**
  String get addressZip;

  /// No description provided for @addressSaved.
  ///
  /// In en, this message translates to:
  /// **'Address saved successfully'**
  String get addressSaved;

  /// No description provided for @addressDeleted.
  ///
  /// In en, this message translates to:
  /// **'Address deleted'**
  String get addressDeleted;

  /// No description provided for @addressDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get addressDistrict;

  /// No description provided for @newAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'New Address'**
  String get newAddressTitle;

  /// No description provided for @editAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddressTitle;

  /// No description provided for @confirmDeleteAddressMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address?'**
  String get confirmDeleteAddressMessage;

  /// No description provided for @zipCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'ZIP: {zip}'**
  String zipCodeLabel(String zip);

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @shippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Shipping address'**
  String get shippingAddress;

  /// No description provided for @orderStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get orderStatusTitle;

  /// No description provided for @trackingCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Tracking code: {code}'**
  String trackingCodeLabel(String code);

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #{id}'**
  String orderNumber(String id);

  /// No description provided for @favoriteUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update favorites. Please try again.'**
  String get favoriteUpdateError;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add products to start shopping'**
  String get cartEmptySubtitle;

  /// No description provided for @clearCart.
  ///
  /// In en, this message translates to:
  /// **'Clear cart'**
  String get clearCart;

  /// No description provided for @clearCartConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove all items from your cart?'**
  String get clearCartConfirm;

  /// No description provided for @cartCleared.
  ///
  /// In en, this message translates to:
  /// **'Cart cleared'**
  String get cartCleared;

  /// No description provided for @cartItemAdded.
  ///
  /// In en, this message translates to:
  /// **'Product added to cart'**
  String get cartItemAdded;

  /// No description provided for @continueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue shopping'**
  String get continueShopping;

  /// No description provided for @stockWarning.
  ///
  /// In en, this message translates to:
  /// **'Some items have stock issues'**
  String get stockWarning;

  /// No description provided for @priceChanged.
  ///
  /// In en, this message translates to:
  /// **'Some item prices have changed'**
  String get priceChanged;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get checkoutTitle;

  /// No description provided for @checkoutDeliverySection.
  ///
  /// In en, this message translates to:
  /// **'How to receive?'**
  String get checkoutDeliverySection;

  /// No description provided for @checkoutSelectAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get checkoutSelectAddress;

  /// No description provided for @checkoutAddNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add new address'**
  String get checkoutAddNewAddress;

  /// No description provided for @checkoutPayWithPix.
  ///
  /// In en, this message translates to:
  /// **'Pay with PIX'**
  String get checkoutPayWithPix;

  /// No description provided for @checkoutPayWithMethod.
  ///
  /// In en, this message translates to:
  /// **'Pay with {name}'**
  String checkoutPayWithMethod(String name);

  /// No description provided for @checkoutPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get checkoutPaymentMethod;

  /// No description provided for @checkoutSelectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select how to pay'**
  String get checkoutSelectPaymentMethod;

  /// No description provided for @checkoutNoPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'No payment methods available'**
  String get checkoutNoPaymentMethods;

  /// No description provided for @checkoutShippingFee.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get checkoutShippingFee;

  /// No description provided for @checkoutFreeShipping.
  ///
  /// In en, this message translates to:
  /// **'Free pickup'**
  String get checkoutFreeShipping;

  /// No description provided for @checkoutCepLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery ZIP code'**
  String get checkoutCepLabel;

  /// No description provided for @checkoutCepFound.
  ///
  /// In en, this message translates to:
  /// **'Address found!'**
  String get checkoutCepFound;

  /// No description provided for @checkoutCepNotFound.
  ///
  /// In en, this message translates to:
  /// **'ZIP not in your saved addresses'**
  String get checkoutCepNotFound;

  /// No description provided for @checkoutSaveAddress.
  ///
  /// In en, this message translates to:
  /// **'Save address?'**
  String get checkoutSaveAddress;

  /// No description provided for @checkoutSaveAddressMessage.
  ///
  /// In en, this message translates to:
  /// **'Save this address to your account and set as favorite?'**
  String get checkoutSaveAddressMessage;

  /// No description provided for @checkoutUpdateAddress.
  ///
  /// In en, this message translates to:
  /// **'Update saved address?'**
  String get checkoutUpdateAddress;

  /// No description provided for @checkoutUpdateAddressMessage.
  ///
  /// In en, this message translates to:
  /// **'Details changed. Update the saved address?'**
  String get checkoutUpdateAddressMessage;

  /// No description provided for @checkoutPlacing.
  ///
  /// In en, this message translates to:
  /// **'Placing order...'**
  String get checkoutPlacing;

  /// No description provided for @checkoutValidating.
  ///
  /// In en, this message translates to:
  /// **'Validating cart...'**
  String get checkoutValidating;

  /// No description provided for @checkoutError.
  ///
  /// In en, this message translates to:
  /// **'Error placing order'**
  String get checkoutError;

  /// No description provided for @checkoutCartChanged.
  ///
  /// In en, this message translates to:
  /// **'Cart updated — please review before continuing'**
  String get checkoutCartChanged;

  /// No description provided for @pixTitle.
  ///
  /// In en, this message translates to:
  /// **'PIX Payment'**
  String get pixTitle;

  /// No description provided for @pixCopyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get pixCopyCode;

  /// No description provided for @pixCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied!'**
  String get pixCopied;

  /// No description provided for @pixExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'Expires in 30 minutes'**
  String get pixExpiresIn;

  /// No description provided for @pixSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Order placed!'**
  String get pixSuccessTitle;

  /// No description provided for @pixSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete PIX payment to confirm your order'**
  String get pixSuccessSubtitle;

  /// No description provided for @pixInstructions.
  ///
  /// In en, this message translates to:
  /// **'Open your bank app, go to Pix and paste the code below'**
  String get pixInstructions;

  /// No description provided for @pixCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'PIX Code'**
  String get pixCodeLabel;

  /// No description provided for @orderSeeDetails.
  ///
  /// In en, this message translates to:
  /// **'See full details'**
  String get orderSeeDetails;

  /// No description provided for @orderStatusHistory.
  ///
  /// In en, this message translates to:
  /// **'Status history'**
  String get orderStatusHistory;

  /// No description provided for @checkoutSavedAddresses.
  ///
  /// In en, this message translates to:
  /// **'Saved addresses'**
  String get checkoutSavedAddresses;

  /// No description provided for @checkoutUseNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Use a different address'**
  String get checkoutUseNewAddress;

  /// No description provided for @checkoutDeliveryToSelected.
  ///
  /// In en, this message translates to:
  /// **'Delivery to this address'**
  String get checkoutDeliveryToSelected;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
