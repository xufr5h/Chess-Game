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
  late Box<OfflineGameRecord> _gameHistoryBox;

  @override 
  void initState(){
    super.initState();
    _gameHistoryBox = Hive.box<OfflineGameRecord>('humanGameRecords');
   }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Offline Game History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: const Color.fromARGB(255, 31, 28, 28),
      ),
      body: ValueListenableBuilder(
        valueListenable: _gameHistoryBox.listenable(), 
        builder: (context, Box<OfflineGameRecord> box, _){
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No Offline Game History Yet',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          }

          final games = box.values.toList();
          games.sort((a, b) => b.playedAt.compareTo(a.playedAt)); // Sort by playedAt in descending order

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index){
              final game = box.getAt(index)!;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListTile(
                  leading: const Icon(Icons.history, color: Colors.green),
              title: Text(
                '${game.player1} vs ${game.player2}', 
                style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    'Result: ${game.result}\n'
                    'Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(game.playedAt)}\n',
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
              )
              );
            }
          );
        }
        
        ),
    );
  }
}