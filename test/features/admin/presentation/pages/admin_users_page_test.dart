import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:doglio/features/admin/domain/entities/admin_user.dart';
import 'package:doglio/features/admin/domain/entities/page_meta.dart';
import 'package:doglio/features/admin/presentation/pages/admin_users_page.dart';
import 'package:doglio/features/admin/presentation/providers/admin_users_provider.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

// Notifier falso: estado fixo, sem rede. Mutators atualizam só o estado local.
class _FakeNotifier extends AdminUsersNotifier {
  _FakeNotifier(this._initial);
  final AdminUsersState _initial;

  @override
  AdminUsersState build() => _initial;

  @override
  void setSearch(String v) => state = state.copyWith(search: v);
  @override
  void setRoleFilter(AdminUserRole? r) => state = state.copyWith(roleFilter: r);
  @override
  void setActiveFilter(bool? a) => state = state.copyWith(activeFilter: a);
  @override
  Future<void> refresh() async {}
  @override
  Future<void> loadMore() async {}
}

AdminUser _user(String id, String name, {AdminUserRole role = AdminUserRole.customer}) =>
    AdminUser(
      id: id,
      name: name,
      email: '${name.toLowerCase()}@email.com',
      role: role,
      isActive: true,
    );

Widget _app(AdminUsersState state) {
  final router = GoRouter(
    initialLocation: '/admin/users',
    routes: [
      GoRoute(
        path: '/admin/users',
        name: 'admin-users',
        builder: (_, _) => const AdminUsersPage(),
      ),
      GoRoute(
        path: '/admin/users/new',
        name: 'admin-user-create',
        builder: (_, _) => const Scaffold(body: Text('CREATE_STUB')),
      ),
      GoRoute(
        path: '/admin/users/:id/edit',
        name: 'admin-user-edit',
        builder: (_, _) => const Scaffold(body: Text('EDIT_STUB')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      adminUsersProvider.overrideWith(() => _FakeNotifier(state)),
    ],
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('pt'),
    ),
  );
}

void main() {
  group('AdminUsersPage', () {
    testWidgets('renderiza tiles com nome e email', (tester) async {
      await tester.pumpWidget(_app(
        AdminUsersState(users: [_user('1', 'João'), _user('2', 'Maria')]),
      ));
      await tester.pump();

      expect(find.text('João'), findsOneWidget);
      expect(find.text('maria@email.com'), findsOneWidget);
    });

    testWidgets('lista vazia mostra mensagem', (tester) async {
      await tester.pumpWidget(_app(const AdminUsersState()));
      await tester.pump();

      expect(find.text('Nenhum usuário encontrado'), findsOneWidget);
    });

    testWidgets('botão "Carregar mais" aparece quando há mais páginas',
        (tester) async {
      await tester.pumpWidget(_app(
        AdminUsersState(
          users: [_user('1', 'João')],
          meta: const PageMeta(currentPage: 1, lastPage: 2, total: 30),
        ),
      ));
      await tester.pump();

      expect(find.text('Carregar mais'), findsOneWidget);
    });

    testWidgets('"Carregar mais" some na última página', (tester) async {
      await tester.pumpWidget(_app(
        AdminUsersState(
          users: [_user('1', 'João')],
          meta: const PageMeta(currentPage: 1, lastPage: 1, total: 1),
        ),
      ));
      await tester.pump();

      expect(find.text('Carregar mais'), findsNothing);
    });

    testWidgets('tocar num usuário navega para edição', (tester) async {
      await tester.pumpWidget(_app(
        AdminUsersState(users: [_user('1', 'João')]),
      ));
      await tester.pump();

      await tester.tap(find.text('João'));
      await tester.pumpAndSettle();

      expect(find.text('EDIT_STUB'), findsOneWidget);
    });

    testWidgets('FAB navega para criação', (tester) async {
      await tester.pumpWidget(_app(
        AdminUsersState(users: [_user('1', 'João')]),
      ));
      await tester.pump();

      await tester.tap(find.text('Novo usuário'));
      await tester.pumpAndSettle();

      expect(find.text('CREATE_STUB'), findsOneWidget);
    });

    testWidgets('selecionar filtro "Admin" marca o chip', (tester) async {
      await tester.pumpWidget(_app(
        AdminUsersState(users: [_user('1', 'João')]),
      ));
      await tester.pump();

      await tester.tap(find.widgetWithText(ChoiceChip, 'Admin'));
      await tester.pump();

      final chip =
          tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Admin'));
      expect(chip.selected, isTrue);
    });
  });
}
