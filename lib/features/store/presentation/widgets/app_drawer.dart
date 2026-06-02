/// App navigation drawer shown when the user is authenticated
library;

import 'package:flutter/material.dart';
import '../../../../core/config/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.instance;
    final user = auth.currentUser;
    final firstName =
        (user?.name.isNotEmpty == true) ? user!.name.split(' ').first : '';

    return Drawer(
      child: Column(
        children: [
          // Header
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.drawerWelcome(firstName),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // Menu items
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: Text(context.l10n.myOrders),
            onTap: () {
              Navigator.pop(context);
              context.goToOrders();
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: Text(context.l10n.myFavorites),
            onTap: () {
              Navigator.pop(context);
              context.goToFavorites();
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(context.l10n.myAddresses),
            onTap: () {
              Navigator.pop(context);
              context.goToAddresses();
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              context.l10n.signOut,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () async {
              Navigator.pop(context);
              await auth.signOut();
            },
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
