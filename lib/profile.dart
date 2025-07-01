import 'package:chess_app/game_mode.dart';
import 'package:chess_app/offline_game_history.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'helper/user_score.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
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

  // statistics card builder
  Widget _buildStatColumn(String label, String value){
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 111, 78, 55),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 111, 78, 55),
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
              color: const Color.fromARGB(255, 81, 39, 25),
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
                        color:  Color.fromARGB(255, 255, 255, 255)
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
                        color: Color.fromARGB(255, 255, 255, 255),
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

            // Game Mode Button
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: (){
                Navigator.push(context, 
                  MaterialPageRoute(
                    builder: (context) => const GameMode(),
                  ),
                );
              },
              color: Colors.black,
              child: const Text(
                'Select Game Mode',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),

            // Sign out button
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: _signOut,
              color: Colors.black,
              child:  Text('Sign Out',
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