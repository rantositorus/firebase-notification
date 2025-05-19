import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_notification/services/auth_service.dart';
import 'package:firebase_notification/widgets/custom_textfield.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    final auth = Provider.of<AuthService>(context, listen: false);
    auth.addListener(() {
      if (auth.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      if (_isLogin) {
        await auth.signIn(_emailController.text, _passwordController.text);
      } else {
        await auth.signUp(_emailController.text, _passwordController.text);
      }
      if (auth.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email harus diisi';
                  }
                  if (!value.contains('@')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password harus diisi';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(_isLogin ? 'Login' : 'Register'),
              ),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin
                    ? 'Belum punya akun? Register'
                    : 'Sudah punya akun? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}