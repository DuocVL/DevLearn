import 'package:devlearn/data/repositories/auth_repository.dart';
import 'package:devlearn/routes/route_name.dart';
import 'package:flutter/material.dart';

// ĐÃ XÓA: import 'package:devlearn/l10n/app_localizations.dart';

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
          // SỬA: Chuyển sang tiếng Việt
          const SnackBar(content: Text('Đặt lại mật khẩu thành công. Bây giờ bạn có thể đăng nhập.')),
        );
        Navigator.of(context).pushNamedAndRemoveUntil(RouteName.login, (route) => false);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          // SỬA: Chuyển sang tiếng Việt
          const SnackBar(content: Text('Không thể đặt lại mật khẩu. Vui lòng kiểm tra mã và thử lại.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ĐÃ XÓA: final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      // SỬA: Chuyển sang tiếng Việt
      appBar: AppBar(title: const Text('Đặt Lại Mật Khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // SỬA: Chuyển sang tiếng Việt
              const Text('Nhập mã bạn nhận được qua email và mật khẩu mới của bạn.'),
              const SizedBox(height: 20),
              TextFormField(
                controller: _codeController,
                // SỬA: Chuyển sang tiếng Việt
                decoration: const InputDecoration(labelText: 'Mã Đặt Lại'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // SỬA: Chuyển sang tiếng Việt
                    return 'Vui lòng nhập mã đặt lại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                // SỬA: Chuyển sang tiếng Việt
                decoration: const InputDecoration(labelText: 'Mật Khẩu Mới'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    // SỬA: Chuyển sang tiếng Việt
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  // SỬA: Chuyển sang tiếng Việt
                  : ElevatedButton(onPressed: _resetPassword, child: const Text('Đặt Lại Mật Khẩu')),
            ],
          ),
        ),
      ),
    );
  }
}
