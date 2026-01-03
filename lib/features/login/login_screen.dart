import 'package:devlearn/data/repositories/auth_repository.dart';
import 'package:devlearn/features/register/register_screen.dart';
import 'package:devlearn/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:devlearn/l10n/app_localizations.dart';
import 'package:sign_in_button/sign_in_button.dart';

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
          const SnackBar(content: Text('Login failed. Please check your credentials.')),
        );
      }
    }
  }

  // Các phương thức loginWithGoogle và loginWithGithub sẽ được thêm vào sau
  Future<void> _loginWithGoogle() async {
    // Logic để lấy idToken từ Google sẽ được thêm vào đây
    // final success = await _authRepo.loginWithGoogle(idToken);
    // Xử lý kết quả
  }

  Future<void> _loginWithGithub() async {
    // Logic để lấy code từ GitHub sẽ được thêm vào đây
    // final success = await _authRepo.loginWithGithub(code);
    // Xử lý kết quả
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.login)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: l10n.email),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: l10n.password),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pushNamed(RouteName.forgotPassword),
                  child: Text(l10n.forgotPassword),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _login, child: Text(l10n.login)),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              SignInButton(
                Buttons.google,
                onPressed: _loginWithGoogle,
              ),
              const SizedBox(height: 10),
               SignInButton(
                Buttons.gitHub,
                onPressed: _loginWithGithub,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
                },
                child: Text(l10n.register),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
