library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/cpf_cnpj_formatter.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/widgets/auth_form.dart';
import '../../domain/entities/admin_user.dart';
import '../providers/admin_users_provider.dart';

/// Formulário compartilhado de criação/edição de usuário.
///
/// `user == null` → modo criação (com campo de senha obrigatório).
/// `user != null` → modo edição (sem senha; com ação de excluir).
class AdminUserFormPage extends ConsumerStatefulWidget {
  const AdminUserFormPage({super.key, this.user});

  final AdminUser? user;

  @override
  ConsumerState<AdminUserFormPage> createState() => _AdminUserFormPageState();
}

class _AdminUserFormPageState extends ConsumerState<AdminUserFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _city;
  late final TextEditingController _state;
  late final TextEditingController _cpfCnpj;
  late final TextEditingController _birthDate;

  late AdminUserRole _role;
  late bool _isActive;
  DateTime? _birthDateValue; // valor escolhido no calendário
  bool _saving = false;

  bool get _isEditing => widget.user != null;

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    _name = TextEditingController(text: u?.name ?? '');
    _email = TextEditingController(text: u?.email ?? '');
    _password = TextEditingController();
    _city = TextEditingController(text: u?.city ?? '');
    _state = TextEditingController(text: u?.state ?? '');
    // CPF/CNPJ exibido com máscara (mesmo que a API tenha mandado só dígitos).
    _cpfCnpj = TextEditingController(
      text: u?.cpfCnpj != null ? formatCpfCnpj(u!.cpfCnpj!) : '',
    );
    // Converte a data da API para DateTime (parse robusto: ISO, com hora, ou dd/MM/aaaa).
    _birthDateValue =
        u?.birthDate != null ? _parseApiDate(u!.birthDate!) : null;
    _birthDate = TextEditingController(
      text: _birthDateValue != null ? _formatDisplay(_birthDateValue!) : '',
    );
    _role = u?.role ?? AdminUserRole.customer;
    _isActive = u?.isActive ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _city.dispose();
    _state.dispose();
    _cpfCnpj.dispose();
    _birthDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? l10n.adminUserEditTitle : l10n.adminUserCreateTitle,
        ),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.delete,
              onPressed: _saving ? null : _handleDelete,
            ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              AuthFormField(
                controller: _name,
                label: l10n.fullName,
                prefixIcon: Icons.person_outline,
                validator: (v) => Validators.name(v, context),
                enabled: !_saving,
              ),
              const SizedBox(height: 16),
              AuthFormField(
                controller: _email,
                label: l10n.email,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                validator: (v) => Validators.email(v, context),
                enabled: !_saving,
              ),
              // Senha apenas na criação (obrigatória pela API).
              if (!_isEditing) ...[
                const SizedBox(height: 16),
                AuthFormField(
                  controller: _password,
                  label: l10n.password,
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                  validator: _validatePassword,
                  enabled: !_saving,
                ),
              ],
              const SizedBox(height: 16),
              _RoleField(
                value: _role,
                enabled: !_saving,
                onChanged: (r) => setState(() => _role = r),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.adminFieldActive),
                value: _isActive,
                onChanged: _saving ? null : (v) => setState(() => _isActive = v),
              ),
              const SizedBox(height: 8),
              AuthFormField(
                controller: _city,
                label: l10n.adminFieldCity,
                prefixIcon: Icons.location_city_outlined,
                enabled: !_saving,
              ),
              const SizedBox(height: 16),
              AuthFormField(
                controller: _state,
                label: l10n.adminFieldState,
                prefixIcon: Icons.map_outlined,
                enabled: !_saving,
              ),
              const SizedBox(height: 16),
              AuthFormField(
                controller: _cpfCnpj,
                label: l10n.adminFieldCpfCnpj,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.badge_outlined,
                enabled: !_saving,
                inputFormatters: [CpfCnpjInputFormatter()],
              ),
              const SizedBox(height: 16),
              AuthFormField(
                controller: _birthDate,
                label: l10n.adminFieldBirthDate,
                prefixIcon: Icons.cake_outlined,
                suffixIcon: const Icon(Icons.calendar_today_outlined),
                enabled: !_saving,
                readOnly: true,
                onTap: _saving ? null : _pickBirthDate,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _saving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return context.l10n.passwordRequired;
    if (value.length < 8) return context.l10n.passwordTooShort(8);
    return null;
  }

  /// Monta a entidade a partir dos campos do formulário.
  /// Campos de texto vazios viram null (para não enviar string vazia à API).
  AdminUser _buildUser() {
    String? orNull(String s) => s.trim().isEmpty ? null : s.trim();
    return AdminUser(
      id: widget.user?.id ?? '',
      name: _name.text.trim(),
      email: _email.text.trim(),
      role: _role,
      isActive: _isActive,
      city: orNull(_city.text),
      state: orNull(_state.text),
      // CPF/CNPJ sempre como dígitos puros para a API (remove a máscara).
      cpfCnpj: orNull(onlyDigits(_cpfCnpj.text)),
      // Envia em ISO (aaaa-MM-dd), formato que a API espera.
      birthDate: _birthDateValue != null ? _formatIso(_birthDateValue!) : null,
    );
  }

  /// Parse tolerante da data vinda da API: aceita ISO (aaaa-MM-dd), com hora
  /// ('T' ou espaço) e também dd/MM/aaaa. Normaliza para data local sem hora.
  DateTime? _parseApiDate(String raw) {
    if (raw.trim().isEmpty) return null;
    final datePart = raw.trim().split(RegExp(r'[ T]')).first;

    final iso = DateTime.tryParse(datePart);
    if (iso != null) return DateTime(iso.year, iso.month, iso.day);

    final br = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(datePart);
    if (br != null) {
      return DateTime(
        int.parse(br.group(3)!),
        int.parse(br.group(2)!),
        int.parse(br.group(1)!),
      );
    }
    return null;
  }

  /// Abre o calendário e atualiza a data escolhida.
  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDateValue ?? DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now, // não dá para nascer no futuro
      helpText: context.l10n.adminFieldBirthDate,
    );
    if (picked == null) return;
    setState(() {
      _birthDateValue = picked;
      _birthDate.text = _formatDisplay(picked);
    });
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  /// Exibição amigável: dd/MM/aaaa.
  String _formatDisplay(DateTime d) => '${_two(d.day)}/${_two(d.month)}/${d.year}';

  /// Formato da API: aaaa-MM-dd.
  String _formatIso(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${_two(d.month)}-${_two(d.day)}';

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final notifier = ref.read(adminUsersProvider.notifier);
    final user = _buildUser();
    final result = _isEditing
        ? await notifier.updateUser(user)
        : await notifier.createUser(user, password: _password.text);

    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      (failure) => _snack(failure.userMessage, isError: true),
      (_) {
        _snack(
          _isEditing ? context.l10n.adminUserSaved : context.l10n.adminUserCreated,
        );
        context.pop();
      },
    );
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.delete),
        content: Text(ctx.l10n.adminUserDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(ctx.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _saving = true);
    final result =
        await ref.read(adminUsersProvider.notifier).deleteUser(widget.user!.id);
    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      (failure) => _snack(failure.userMessage, isError: true),
      (_) {
        _snack(context.l10n.adminUserDeleted);
        context.pop();
      },
    );
  }

  void _snack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }
}

/// Dropdown de seleção de função (role).
class _RoleField extends StatelessWidget {
  const _RoleField({
    required this.value,
    required this.onChanged,
    required this.enabled,
  });

  final AdminUserRole value;
  final ValueChanged<AdminUserRole> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DropdownButtonFormField<AdminUserRole>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: l10n.adminFieldRole,
        prefixIcon: const Icon(Icons.shield_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: [
        DropdownMenuItem(
          value: AdminUserRole.customer,
          child: Text(l10n.adminRoleCustomer),
        ),
        DropdownMenuItem(
          value: AdminUserRole.admin,
          child: Text(l10n.adminRoleAdmin),
        ),
      ],
      onChanged: enabled ? (r) => onChanged(r ?? value) : null,
    );
  }
}
