import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscuretext;
  final String? errorText;
  final FocusNode? focusNode;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscuretext,
    this.errorText,
    this.focusNode,
    });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: controller,
        obscureText: obscuretext,
        focusNode: focusNode,
        decoration: InputDecoration(
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          errorText: errorText,
        ),
      ),
    );
  }
}