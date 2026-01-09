import 'package:devlearn/data/repositories/auth_repository.dart';
import 'package:devlearn/features/register/register_screen.dart';
import 'package:devlearn/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:devlearn/l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      // FIX: Khởi tạo GoogleSignIn cục bộ để giải quyết triệt để lỗi phân tích.
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google login failed: Could not retrieve ID token.')),
        );
        setState(() => _isLoading = false);
        return;
      }

      final success = await _authRepo.loginWithGoogle(idToken);
      if (success) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(RouteName.home);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google login failed. Please try again.')),
        );
      }
    } catch (error) {
      print(error);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during Google login.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loginWithGithub() async {
    setState(() => _isLoading = true);
    try {
      final githubClientId = dotenv.env['GITHUB_CLIENT_ID'];
      final githubRedirectUri = dotenv.env['GITHUB_REDIRECT_URI'];

      if (githubClientId == null || githubRedirectUri == null) {
        throw Exception('GitHub environment variables not set');
      }

      final authUrl = Uri.https('github.com', '/login/oauth/authorize', {
        'client_id': githubClientId,
        'redirect_uri': githubRedirectUri,
        'scope': 'read:user',
      });

      final result = await FlutterWebAuth.authenticate(
        url: authUrl.toString(),
        callbackUrlScheme: 'devlearn',
      );

      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('GitHub login failed: No code received.')),
        );
        return;
      }

      final success = await _authRepo.loginWithGithub(code);

      if (success) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(RouteName.home);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('GitHub login failed. Please try again.')),
        );
      }
    } catch (error) {
      print(error);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during GitHub login: ${error.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
                onPressed: _isLoading ? null : () => _loginWithGoogle(),
              ),
              const SizedBox(height: 10),
               SignInButton(
                Buttons.gitHub,
                onPressed: _isLoading ? null : () => _loginWithGithub(),
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
