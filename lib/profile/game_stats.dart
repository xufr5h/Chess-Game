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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Game Statistics',
          style: TextStyle(color: Colors.white),
          ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
        ],
      ),
    );
  }
}