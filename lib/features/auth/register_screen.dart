import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;
  final _authRepo = AuthRepository();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final ok = await _authRepo.register(_usernameController.text.trim(), _emailController.text.trim(), _passwordController.text);
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng ký thành công')));
        Navigator.of(context).pop(); // back to login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng ký thất bại')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _validateUsername(String? v) {
    if (v == null || v.trim().isEmpty) return 'Vui lòng nhập tên người dùng';
    if (v.trim().length < 3) return 'Tên người dùng ít nhất 3 ký tự';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Vui lòng nhập email';
    if (!v.contains('@') || !v.contains('.')) return 'Email không hợp lệ';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (v.length < 6) return 'Mật khẩu phải ít nhất 6 ký tự';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Vui lòng xác nhận mật khẩu';
    if (v != _passwordController.text) return 'Mật khẩu xác nhận không khớp';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tạo tài khoản mới', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('Nhập thông tin để đăng ký tài khoản DevLearn', style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 18),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(labelText: 'Tên người dùng'),
                            validator: _validateUsername,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(labelText: 'Email'),
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'Mật khẩu'),
                            validator: _validatePassword,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _confirmController,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'Xác nhận mật khẩu'),
                            validator: _validateConfirm,
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _submit,
                              child: _loading
                                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Text('Đăng ký'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Đã có tài khoản? '),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Đăng nhập'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
