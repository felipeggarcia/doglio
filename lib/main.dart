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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

/// Application entry point
void main() async {
  await DoglioAppInitializer.initialize();
  runApp(const ProviderScope(child: DoglioApp()));
}

