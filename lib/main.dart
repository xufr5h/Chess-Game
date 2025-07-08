import 'package:chess_app/auth/main_page.dart';
import 'package:chess_app/helper/app_constants.dart';
import 'package:chess_app/helper/offline_game_record.dart';
import 'package:chess_app/helper/user_score.dart';
import 'package:chess_app/auth/sign_in.dart';
import 'package:chess_app/auth/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; 
import 'package:hive/hive.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initializing the hive
  await Hive.initFlutter();
  // regsitering the adaper
  Hive.registerAdapter(OfflineGameRecordAdapter());

  // wrapping the app with ChangeNotifierProvider
  runApp(
    ChangeNotifierProvider(
      create:(context) => UserScore(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}