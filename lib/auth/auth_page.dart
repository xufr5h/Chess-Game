import 'package:chess_app/auth/sign_in.dart';
import 'package:chess_app/auth/sign_up.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // initially showing the sign in page
  bool showSignIn = true;
  void toggleScreens (){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(showResigsterPage: toggleScreens);
    } else {
      return SignUp(showSignInPage: toggleScreens);
    }
  }
}