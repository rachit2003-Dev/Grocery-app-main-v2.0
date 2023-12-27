import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/providers/location_provider.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/login_screen.dart';
import 'package:flutter_app/screens/map_screen.dart';
import 'package:flutter_app/screens/signup_screen.dart';
import 'package:flutter_app/screens/splash_screen.dart';
import 'package:flutter_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
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
      theme: ThemeData(primaryColor: Colors.deepPurpleAccent),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=>const SplashScreen(),
        HomeScreen.id:(context)=>const HomeScreen(),
        WelcomeScreen.id:(context)=>const WelcomeScreen(),
        MapScreen.id:(context)=>const MapScreen(),
        LoginScreen.id:(context)=>const LoginScreen(),
        SignUPScreen.id:(context)=>const SignUPScreen(),
      },
    );
  }
}
