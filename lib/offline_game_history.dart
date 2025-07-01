import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class OfflineGameHistory extends StatefulWidget {
  const OfflineGameHistory({super.key});

  @override
  State<OfflineGameHistory> createState() => _OfflineGameHistoryState();
}

class _OfflineGameHistoryState extends State<OfflineGameHistory> {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<OfflineGameHistory>('humanGameRecords');
    // showing the latest game first
    final games = box.values.toList().reversed.toList();
    return  Scaffold(
      backgroundColor: const Color.fromARGB(255, 111, 78, 55),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Offline Game History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: const Color.fromARGB(255, 111, 78, 55
      ),
      ),
    );
  }
}