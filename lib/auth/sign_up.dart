import 'package:chess_app/components/textfield.dart';
import 'package:chess_app/helper/online_status.dart';
import 'package:chess_app/modes/game_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool isEmailLoading = false;
  bool isGoogleLoading = false;

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
        'uid':  user.uid,
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
    setState(() {
      isGoogleLoading = true;
      setUserOnlineStatus(true);
    });
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
    } finally {
      setState(() {
        isGoogleLoading = false;
      });
    }
    return null;
  }

  // manual sign up method
  Future<void> signUpMethod() async { 
  setState(() {
    isEmailLoading = true;
    setUserOnlineStatus(true);
  });
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();
  final confirmPassword = _confirmPasswordController.text.trim();

  if (password != confirmPassword) {
    setState(() {
      isEmailLoading = false;
    });
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
  } finally {
    setState(() {
      isEmailLoading = false;
    });
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
                  'Sign Up',
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
                    backgroundColor: const Color.fromARGB(255, 54, 138, 56),
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  child: isEmailLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    ) :
                  const Text("Sign Up",
                    style: TextStyle(fontSize: 20, color: Colors.white,),
                  ),
                ),
            
                 const SizedBox(height: 30),
                  // Or Text
                  const Text(
                    'OR',
                    style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                  ),
                  // Continue with Google Button
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async{
                      await signInWithGoogle();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  const Color.fromARGB(255, 54, 138, 56),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    child: isGoogleLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    ) :
                    const Text(
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
                      style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: widget.showSignInPage, 
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 20, 102, 255), fontWeight: FontWeight.bold),
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
