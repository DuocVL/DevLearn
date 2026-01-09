import 'package:devlearn/data/repositories/auth_repository.dart';
import 'package:devlearn/features/register/register_screen.dart';
import 'package:devlearn/routes/route_name.dart';
import 'package:flutter/material.dart';

// ĐÃ XÓA: import 'package:devlearn/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepo = AuthRepository();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final success = await _authRepo.login(
        _emailController.text,
        _passwordController.text,
      );
      setState(() => _isLoading = false);
      if (success) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(RouteName.home);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          // SỬA: Chuyển sang tiếng Việt
          const SnackBar(content: Text('Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.')),
        );
      }
    }
  }

  /*
  Future<void> _loginWithGoogle() async { ... }
  Future<void> _loginWithGithub() async { ... }
  */

  @override
  Widget build(BuildContext context) {
    // ĐÃ XÓA: final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      // SỬA: Chuyển sang tiếng Việt
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                  if (value == null || value.isEmpty) {
                    // SỬA: Chuyển sang tiếng Việt
                    return 'Vui lòng nhập mật khẩu của bạn';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pushNamed(RouteName.forgotPassword),
                  // SỬA: Chuyển sang tiếng Việt
                  child: const Text('Quên mật khẩu?'),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  // SỬA: Chuyển sang tiếng Việt
                  : ElevatedButton(onPressed: _login, child: const Text('Đăng nhập')),
              const SizedBox(height: 20),
              const Divider(),
              /*
              const SizedBox(height: 10),
              SignInButton( ... ),
              const SizedBox(height: 10),
               SignInButton( ... ),
              */
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
                },
                // SỬA: Chuyển sang tiếng Việt
                child: const Text('Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
