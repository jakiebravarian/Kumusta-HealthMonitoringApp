import 'package:flutter/material.dart';
import 'package:project_app/providers/admin_provider.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:project_app/screens/splash_screen.dart';
import 'package:project_app/screens/welcome.dart';

import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

import '../screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => AuthProvider())),
        ChangeNotifierProvider(create: ((context) => AdminProvider())),
        ChangeNotifierProvider(create: ((context) => UserProvider())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo with Auth',
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const Welcome(),
        '/login': (context) => const LoginPage(),
        '/todo': (context) => const LoginPage(),
      },
    );
  }
}
