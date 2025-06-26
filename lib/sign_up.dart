import 'package:chess_app/components/textfield.dart';
import 'package:chess_app/sign_in.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 111, 78, 55),
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Column(
            children: [
              // logo
              Center(
                child: Image.asset(
                  'lib/images/logo.png',
                  height: 300,
                  width: 300,
                ),
              ),
              // Sign In Text
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Username
              MyTextfield(
                controller: usernameController,
                hintText: "Username",
                obscuretext: false,
              ),

              const SizedBox(height: 20),

              // Password
              MyTextfield(
                controller: passwordController,
                hintText: "Password",
                obscuretext: true,
              ),

              const SizedBox(height: 20),
              // Confirm Password
              MyTextfield(
                controller: confirmPasswordController,
                hintText: "Confirm Password",
                obscuretext: true,
              ),

              const SizedBox(height: 30),

              // Sign in button
              ElevatedButton(
                onPressed: () {
                  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                child: const Text("Sign Up",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),

              // Sign Up Text
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Already have an account? ',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => const SignIn())
                      );
                    }, 
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 8, 16, 100)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
