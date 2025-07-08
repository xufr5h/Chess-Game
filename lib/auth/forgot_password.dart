import 'package:chess_app/components/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  // disposing the controller
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // creating the forgot password method
  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance.
        sendPasswordResetEmail(email: _emailController.text.trim());
        showDialog(
        context: context, 
        builder: (context) =>
        AlertDialog(
          content: Text('The password reset link has been sent to ${_emailController.text.trim()}. Please check your email.'),
        )
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context, 
        builder: (context) =>
        AlertDialog(
          content: Text(e.message.toString()),
        )
      );
    }

  }

  @override
  void initState(){
    super.initState();
    FirebaseAuth.instance.setLanguageCode('en');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 55),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        backgroundColor: const Color.fromARGB(255, 31, 28, 28),
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Enter your email to reset your password.',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          // email textfield
          const SizedBox(height: 30),
          MyTextfield(
            controller: _emailController, 
            hintText: 'Enter your email', 
            obscuretext: false,
            ),

            // reset password button
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: resetPassword, 
              child: Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
          ),
        ],
      ),
    );
  }
}