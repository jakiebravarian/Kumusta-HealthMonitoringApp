import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:project_app/providers/admin_provider.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:project_app/providers/auth_provider.dart';

import 'package:project_app/screens/signup_login.dart';
import 'package:project_app/screens/splash_screen.dart';
import 'package:project_app/screens/welcome.dart';
import 'package:project_app/screens/login.dart';

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
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Kumusta',
        initialRoute: '/',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.white,
            filled: true,
            focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: Color(0xFF432C81)),
                borderRadius: BorderRadius.circular(16)),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: Color(0xFFEDECF4)),
                borderRadius: BorderRadius.circular(16)),
            errorBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: Color(0xFFEB5858)),
                borderRadius: BorderRadius.circular(16)),
            border: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: Color(0xFFEDECF4)),
                borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            hintStyle: GoogleFonts.raleway(
                textStyle: const TextStyle(
                    color: Color(0xFF7B6BA8),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.5)),
            errorStyle: GoogleFonts.inter(
                textStyle: const TextStyle(
                    color: Color(0xFFEB5858),
                    fontSize: 14,
                    fontWeight: FontWeight.w400)),
          ),
        ),
        routes: {
          '/': (context) => const SplashScreen(),
          '/welcome': (context) => const Welcome(),
          '/signup-login': (context) => const SignUpLogin(),
          '/login': (context) => const LoginPage(),
          '/todo': (context) => const LoginPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == SignUpLogin.routename) {
            return MaterialPageRoute(
              builder: (context) {
                return SignUpLogin(
                  userType: settings.arguments as String,
                );
              },
            );
          }
          return null;
        });
  }
}
