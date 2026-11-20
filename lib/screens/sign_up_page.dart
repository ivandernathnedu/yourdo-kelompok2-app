import 'package:flutter/material.dart';

import '../data/quest_repository.dart';
import '../services/auth_service.dart';
import '../services/quest_randomizer.dart';
import '../theme/app_colors.dart';
import '../widgets/auth_form.dart';
import 'main_shell.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
    required this.repository,
    required this.randomizer,
    required this.authService,
  });

  final QuestRepository repository;
  final QuestRandomizer randomizer;
  final AuthService authService;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _isLoading = false;
  String? _usernameError;
  String? _passwordError;
  String? _statusMessage;
  bool _isError = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validate() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    String? usernameError;
    String? passwordError;

    if (username.isEmpty) {
      usernameError = 'Username wajib diisi';
    }
    if (password.isEmpty) {
      passwordError = 'Password wajib diisi';
    }

    setState(() {
      _usernameError = usernameError;
      _passwordError = passwordError;
      _statusMessage = null;
      _isError = false;
    });

    return usernameError == null && passwordError == null;
  }

  Future<void> _submit() async {
    if (_isLoading) return;
    if (!_validate()) return;

    setState(() {
      _isLoading = true;
      _statusMessage = 'Memproses pendaftaran...';
      _isError = false;
    });

    final result = await widget.authService.signUp(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (!result.success) {
      setState(() {
        _isLoading = false;
        _isError = true;
        _statusMessage = result.message ?? 'Sign up gagal';
      });
      return;
    }

    setState(() {
      _isLoading = false;
      _isError = false;
      _statusMessage = 'Pendaftaran berhasil';
    });

    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => MainShell(
          repository: widget.repository,
          randomizer: widget.randomizer,
          authService: widget.authService,
        ),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AuthForm(
          title: 'Sign up',
          actionLabel: 'SIGN UP',
          footerPrompt: 'Already have an account? ',
          footerActionLabel: 'Login',
          usernameController: _usernameController,
          passwordController: _passwordController,
          showPassword: _showPassword,
          onToggleShowPassword: (value) {
            setState(() => _showPassword = value ?? false);
          },
          onSubmit: _submit,
          onFooterTap: () => Navigator.of(context).pop(),
          isLoading: _isLoading,
          statusMessage: _statusMessage,
          isError: _isError,
          usernameError: _usernameError,
          passwordError: _passwordError,
        ),
      ),
    );
  }
}
