import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/failure.dart';
import '../../../core/extensions/failure_localization_extension.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/common_header.dart';
import '../controllers/account_info_controller.dart';

class AccountInfoScreen extends ConsumerStatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  ConsumerState<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends ConsumerState<AccountInfoScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isEditing = false;
  bool _submitted = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _startEdit(dynamic user) {
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _phoneController.text = user.phoneNumber ?? '';
    setState(() => _isEditing = true);
  }

  void _cancelEdit(dynamic user) {
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _phoneController.text = user.phoneNumber ?? '';
    setState(() => _isEditing = false);
  }

  void _save() {
    _submitted = true;
    ref.read(accountInfoControllerProvider.notifier).updateProfile(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          phoneNumber: _phoneController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(accountInfoControllerProvider);

    ref.listen<AsyncValue>(accountInfoControllerProvider, (previous, next) {
      if (_submitted && next is AsyncData && previous?.isLoading == true) {
        _submitted = false;
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileUpdatedSuccess)),
        );
      }
      if (next.hasError) {
        _submitted = false;
        final error = next.error;
        final message = error is Failure
            ? error.localizedMessage(context)
            : error.toString();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    });

    final user = state.valueOrNull;
    final fieldErrors = state.error is ValidationFailure
        ? (state.error as ValidationFailure).fieldErrors
        : null;

    // Pre-populate fields when data first arrives and not yet editing.
    if (user != null && !_isEditing && _firstNameController.text.isEmpty) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _phoneController.text = user.phoneNumber ?? '';
    }

    return Scaffold(
      body: Column(
        children: [
          CommonHeader(
            title: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.accountInformation,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            trailing: user == null
                ? null
                : GestureDetector(
                    onTap: () => _isEditing
                        ? _cancelEdit(user)
                        : _startEdit(user),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isEditing ? Icons.close : Icons.edit_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
          ),
          Expanded(
            child: state.isLoading && user == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProfileField(
                          label: l10n.firstName,
                          hint: l10n.firstNameHint,
                          controller: _firstNameController,
                          enabled: _isEditing,
                          errorText: fieldErrors?['firstName']?.first,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        _ProfileField(
                          label: l10n.lastName,
                          hint: l10n.lastNameHint,
                          controller: _lastNameController,
                          enabled: _isEditing,
                          errorText: fieldErrors?['lastName']?.first,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        _ProfileField(
                          label: l10n.email,
                          hint: l10n.emailHint,
                          controller: TextEditingController(
                              text: user?.email ?? ''),
                          enabled: false,
                          keyboardType: TextInputType.emailAddress,
                          helperText: l10n.emailNotEditable,
                        ),
                        const SizedBox(height: 16),
                        _ProfileField(
                          label: l10n.phoneNumber,
                          hint: l10n.phoneNumberHint,
                          controller: _phoneController,
                          enabled: _isEditing,
                          keyboardType: TextInputType.phone,
                          errorText: fieldErrors?['phoneNumber']?.first,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onSubmitted: _isEditing ? _save : null,
                        ),
                        if (_isEditing) ...[
                          const SizedBox(height: 32),
                          AppButton(
                            label: l10n.save,
                            isLoading: state.isLoading,
                            onPressed: _save,
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.hint,
    required this.controller,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.errorText,
    this.helperText,
    this.inputFormatters,
    this.onSubmitted,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool enabled;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? errorText;
  final String? helperText;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fillColor = enabled
        ? AppColors.inputFill(theme.brightness)
        : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        AppTextField(
          controller: controller,
          hint: hint,
          enabled: enabled,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          fillColor: fillColor,
          borderColor: Colors.transparent,
          focusedBorderColor: AppColors.primaryGold,
          inputFormatters: inputFormatters,
          validator: (_) => errorText,
          onSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
          textColor: enabled ? null : theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText!,
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}
