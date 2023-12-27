import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  static const String id= 'home-screen';

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
        body: Center(
      child: Positioned(
        top: 0.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurpleAccent,
              ),
              onPressed: () {
                auth.error='';
                FirebaseAuth.instance.signOut().then((value){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>const WelcomeScreen(),
                  ));
                });
              },
              child: const Text('Sign Out'),
            ),
            ElevatedButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurpleAccent,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, WelcomeScreen.id);
              },
              child: const Text('Home Screen'),
            ),
          ],
        ),
      ),
    ));
  }
}
