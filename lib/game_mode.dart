import 'package:chess_app/chess_board.dart';
import 'package:chess_app/components/input_name.dart';
import 'package:chess_app/play_with_computer.dart';
import 'package:chess_app/play_with_friend.dart';
import 'package:chess_app/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameMode extends StatefulWidget {
  const GameMode({super.key});

  @override
  State<GameMode> createState() => _GameModeState();
}

class _GameModeState extends State<GameMode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Game Mode',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 31, 28, 28),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Scrollable game cards
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Play with Computer
                  SizedBox(
                    width: 300,
                    height: 200,
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      color: const Color.fromARGB(255,192, 192, 192),
                      child: InkWell(
                        onTap: () {
                          final user = FirebaseAuth.instance.currentUser;
                          String email = user?.email ?? 'White';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayWithComputer(
                                whitePlayerEmail: email,
                                blackPlayerName: 'Computer',
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.computer,
                                  size: 50, color: Color.fromARGB(255, 46, 151, 29)),
                              SizedBox(height: 10),
                              Text(
                                'Play with Computer',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Play with Friend
                  SizedBox(
                    width: 300,
                    height: 200,
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      color: const Color.fromARGB(255,192, 192, 192),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => InputName(
                              onNameSubmitted: (playerName) {
                                Navigator.of(context).pop();
                                final user =
                                    FirebaseAuth.instance.currentUser;
                                String email = user?.email ?? 'White';
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlayWithFriend(
                                      blackPlayerName: playerName,
                                      whitePlayerEmail: email,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.person,
                                  size: 50, color: Color.fromARGB(255, 46, 151, 29)),
                              SizedBox(height: 10),
                              Text(
                                'Play with Friend',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Online Mode
                  SizedBox(
                    width: 300,
                    height: 200,
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      color: const Color.fromARGB(255,192, 192, 192),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChessBoard()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wifi, size: 50, color:  Color.fromARGB(255, 46, 151, 29)),
                              SizedBox(height: 10),
                              Text(
                                'Online Mode',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Footer at the bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 31, 28, 28),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(0, 0, 0, 0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Home
                GestureDetector(
                  onTap: () {
                  },
                  child: const Icon(Icons.home,
                      color: Colors.white, size: 40),
                ),
                // Profile
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyProfile()),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('lib/images/cat.jpeg'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
