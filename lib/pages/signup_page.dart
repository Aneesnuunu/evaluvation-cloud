import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Controller/TextFormField.dart';
import 'login_screen.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});


  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 100, right: 180),
              child: Text(
                "Sign Up",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            CustomTextFormField(
              controller: _nameController,
              hintText: 'Name',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: _phoneController,
              hintText: 'Phone Number',
              prefixIcon: Icons.phone,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () async{
              final authenticationInstance = FirebaseAuth.instance;
              final dbInstance = FirebaseFirestore.instance;
              try {
                final ref = await authenticationInstance
                    .createUserWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text);

                var userId = ref.user!.uid;

                var data = {
                  "name": _nameController.text,
                  "phone Number": _phoneController.text,
                  "email": _emailController.text,
                  "password": _passwordController
                };

                var dbRef =
                dbInstance.collection("user").doc(userId).set(data);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registration successfully'),
                    duration:
                    Duration(seconds: 2),
                  ),
                );

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
              } catch (e) {
                print(e);
              }


            },
                child: const Text("Submit")),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 90,
                ),
                const Text(
                  "Already a member ?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: const Text(
                      "Log In",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
