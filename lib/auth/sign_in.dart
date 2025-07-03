import 'package:chess_app/modes/chess_board.dart';
import 'package:chess_app/components/textfield.dart';
import 'package:chess_app/auth/forgot_password.dart';
import 'package:chess_app/modes/game_mode.dart';
import 'package:chess_app/auth/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../firebase_options.dart'; 


class SignIn extends StatefulWidget {
  final VoidCallback showResigsterPage;
  const SignIn({super.key, required this.showResigsterPage});

  @override
  State<SignIn> createState() => _SignInState();
  
}

class _SignInState extends State<SignIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // creating user doc
  Future<void> createUserDoc(User user) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      await userDoc.set({
        'email': user.email,
        'uid': user.displayName ?? user.uid,
        'gamesPlayed': 0,
        'gamesWon': 0,
        'gamesLost': 0,
        'gamesDrawn': 0,
        'rating': 1200, 
      });
    }
  }

  // google sign in method 
  Future <UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        await createUserDoc(user);
        // Navigating to chessboard
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute (builder: (context) => const GameMode())
        );
      }
      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
    }
    return null;
  }

  // manual sign in method
  Future signInMethod() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(), 
        password: _passwordController.text.trim(),
      );
      final user = userCredential.user;
      if (user != null) {
        await createUserDoc(user);
        // Navigating to chessboard
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute (builder: (context) => const GameMode())
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password'))
        );
      }
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 28, 28),
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Container(
            margin: EdgeInsets.only(top: screenHeight * 0.000002),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // logo
                Center(
                  child: Image.asset(
                    'lib/images/logo.png',
                    height: 300,
                    width: 300,
                    color: Colors.white,
                  ),
                ),
                // Sign In Text
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 40,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
            
                const SizedBox(height: 20),
            
                // Username
                MyTextfield(
                  controller: _emailController,
                  hintText: "Email",
                  obscuretext: false,
                ),
            
                const SizedBox(height: 20),
            
                // Password
                MyTextfield(
                  controller: _passwordController,
                  hintText: "Password",
                  obscuretext: true,
                ),

                // forgot password
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const ForgotPassword()));
                        },
                        child: Text('Forgot Password?',
                          style: TextStyle(fontSize: 16, color:  Color.fromARGB(255, 20, 102, 255), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
            
                const SizedBox(height: 10),
            
                // Sign in button
                ElevatedButton(
                  onPressed: signInMethod,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  child: const Text("Sign In",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
            
                const SizedBox(height: 20),
                // Or Text
                const Text(
                  'OR',
                  style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                ),
                // Continue with Google Button
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async{
                    await signInWithGoogle();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  child: const Text(
                    'Continue with Google',
                    style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
            
                // Sign Up Text
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account? ',
                      style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                    GestureDetector(
                      onTap: widget.showResigsterPage,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 20, 102, 255)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
