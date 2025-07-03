import 'package:chess_app/modes/chess_board.dart';
import 'package:chess_app/components/textfield.dart';
import 'package:chess_app/modes/game_mode.dart';
import 'package:chess_app/auth/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final VoidCallback showSignInPage;
  const SignUp({super.key, required this.showSignInPage});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  // manual sign up method
  Future<void> signUpMethod() async {
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();
  final confirmPassword = _confirmPasswordController.text.trim();

  if (password != confirmPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Passwords do not match')),
    );
    return;
  }

  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    final user = userCredential.user;

    if (user != null) {
      await createUserDoc(user);

      // Navigate to ChessBoard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GameMode()),
      );
    }
  } catch (e) {
    print('Error signing up: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sign up failed: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 111, 78, 55),
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
                  controller: _emailController,
                  hintText: "Username",
                  obscuretext: false,
                ),
            
                const SizedBox(height: 20),
            
                // Password
                MyTextfield(
                  controller: _passwordController,
                  hintText: "Password",
                  obscuretext: true,
                ),
            
                const SizedBox(height: 20),
            
                // confirm Password
                MyTextfield(
                  controller: _confirmPasswordController,
                  hintText: "Confirm Password",
                  obscuretext: true,
                ),
            
                const SizedBox(height: 30),
            
                // Sign in button
                ElevatedButton(
                  onPressed: signUpMethod,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  child: const Text("Sign Up",
                    style: TextStyle(fontSize: 20, color: Colors.white,),
                  ),
                ),
            
                 const SizedBox(height: 30),
                  // Or Text
                  const Text(
                    'OR',
                    style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 38, 35, 35), fontWeight: FontWeight.bold),
                  ),
                  // Continue with Google Button
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async{
                      await signInWithGoogle();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    child: const Text(
                      'Sign Up with Google',
                      style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 255, 255), ),
                    ),
                  ),
            
                // Sign In Text
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ',
                      style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: widget.showSignInPage, 
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 8, 16, 100), fontWeight: FontWeight.bold),
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
