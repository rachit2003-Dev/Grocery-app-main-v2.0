import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Hero(tag: 'logo', child: Image.asset('asset/images/logo.jpeg')),
                const TextField(),
                const TextField(),
                const TextField(),
                const TextField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
