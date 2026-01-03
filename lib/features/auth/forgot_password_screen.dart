import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/repositories/auth_repository.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot-password';
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;
  bool _codeSent = false;
  final _authRepo = AuthRepository();

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Vui lòng nhập email';
    if (!v.contains('@') || !v.contains('.')) return 'Email không hợp lệ';
    return null;
  }

  String? _validateCode(String? v) {
    if (v == null || v.trim().isEmpty) return 'Vui lòng nhập mã';
    if (v.trim().length < 4) return 'Mã không hợp lệ';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (v.length < 6) return 'Mật khẩu phải ít nhất 6 ký tự';
    return null;
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final res = await _authRepo.sendResetCode(_emailController.text.trim());
      if (!mounted) return;
      if (res) {
        setState(() => _codeSent = true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mã đã được gửi tới email')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gửi mã thất bại')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mật khẩu xác nhận không khớp')));
      return;
    }
    setState(() => _loading = true);
    try {
      final ok = await _authRepo.resetPassword(_emailController.text.trim(), _codeController.text.trim(), _passwordController.text);
      if (!mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đặt lại mật khẩu thành công')));
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đặt lại mật khẩu thất bại')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.forgotPassword)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: theme.cardTheme.elevation ?? 6,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l10n.resetPassword, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        _codeSent ? 'Nhập mã đã gửi và đặt mật khẩu mới' : 'Nhập email để nhận mã đặt lại mật khẩu',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),

                      // Email (always visible)
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: _validateEmail,
                        enabled: !_codeSent,
                      ),

                      const SizedBox(height: 12),

                      if (_codeSent) ...[
                        TextFormField(
                          controller: _codeController,
                          decoration: const InputDecoration(labelText: 'Mã xác thực'),
                          validator: _validateCode,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'Mật khẩu mới'),
                          validator: _validatePassword,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _confirmController,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'Xác nhận mật khẩu'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Vui lòng xác nhận mật khẩu';
                            if (v != _passwordController.text) return 'Mật khẩu xác nhận không khớp';
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _resetPassword,
                            child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l10n.resetPassword),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => setState(() => _codeSent = false),
                          child: const Text('Gửi lại mã / Thay đổi email'),
                        ),
                      ] else ...[
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _sendCode,
                            child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l10n.sendCode),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
