import 'package:evaluvatin_cloud_gallery/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/TextFormField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 100, right: 180),
            child: Text(
              "Log In",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          CustomTextFormField(
            controller: _emailController,
            hintText: 'Email',
            prefixIcon: Icons.email,
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: _passwordController,
            hintText: 'Password',
            prefixIcon: Icons.lock,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              final authenticationInstance = FirebaseAuth.instance;

              try {
                final ref = await authenticationInstance
                    .signInWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text,
                );

                //  login state to SharedPreferences
                final SharedPreferences prefs =
                await SharedPreferences.getInstance();
                prefs.setBool('isLoggedIn', true);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged in successfully'),
                    duration: Duration(seconds: 2), // Optional: set duration
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              } catch (e) {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Invalid email or password'),
                  ),
                );
              }
            },
            child: const Text(
              "Log In",
              style: TextStyle(color: Colors.white),
            ),
          ),

        ],
      ),
    );
  }
}
