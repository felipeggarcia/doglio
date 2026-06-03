library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/router.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider).valueOrNull;
    final user = authState is Authenticated ? authState.user : null;
    final firstName =
        (user?.name.isNotEmpty == true) ? user!.name.split(' ').first : '';

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary),
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

          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: Text(context.l10n.myOrders),
            onTap: () {
              Navigator.pop(context);
              context.pushOrders();
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: Text(context.l10n.myFavorites),
            onTap: () {
              Navigator.pop(context);
              context.pushFavorites();
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(context.l10n.myAddresses),
            onTap: () {
              Navigator.pop(context);
              context.pushAddresses();
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
              await ref.read(authProvider.notifier).signOut();
            },
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
