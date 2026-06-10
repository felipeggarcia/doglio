import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:doglio/core/errors/failures.dart';
import 'package:doglio/features/admin/domain/entities/admin_user.dart';
import 'package:doglio/features/admin/presentation/pages/admin_user_form_page.dart';
import 'package:doglio/features/admin/presentation/providers/admin_users_provider.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

// Fake que captura a chamada de updateUser/createUser e sempre retorna sucesso.
class _FakeNotifier extends AdminUsersNotifier {
  AdminUser? updated;
  AdminUser? created;

  @override
  AdminUsersState build() => const AdminUsersState();

  @override
  Future<Either<Failure, AdminUser>> updateUser(AdminUser user) async {
    updated = user;
    return Right(user);
  }

  @override
  Future<Either<Failure, AdminUser>> createUser(
    AdminUser user, {
    required String password,
  }) async {
    created = user;
    return Right(user);
  }
}

const _editUser = AdminUser(
  id: '7',
  name: 'João Silva',
  email: 'joao@email.com',
  role: AdminUserRole.customer,
  isActive: true,
);

Widget _wrap(_FakeNotifier notifier, {AdminUser? user}) {
  return ProviderScope(
    overrides: [adminUsersProvider.overrideWith(() => notifier)],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('pt'),
      home: AdminUserFormPage(user: user),
    ),
  );
}

void main() {
  group('AdminUserFormPage', () {
    testWidgets('modo criação mostra título e campo de senha', (tester) async {
      await tester.pumpWidget(_wrap(_FakeNotifier()));
      await tester.pump();

      expect(find.text('Novo usuário'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
    });

    testWidgets('modo edição: título, prefill e sem campo de senha',
        (tester) async {
      await tester.pumpWidget(_wrap(_FakeNotifier(), user: _editUser));
      await tester.pump();

      expect(find.text('Editar usuário'), findsOneWidget);
      // Campo nome prefilled
      expect(find.text('João Silva'), findsOneWidget);
      // Sem senha na edição
      expect(find.text('Senha'), findsNothing);
      // Ação de excluir presente
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('salvar na edição chama updateUser com os dados', (tester) async {
      // Janela alta para o formulário inteiro caber (Salvar fica no fim).
      await tester.binding.setSurfaceSize(const Size(1200, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final notifier = _FakeNotifier();

      // Router com "home" → push do form, para que context.pop() funcione.
      final router = GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, _) => Scaffold(
              body: Builder(
                builder: (c) => Center(
                  child: ElevatedButton(
                    onPressed: () => c.push('/edit'),
                    child: const Text('GO'),
                  ),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/edit',
            builder: (_, _) => const AdminUserFormPage(user: _editUser),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [adminUsersProvider.overrideWith(() => notifier)],
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
        ),
      );

      await tester.tap(find.text('GO'));
      await tester.pumpAndSettle();

      // Salva
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      expect(notifier.updated, isNotNull);
      expect(notifier.updated!.id, '7');
      expect(notifier.updated!.email, 'joao@email.com');
      // Voltou para a home após o pop
      expect(find.text('GO'), findsOneWidget);
    });
  });
}
