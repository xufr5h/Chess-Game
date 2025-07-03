import 'package:chess_app/modes/game_mode.dart';
import 'package:chess_app/profile/offline_game_history.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../helper/user_score.dart';

class MyStats extends StatefulWidget {
  const MyStats({super.key});

  @override
  State<MyStats> createState() => _MyStatsState();
}

class _MyStatsState extends State<MyStats> {
  // autheticating the user
  User? user;
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    // calling the stats method
    if (user != null) {
      Future.microtask((){
        Provider.of<UserScore>(context, listen: false)
          .loadUserStatsFirestore(user!.uid);
      });
    }
  }

    // sign out method
  Future <void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: $e')),
        );
      }
    }
  }

  // delete account 
  Future<void> _deleteAccount() async {
    try {
      await user?.delete();
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting account: $e')),
        );
      }
    }
  }

  // statistics card builder
  Widget _buildStatColumn(String label, String value){
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        )
      ],
    );
  }

  // signout confirmation dialog
  void _signOutConfirmation(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 81, 39, 25),
        title: const Text('Are you sure you want to sign out?', style: TextStyle(color: Colors.white),),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            }, 
          child: const Text('No', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
              _signOut();
            }, 
            child: const Text('Yes', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),)),
        ],
      )
    );
  }

  // delete account confirmation dialog
  void _deleteAccountConfirmation(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 81, 39, 25),
        title: const Text('Are you sure you want to delete your account?', style: TextStyle(color: Colors.white),),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            }, 
          child: const Text('No', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
              _deleteAccount();
            }, 
            child: const Text('Yes', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),)),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 31, 28, 28),
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.white),
          ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // profile picture
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('lib/images/cat.jpeg'),
            ),

            // User name 
            Text(
              "${user?.email}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: const Color.fromARGB(255, 255, 255, 255)
              ),
            ),
            // DISPLAY ELO RATING
            const SizedBox(height: 10),
            Text(
              '${context.watch<UserScore>().rating} elo',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255)
              ),
            ),
            // statistics card
            Card(
              color: const Color.fromARGB(255,192, 192, 192),
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Chess Statistics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:  Color.fromARGB(255, 7, 95, 13)
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Games Played
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn('Played', context.watch<UserScore>().gamesPlayed.toString()),
                        _buildStatColumn('Won', context.watch<UserScore>().gamesWon.toString()),
                        _buildStatColumn('Drawn', context.watch<UserScore>().gamesDrawn.toString()),
                        _buildStatColumn('Lost', context.watch<UserScore>().gamesLost.toString()),
                        
                      ],
                    ),
                    const SizedBox(height: 10),
                    // total score
                    Text(
                      'Win Rate: ${context.watch<UserScore>().winRate.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    )
                  ],
                ),
              ),
            ),
            
            // Offline Game History Button
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: (){
                Navigator.push(context, 
                  MaterialPageRoute(
                    builder: (context) => const OfflineGameHistory(),
                  ),
                );
              },
              color: Colors.black,
              child: const Text(
                'Offline Game History',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            
            // Sign out button
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: _signOutConfirmation,
              color: Colors.black,
              child:  Text('Sign Out',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),

            // delete account button
            // Sign out button
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: _deleteAccountConfirmation,
              color: Colors.red,
              child:  Text(
                'Delete Account?',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}