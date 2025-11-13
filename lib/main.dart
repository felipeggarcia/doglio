// Doglio - Pet Products Marketplace
//
// PROJECT CONTEXT:
// - Flutter marketplace for pet products sales
// - Portfolio project demonstrating technical expertise
// - Focus on Clean Architecture, scalability and impeccable code
// - Backend: Laravel REST API
// - Features: catalog, cart, checkout, admin dashboard
// - Internationalization: English/Portuguese support
//
// MANDATORY STANDARDS:
// - Rigorous Clean Architecture (Domain/Data/Presentation)
// - Repository Pattern with abstractions
// - Either for error handling
// - Simple state management with ChangeNotifier
// - ALWAYS check for reusability before creating new code
// - Respect defined folder structure

import 'package:flutter/material.dart';
import 'app.dart';

/// Application entry point
void main() async {
  // Initialize app dependencies and services
  await DoglioAppInitializer.initialize();

  // Run the app
  runApp(const DoglioApp());
}
