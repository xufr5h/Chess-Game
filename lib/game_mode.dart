import 'package:chess_app/components/input_name.dart';
import 'package:chess_app/play_with_friend.dart';
import 'package:flutter/material.dart';

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
      ),
      body: Center(
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
                  onTap: (){
                    showDialog(
                      context: context, 
                      builder: (context) => InputName(
                        onNameSubmitted: (playerName){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => 
                            // Navigate to the game screen with the player name
                            PlayWithFriend(playerName: playerName)
                          ));
                        },
                      )
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
          ],
        ),
      ),
    );
  }
}