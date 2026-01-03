import 'package:devlearn/data/repositories/auth_repository.dart';
import 'package:devlearn/l10n/app_localizations.dart';
import 'package:devlearn/routes/route_name.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepo = AuthRepository();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final success = await _authRepo.resetPassword(
        widget.email,
        _codeController.text,
        _passwordController.text,
      );
      setState(() => _isLoading = false);
      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successfully. You can now log in.')),
        );
        Navigator.of(context).pushNamedAndRemoveUntil(RouteName.login, (route) => false);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to reset password. Please check the code and try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.resetPassword)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(labelText: l10n.code),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the reset code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: l10n.newPassword),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _resetPassword, child: Text(l10n.resetPassword)),
            ],
          ),
        ),
      ),
    );
  }
}
