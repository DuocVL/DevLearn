import 'package:devlearn/data/repositories/auth_repository.dart';
import 'package:devlearn/routes/route_name.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authRepo = AuthRepository();
  bool _isLoading = false;

  Future<void> _sendResetCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final success = await _authRepo.sendResetCode(_emailController.text);
      setState(() => _isLoading = false);
      if (success) {
        if (!mounted) return;
        Navigator.of(context).pushNamed(RouteName.resetPassword, arguments: _emailController.text);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send reset code. Please check your email.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _sendResetCode, child: const Text('Send Code')),
            ],
          ),
        ),
      ),
    );
  }
}
