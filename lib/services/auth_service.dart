import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notification/services/notification_services.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  User? get user => _user;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      await NotificationServices.showNotification(
        title: 'Registrasi Berhasil',
        body: 'Akun Anda berhasil dibuat.',
        type: NotificationType.success,
      );
    } on FirebaseAuthException catch (e) {
      await NotificationServices.showNotification(
        title: 'Registrasi Gagal',
        body: e.message ?? 'Terjadi kesalahan saat registrasi.',
        type: NotificationType.error,
      );
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      await NotificationServices.showNotification(
        title: 'Login Berhasil',
        body: 'Selamat datang kembali!',
        type: NotificationType.success,
      );
    } on FirebaseAuthException catch (e) {
      await NotificationServices.showNotification(
        title: 'Login Gagal',
        body: e.message ?? 'Terjadi kesalahan saat login.',
        type: NotificationType.error,
      );
      rethrow;
    }
  }
  Future<void> signOut() async {
    await _auth.signOut();
  }
}