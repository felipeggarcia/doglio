# Doglio - Pet Products Marketplace

A Flutter application for pet products sales, designed as a professional portfolio project.

## 🎯 Project Overview

Doglio is a comprehensive e-commerce marketplace specifically designed for pet products. This project demonstrates advanced Flutter development skills, clean architecture principles, and scalable code practices suitable for enterprise-level applications.

## ✨ Features

### 🛍️ Customer Features
- **Product Catalog**: Browse and search pet products with advanced filtering
- **Product Details**: Comprehensive product information with image galleries
- **Shopping Cart**: Add, remove, and manage products before purchase
- **Favorites**: Save products for later purchase
- **User Authentication**: Secure login and registration system
- **Order Management**: Track purchase history and order status
- **Internationalization**: Full support for English and Portuguese

### 🔧 Admin Features
- **Product Management**: Complete CRUD operations for products
- **Category Management**: Organize products into logical categories
- **Order Dashboard**: Monitor and manage customer orders
- **Image Upload**: Advanced image management system
- **Sales Analytics**: Track performance and sales metrics

## 🏗️ Architecture & Technical Excellence

### Clean Architecture Implementation
- **Domain Layer**: Business logic and entities
- **Data Layer**: Repository implementations and data sources
- **Presentation Layer**: UI components and state management

### Technical Stack
- **Frontend**: Flutter (Mobile + Web for admin)
- **Backend**: Firebase (Firestore, Auth, Storage)
- **State Management**: Riverpod (Provider pattern)
- **Navigation**: GoRouter for declarative routing
- **HTTP Client**: Dio with interceptors
- **Dependency Injection**: GetIt service locator
- **Error Handling**: Either monad pattern (dartz)
- **Testing**: Unit, Widget, and Integration tests
- **Internationalization**: Flutter Intl (EN/PT)

### Code Quality Standards
- ✅ SOLID Principles implementation
- ✅ Repository Pattern for data abstraction
- ✅ Use Cases for business logic encapsulation
- ✅ Dependency Injection throughout the app
- ✅ Comprehensive error handling
- ✅ Performance optimizations
- ✅ Accessibility compliance
- ✅ Responsive design principles

## 📁 Project Structure

```
lib/
├── core/                    # Shared infrastructure
│   ├── config/             # Environment & DI setup
│   ├── errors/             # Error handling
│   ├── network/            # HTTP abstractions
│   ├── theme/              # Design system
│   ├── utils/              # Utilities & helpers
│   ├── shared/             # Shared widgets & models
│   └── l10n/               # Internationalization
├── features/               # Business features (Clean Architecture)
│   ├── auth/              # Authentication
│   ├── catalog/           # Product catalog
│   ├── cart/              # Shopping cart
│   ├── checkout/          # Purchase flow
│   └── profile/           # User management
├── app.dart               # App configuration
├── main.dart              # Entry point
└── router.dart            # Navigation setup
```

## 🚀 Development Roadmap

### Phase 1 - Infrastructure (Foundation)
- [x] Project structure setup
- [x] Internationalization system
- [ ] Firebase backend configuration
- [ ] Core configuration (DI, theme, errors)
- [ ] Admin authentication
- [ ] Product CRUD (admin dashboard)

### Phase 2 - Public Catalog (Customer Experience)
- [ ] Product listing with pagination
- [ ] Advanced search and filtering
- [ ] Product details with image galleries
- [ ] Favorites system
- [ ] Shopping cart functionality

### Phase 3 - E-commerce (Complete Flow)
- [ ] Checkout process
- [ ] Payment integration
- [ ] Order management
- [ ] User profile and history
- [ ] Push notifications

### Phase 4 - Optimization & Deployment
- [ ] Performance optimization
- [ ] Comprehensive testing
- [ ] CI/CD pipeline
- [ ] App store deployment

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Firebase account
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/felipeggarcia/doglio.git
   cd doglio
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate internationalization files**
   ```bash
   flutter packages pub run intl_utils:generate
   ```

4. **Configure Firebase**
   - Create a new Firebase project
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Update environment configurations

5. **Run the application**
   ```bash
   flutter run
   ```

## 📱 Platforms Supported

- ✅ **Android** (Phone & Tablet)
- ✅ **iOS** (iPhone & iPad)
- ✅ **Web** (Admin Dashboard)
- 🚧 **macOS** (Future release)
- 🚧 **Windows** (Future release)

## 🤝 Contributing

This is a portfolio project, but feedback and suggestions are welcome! Please feel free to:

1. Open issues for bugs or feature requests
2. Submit pull requests for improvements
3. Share your thoughts on the architecture and implementation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

**Felipe Garcia** - Senior Flutter Developer  
- GitHub: [@felipeggarcia](https://github.com/felipeggarcia)
- LinkedIn: [Your LinkedIn Profile]
- Email: [Your Email]

---

**Built with ❤️ and Flutter**
