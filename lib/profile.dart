import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Signed in as:\n${user!.email}"),
            MaterialButton(onPressed: () async{
              await FirebaseAuth.instance.signOut();
            },
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