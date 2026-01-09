import 'package:devlearn/data/repositories/auth_repository.dart';
import 'package:devlearn/routes/route_name.dart';
import 'package:flutter/material.dart';

// ĐÃ XÓA: import 'package:devlearn/l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepo = AuthRepository();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final success = await _authRepo.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
      setState(() => _isLoading = false);
      if (success) {
        if (!mounted) return;
         ScaffoldMessenger.of(context).showSnackBar(
          // SỬA: Chuyển sang tiếng Việt
          const SnackBar(content: Text('Đăng ký thành công! Vui lòng đăng nhập.')),
        );
        Navigator.of(context).pop(); // Quay lại màn hình đăng nhập
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          // SỬA: Chuyển sang tiếng Việt
          const SnackBar(content: Text('Đăng ký thất bại. Vui lòng thử lại.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ĐÃ XÓA: final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      // SỬA: Chuyển sang tiếng Việt
      appBar: AppBar(title: const Text('Đăng ký')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // SỬA: Chuyển sang tiếng Việt
              Text('Tạo tài khoản mới của bạn', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                // SỬA: Chuyển sang tiếng Việt
                decoration: const InputDecoration(labelText: 'Tên người dùng'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // SỬA: Chuyển sang tiếng Việt
                    return 'Vui lòng nhập tên của bạn';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                // SỬA: Chuyển sang tiếng Việt
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    // SỬA: Chuyển sang tiếng Việt
                    return 'Vui lòng nhập một email hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                // SỬA: Chuyển sang tiếng Việt
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    // SỬA: Chuyển sang tiếng Việt
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  // SỬA: Chuyển sang tiếng Việt
                  : ElevatedButton(onPressed: _register, child: const Text('Đăng ký')),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                // SỬA: Chuyển sang tiếng Việt
                child: const Text('Đã có tài khoản? Đăng nhập'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
