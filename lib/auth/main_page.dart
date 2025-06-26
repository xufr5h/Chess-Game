import 'package:chess_app/auth/auth_page.dart';
import 'package:chess_app/chess_board.dart';
import 'package:chess_app/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot){
          if (snapshot.hasData) {
            return ChessBoard();
          }
          else {
            return AuthPage();
          }
        }
      ),
    );
  }
}