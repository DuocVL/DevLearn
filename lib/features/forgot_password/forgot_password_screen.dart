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
      // SỬA LỖI: Gọi đúng tên phương thức là 'sendResetCode'
      final success = await _authRepo.sendResetCode(_emailController.text);
      setState(() => _isLoading = false);
      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã gửi mã đặt lại mật khẩu. Vui lòng kiểm tra email của bạn.')),
        );
        Navigator.of(context).pushNamed(RouteName.resetPassword, arguments: _emailController.text);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gửi mã thất bại. Vui lòng kiểm tra lại email của bạn.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quên Mật Khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text('Nhập email của bạn để nhận mã đặt lại mật khẩu.'),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Vui lòng nhập một email hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _sendResetCode, child: const Text('Gửi Mã')),
            ],
          ),
        ),
      ),
    );
  }
}
