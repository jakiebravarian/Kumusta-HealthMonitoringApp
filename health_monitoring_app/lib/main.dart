import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_app/providers/log_provider.dart';
import 'package:project_app/screens/Login-SignUp/done_signup.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:project_app/providers/admin_provider.dart';
import 'package:project_app/providers/entry_provider.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:project_app/providers/auth_provider.dart';

import 'package:project_app/screens/Student/Entry.dart';
import 'package:project_app/screens/Login-SignUp/signup_login.dart';
import 'package:project_app/screens/Login-SignUp/splash_screen.dart';
import 'package:project_app/screens/Login-SignUp/welcome.dart';
import 'package:project_app/screens/Login-SignUp/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => LogsProvider())),
        ChangeNotifierProvider(create: ((context) => AuthProvider())),
        ChangeNotifierProvider(create: ((context) => AdminProvider())),
        ChangeNotifierProvider(create: ((context) => UserProvider())),
        ChangeNotifierProvider(create: ((context) => EntryProvider())),
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
        debugShowCheckedModeBanner: false,
        title: 'Kumusta',
        initialRoute: '/',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFFEDECF4),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            unselectedIconTheme: IconThemeData(
              color: Color(0xFFA095C1),
            ),
            selectedIconTheme: IconThemeData(
              color: Color(0xFF432C81),
            ),
          ),
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
          '/done-signup': (context) => const DoneSignup(),
          '/addEntry': (context) => const HealthEntry(),
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
          if (settings.name == LoginPage.routename) {
            return MaterialPageRoute(
              builder: (context) {
                return LoginPage(
                  userType: settings.arguments as String,
                );
              },
            );
          }
          return null;
        });
  }
}
