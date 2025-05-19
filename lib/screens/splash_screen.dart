import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_notification/services/auth_service.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 2)),
      builder: (context, snapshot) {
        if (auth.user != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/home');
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/auth');
          });
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}