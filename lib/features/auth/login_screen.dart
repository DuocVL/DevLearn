import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../routes/route_name.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/refresh_token_service.dart';

class LoginScreen extends StatefulWidget {
	static const routeName = '/login';
	const LoginScreen({Key? key}) : super(key: key);

	@override
	State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
	final _formKey = GlobalKey<FormState>();
	final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();
	bool _loading = false;

	final _authRepo = AuthRepository();

	final _storage = const FlutterSecureStorage();
	final _refreshService = RefreshTokenService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

	@override
	void initState() {
		super.initState();
		_checkLoggedIn();
	}

	@override
	void dispose() {
		_emailController.dispose();
		_passwordController.dispose();
		super.dispose();
	}

	Future<void> _checkLoggedIn() async {
		final access = await _storage.read(key: 'access_token');
		if (access != null && access.isNotEmpty) {
			if (!mounted) return;
			Navigator.of(context).pushReplacementNamed(RouteName.home);
			return;
		}
		final refresh = await _storage.read(key: 'refresh_token');
		if (refresh != null && refresh.isNotEmpty) {
			try {
				final res = await _refreshService.refreshToken();
				if (res.statusCode == 200) {
					final data = jsonDecode(res.body);
					final newAccess = data['accessToken'] ?? data['access_token'];
					final newRefresh = data['refreshToken'] ?? data['refresh_token'];
					if (newAccess != null) await _storage.write(key: 'access_token', value: newAccess.toString());
					if (newRefresh != null) await _storage.write(key: 'refresh_token', value: newRefresh.toString());
					if (!mounted) return;
					Navigator.of(context).pushReplacementNamed(RouteName.home);
				}
			} catch (_) {}
		}
	}

	Future<void> _setLoadingAndRun(Future<void> Function() fn) async {
		setState(() => _loading = true);
		try {
			await fn();
		} finally {
			if (mounted) setState(() => _loading = false);
		}
	}

	Future<void> _signInWithEmail() async {
		if (!_formKey.currentState!.validate()) return;
		await _setLoadingAndRun(() async {
			final email = _emailController.text.trim();
			final password = _passwordController.text;
			final ok = await _authRepo.login(email, password);
			if (ok) {
				ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng nhập thành công')));
				Navigator.of(context).pushReplacementNamed(RouteName.home);
			} else {
				ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng nhập thất bại')));
			}
		});
	}

	Future<void> _signInWithGoogle() async {
		await _setLoadingAndRun(() async {
      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          // The user canceled the sign-in
          return;
        }
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final String? idToken = googleAuth.idToken;

        if (idToken == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không thể lấy được idToken từ Google')));
          return;
        }

        final ok = await _authRepo.loginWithGoogle(idToken);
        if (ok) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng nhập bằng Google thành công')));
          Navigator.of(context).pushReplacementNamed(RouteName.home);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng nhập Google thất bại')));
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi khi đăng nhập bằng Google: $error')));
      }
		});
	}

	Future<void> _signInWithGithub() async {
    await _setLoadingAndRun(() async {
      try {
        final githubClientId = dotenv.env['GITHUB_CLIENT_ID'];
        final url = Uri.https('github.com', '/login/oauth/authorize', {
          'client_id': githubClientId,
          'redirect_uri': 'devlearn://callback',
          'scope': 'read:user',
        });

        final result = await FlutterWebAuth.authenticate(url: url.toString(), callbackUrlScheme: 'devlearn');
        final code = Uri.parse(result).queryParameters['code'];

        if (code == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không thể lấy được mã từ GitHub')));
          return;
        }

        final ok = await _authRepo.loginWithGithub(code);
        if (ok) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng nhập bằng GitHub thành công')));
          Navigator.of(context).pushReplacementNamed(RouteName.home);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng nhập GitHub thất bại')));
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi khi đăng nhập bằng GitHub: $error')));
      }
    });
	}

	void _navigateToRegister() {
		Navigator.of(context).pushNamed(RouteName.register);
	}

	void _forgotPassword() {
		Navigator.of(context).pushNamed(RouteName.forgotPassword);
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final isDark = theme.brightness == Brightness.dark;
		final primary = theme.colorScheme.primary;
		final secondary = theme.colorScheme.secondary;

		return Scaffold(
			body: Container(
				decoration: BoxDecoration(
					gradient: LinearGradient(
						begin: Alignment.topLeft,
						end: Alignment.bottomRight,
						colors: isDark
								? [primary.withOpacity(0.18), Colors.black]
								: [primary.withOpacity(0.12), secondary.withOpacity(0.06)],
					),
				),
				child: Center(
					child: SingleChildScrollView(
						padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
						child: ConstrainedBox(
							constraints: const BoxConstraints(maxWidth: 520),
							child: Card(
								color: theme.cardColor,
								elevation: theme.cardTheme.elevation ?? 6,
								shape: theme.cardTheme.shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
								child: Padding(
									padding: const EdgeInsets.all(20.0),
									child: Column(
										mainAxisSize: MainAxisSize.min,
										children: [
											// Logo + title
											Row(
												children: [
													SvgPicture.asset(
														'assets/icons/logo.svg',
														height: 56,
														width: 56,
														// keep original colors in light mode, tint for dark mode
														color: isDark ? theme.colorScheme.onSurface : null,
													),
													const SizedBox(width: 12),
													Column(
														crossAxisAlignment: CrossAxisAlignment.start,
														children: [
															Text('DevLearn', style: theme.textTheme.titleLarge),
															const SizedBox(height: 2),
															Text('Luyện code — Học lập trình', style: theme.textTheme.bodyMedium),
														],
													),
												],
											),
											const SizedBox(height: 18),

											// Form
											Form(
												key: _formKey,
												child: Column(
													children: [
														TextFormField(
															controller: _emailController,
															keyboardType: TextInputType.emailAddress,
															decoration: InputDecoration(
																labelText: 'Email',
																prefixIcon: const Icon(Icons.email_outlined),
															),
															validator: (v) {
																if (v == null || v.isEmpty) return 'Vui lòng nhập email';
																if (!v.contains('@')) return 'Email không hợp lệ';
																return null;
															},
														),
														const SizedBox(height: 12),
														TextFormField(
															controller: _passwordController,
															obscureText: true,
															decoration: InputDecoration(
																labelText: 'Mật khẩu',
																prefixIcon: const Icon(Icons.lock_outline),
															),
															validator: (v) {
																if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu';
																if (v.length < 6) return 'Mật khẩu phải ít nhất 6 ký tự';
																return null;
															},
														),
														const SizedBox(height: 18),
														SizedBox(
															width: double.infinity,
															child: ElevatedButton(
																onPressed: _loading ? null : _signInWithEmail,
																style: ElevatedButton.styleFrom(
																	padding: const EdgeInsets.symmetric(vertical: 14),
																	shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
																	backgroundColor: theme.colorScheme.primary,
																	foregroundColor: theme.colorScheme.onPrimary,
																),
																child: _loading
																		? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.onPrimary))
																		: Text('Đăng nhập', style: theme.textTheme.labelLarge),
															),
														),
														Align(
															alignment: Alignment.centerRight,
															child: TextButton(onPressed: _forgotPassword, child: const Text('Quên mật khẩu?')),
														
														),
													],
												),
											),

											  const SizedBox(height: 6),
											  Divider(color: theme.dividerColor),
											  const SizedBox(height: 6),

											// Social buttons
											Row(
												children: [
													Expanded(
														child: OutlinedButton.icon(
															onPressed: _loading ? null : _signInWithGoogle,
															icon: const Icon(Icons.g_mobiledata, size: 20),
															label: const Text('Google'),
															style: OutlinedButton.styleFrom(
																backgroundColor: theme.colorScheme.surface,
																foregroundColor: theme.colorScheme.onSurface,
																side: BorderSide(color: theme.dividerColor),
																shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
																padding: const EdgeInsets.symmetric(vertical: 12),
															),
														),
													),
													const SizedBox(width: 12),
													Expanded(
														child: ElevatedButton.icon(
															onPressed: _loading ? null : _signInWithGithub,
															icon: const Icon(Icons.code, size: 18),
															label: const Text('GitHub'),
															style: ElevatedButton.styleFrom(
																backgroundColor: isDark ? Colors.grey.shade800 : Colors.black,
																foregroundColor: Colors.white,
																elevation: 0,
																shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
																padding: const EdgeInsets.symmetric(vertical: 12),
															),
														),
													),
												],
											),

											const SizedBox(height: 14),
											Row(
												mainAxisAlignment: MainAxisAlignment.center,
												children: [
													const Text('Chưa có tài khoản? '),
													TextButton(onPressed: _navigateToRegister, child: const Text('Đăng ký')),
												],
											),
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

class _PlaceholderScreen extends StatelessWidget {
	final String title;
	const _PlaceholderScreen({Key? key, required this.title}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: Text(title)),
			body: Center(child: Text(title)),
		);
	}
}
