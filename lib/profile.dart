import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  User? user;
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  // initializing user
  Future <void> _intializeUser() async{
     user = FirebaseAuth.instance.currentUser;
     if (mounted) {
       setState(() => user = null);
     }
  }

  // sign out method 
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      setState(() {
        user = null;
      });
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing out: $e" ),)
      );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Signed in as:\n${user!.email}"),
            MaterialButton(onPressed: _signOut,
            color: Colors.deepPurpleAccent,
            child: const Text(
              'Sign Out'
            )
            )
          ],
        ),
      ),
    );
  }
}