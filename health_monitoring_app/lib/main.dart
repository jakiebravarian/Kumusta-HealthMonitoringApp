import 'package:flutter/material.dart';
import 'package:project_app/models/entry_model.dart';
import 'package:project_app/providers/admin_provider.dart';
import 'package:project_app/providers/entry_provider.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:project_app/screens/Entry.dart';
import 'package:project_app/screens/Homepage.dart';

import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

import '../screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';

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
        ChangeNotifierProvider(create: ((context) => EntryProvider())),
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
      title: 'Health Monitoring Application',
      // home: MainPage(),
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const Homepage(),
        '/login': (context) => const LoginPage(),
        '/addEntry': (context) => const HealthEntry(),
      },
    );
  }
}

// class MainPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Scaffold(
//           body: StreamBuilder<User?>(
//         stream: context.read<AuthProvider>().userStream,
//         builder: (context, snapshot) {
//           return LoginPage();
//         },
//       ));
// }
