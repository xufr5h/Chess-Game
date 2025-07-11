import 'package:chess_app/auth/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chess_app/helper/app_constants.dart';
import 'package:chess_app/helper/offline_game_record.dart';
import 'package:chess_app/helper/theme_provider.dart';
import 'package:chess_app/helper/user_score.dart';
import 'package:chess_app/auth/sign_in.dart';
import 'package:chess_app/auth/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'firebase_options.dart'; 
import 'package:hive/hive.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initializing zego uikit signaling plugin
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: AppConstants.APP_ID,
      appSign: AppConstants.APP_SIGN,
      userID: currentUser.uid,
      userName: currentUser.email ?? 'Guest',
      plugins: [
        ZegoUIKitSignalingPlugin(),
      ]
    );
        ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  }

  // initializing the hive
  await Hive.initFlutter();
  // regsitering the adaper
  Hive.registerAdapter(OfflineGameRecordAdapter());

  // wrapping the app with ChangeNotifierProvider
  runApp(
    MultiProvider(
      providers:[
         ChangeNotifierProvider(
        create:(context) => UserScore()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
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