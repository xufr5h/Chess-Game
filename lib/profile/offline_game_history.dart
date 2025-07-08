import 'package:chess_app/helper/hive_helper.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:chess_app/helper/offline_game_record.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart'; 

class OfflineGameHistory extends StatefulWidget {
  const OfflineGameHistory({super.key});

  @override
  State<OfflineGameHistory> createState() => _OfflineGameHistoryState();
}

class _OfflineGameHistoryState extends State<OfflineGameHistory> {
  late Future<Box<OfflineGameRecord>> _gameHistoryBoxFuture;

  @override 
  void initState(){
    super.initState();
    _gameHistoryBoxFuture = _gameHistoryBox();
   }

  Future<Box<OfflineGameRecord>> _gameHistoryBox() async {
    await loadGamesFromFirestore();
    return await openUserHistoryBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Offline Game History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Box<OfflineGameRecord>>(
        future: _gameHistoryBoxFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            );
          }
          final box = snapshot.data!;
          return ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Box<OfflineGameRecord> box, _) {
              if (box.isEmpty) {
                return const Center(
                  child: Text(
                    'No Offline Game History Yet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              final games = box.values.toList();
              games.sort((a, b) => b.playedAt.compareTo(a.playedAt));

              return ListView.builder(
                itemCount: games.length,
                itemBuilder: (context, index) {
                  final game = games[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ListTile(
                      leading: const Icon(Icons.history, color: Colors.green),
                      title: Row(
                        children: [
                          Text(
                            game.result.trim(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.emoji_events,
                            color: Colors.yellow[700],
                            size: 30,
                          ),
                        ],
                      ),
                      subtitle: Text(
                        'Players: ${game.player1} vs ${game.player2}\n'
                        'Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(game.playedAt)}',
                        style: const TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}