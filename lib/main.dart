import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth_screen.dart';
import 'screens/item_list_screen.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/notification_services.dart';

Future<void> requestNotificationPermission() async {
  await AwesomeNotifications().requestPermissionToSendNotifications();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationServices.initializeAwesomeNotifications();
  await requestNotificationPermission();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD with Notifications',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const ItemListScreen(),
      },
    );
  }
}