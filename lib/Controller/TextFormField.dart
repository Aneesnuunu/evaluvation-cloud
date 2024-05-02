import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;

  const CustomTextFormField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black),
          prefixIcon: Icon(prefixIcon, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
    );
  }
}
