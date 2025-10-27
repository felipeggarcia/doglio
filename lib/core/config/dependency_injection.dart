/// Dependency Injection setup for Doglio Marketplace
///
/// This file configures dependency injection for the application
/// following Clean Architecture principles.
///
/// TODO: Add get_it package to pubspec.yaml and uncomment implementation
library;

// Simple service locator implementation
// Replace with GetIt when package is available
class _ServiceLocator {
  static final _ServiceLocator _instance = _ServiceLocator._internal();
  factory _ServiceLocator() => _instance;
  _ServiceLocator._internal();

  final Map<Type, dynamic> _services = {};
  final Map<Type, dynamic Function()> _factories = {};

  T get<T>() {
    final service = _services[T];
    if (service != null) {
      return service as T;
    }

    final factory = _factories[T];
    if (factory != null) {
      return factory() as T;
    }

    throw Exception('Service of type $T is not registered');
  }

  void registerSingleton<T>(T service) {
    _services[T] = service;
  }

  void registerFactory<T>(T Function() factory) {
    _factories[T] = factory;
  }

  bool isRegistered<T>() {
    return _services.containsKey(T) || _factories.containsKey(T);
  }

  void reset() {
    _services.clear();
    _factories.clear();
  }
}

// Global service locator instance
final serviceLocator = _ServiceLocator();

/// Initializes all dependencies for the application
/// Call this method in main.dart before running the app
Future<void> initializeDependencies() async {
  // Core dependencies
  await _initializeCore();

  // Data layer dependencies
  await _initializeDataLayer();

  // Domain layer dependencies
  await _initializeDomainLayer();

  // Presentation layer dependencies
  await _initializePresentationLayer();
}

/// Initialize core infrastructure dependencies
Future<void> _initializeCore() async {
  // HTTP Client
  // serviceLocator.registerSingleton<HttpClient>(HttpClientImpl());

  // Local Storage
  // serviceLocator.registerSingleton<LocalStorage>(LocalStorageImpl());

  // Logger
  // serviceLocator.registerSingleton<AppLogger>(AppLoggerImpl());
}

/// Initialize data layer dependencies (repositories, data sources)
Future<void> _initializeDataLayer() async {
  // Remote Data Sources
  // serviceLocator.registerSingleton<AuthRemoteDataSource>(
  //   AuthRemoteDataSourceImpl(serviceLocator.get()),
  // );

  // serviceLocator.registerSingleton<ProductRemoteDataSource>(
  //   ProductRemoteDataSourceImpl(serviceLocator.get()),
  // );

  // Repositories
  // serviceLocator.registerSingleton<AuthRepository>(
  //   AuthRepositoryImpl(serviceLocator.get()),
  // );

  // serviceLocator.registerSingleton<ProductRepository>(
  //   ProductRepositoryImpl(serviceLocator.get()),
  // );
}

/// Initialize domain layer dependencies (use cases)
Future<void> _initializeDomainLayer() async {
  // Auth Use Cases
  // serviceLocator.registerFactory(() => LoginUser(serviceLocator.get()));
  // serviceLocator.registerFactory(() => RegisterUser(serviceLocator.get()));
  // serviceLocator.registerFactory(() => LogoutUser(serviceLocator.get()));

  // Product Use Cases
  // serviceLocator.registerFactory(() => GetProducts(serviceLocator.get()));
  // serviceLocator.registerFactory(() => GetProductDetails(serviceLocator.get()));
  // serviceLocator.registerFactory(() => SearchProducts(serviceLocator.get()));

  // Cart Use Cases
  // serviceLocator.registerFactory(() => AddToCart(serviceLocator.get()));
  // serviceLocator.registerFactory(() => RemoveFromCart(serviceLocator.get()));
  // serviceLocator.registerFactory(() => GetCartItems(serviceLocator.get()));
}

/// Initialize presentation layer dependencies (controllers, providers)
Future<void> _initializePresentationLayer() async {
  // Controllers/Providers
  // serviceLocator.registerFactory(() => AuthController(
  //   serviceLocator.get(),
  //   serviceLocator.get(),
  //   serviceLocator.get()
  // ));
  // serviceLocator.registerFactory(() => CatalogController(
  //   serviceLocator.get(),
  //   serviceLocator.get()
  // ));
  // serviceLocator.registerFactory(() => CartController(
  //   serviceLocator.get(),
  //   serviceLocator.get(),
  //   serviceLocator.get()
  // ));
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  serviceLocator.reset();
}

/// Check if a dependency is registered
bool isDependencyRegistered<T>() {
  return serviceLocator.isRegistered<T>();
}

/// Get a registered dependency
T getDependency<T>() {
  return serviceLocator.get<T>();
}
