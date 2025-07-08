import 'package:chess_app/auth/auth_page.dart';
import 'package:chess_app/helper/app_constants.dart';
import 'package:chess_app/helper/hive_helper.dart';
import 'package:chess_app/modes/game_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  // bool _zegoInitialized = false;

  // @override
  // void initState(){
  //   super.initState();
  //   _initZego();
  // }

  // Future<void> _initZego() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null && !_zegoInitialized) {
  //     await ZegoUIKit().init(
  //       appID: AppConstants.APP_ID,
  //       appSign: AppConstants.APP_SIGN,
  //     );
  //     setState(() {
  //       _zegoInitialized = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            loadGamesFromFirestore();
            return GameMode();
          }
          else {
            return AuthPage();
          }
        }
      ),
    );
  }
}