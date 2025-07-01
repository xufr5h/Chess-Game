import 'package:chess_app/chess_board.dart';
import 'package:chess_app/components/input_name.dart';
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
    return  Scaffold(
      backgroundColor: const Color.fromARGB(255, 111, 78, 55),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Game Mode', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 111, 78, 55),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProfile()));
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('lib/images/cat.jpeg'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                height: 200,
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  color: const Color.fromARGB(255, 81, 39, 25),
                  child: InkWell(
                    onTap: (){
                        
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.computer, size: 50, color: const Color.fromARGB(255, 255, 255, 255)),
                          const SizedBox(height: 10),
                          const Text(
                            'Play with Computer',
                            style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // play with frined
              const SizedBox(height: 20),
               SizedBox(
                width: 300,
                height: 200,
                 child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  color: const Color.fromARGB(255, 81, 39, 25),
                  child: InkWell(
                  onTap: () {
                      print("Tapped Play with Friend");
                      showDialog(
                        context: context,
                        builder: (context) => InputName(
                          onNameSubmitted: (playerName) {
                            print("Name submitted: $playerName");
                            Navigator.of(context).pop();
                            final user = FirebaseAuth.instance.currentUser;
                            String email = user?.email ?? 'White';
                            print("Current user email: $email");
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
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person, size: 50, color: const Color.fromARGB(255, 255, 255, 255)),
                          const SizedBox(height: 10),
                          const Text(
                            'Play with Friend',
                            style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                             ),
               ),
        
              //  online mode
              SizedBox(
                width: 300,
                height: 200,
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  color: const Color.fromARGB(255, 81, 39, 25),
                  child: InkWell(
                    onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ChessBoard()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi, size: 50, color: const Color.fromARGB(255, 255, 255, 255)),
                          const SizedBox(height: 10),
                          const Text(
                            'Online Mode',
                            style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                          )
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
    );
  }
}