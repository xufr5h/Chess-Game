import 'package:chess_app/auth/sign_in.dart';
import 'package:chess_app/chat/chat_room.dart';
import 'package:chess_app/helper/online_status.dart';
import 'package:chess_app/profile/chessboard_theme.dart';
import 'package:chess_app/profile/game_stats.dart';
import 'package:chess_app/profile/offline_game_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class MyProfile extends StatefulWidget {
  final bool isDrawerOpen;
  final VoidCallback onCloseDrawer;
  final double drawerWidth;

  const MyProfile({
    super.key,
    required this.isDrawerOpen,
    required this.onCloseDrawer,
    this.drawerWidth = 250.0,
    });
  
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final User? user = FirebaseAuth.instance.currentUser;

// sign out method
  Future <void> _signOut() async{
    try {
      await ZegoUIKitPrebuiltCallInvitationService().uninit();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e'))
      );
    }
  }

  // delete account method
  Future <void> _deleteAccount() async {
    await user?.delete();
  }

  void _showSignOutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 35, 44, 49),
        title: const Text('Are you sure you want to sign out?', style: TextStyle(color: Colors.white, fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color:  Color.fromARGB(255, 72, 161, 58), fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              _signOut();
              Navigator.pop(context);
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 35, 44, 49),
        title: const Text('Are you sure you want to delete your account?', style: TextStyle(color: Colors.white, fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: Color.fromARGB(255, 72, 161, 58), fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              _deleteAccount();
              Navigator.pop(context);
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: widget.drawerWidth,
      color: const Color.fromARGB(255, 35, 44, 49),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('lib/images/cat.jpeg'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.email ?? 'Guest',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white54),
          ListTile(
            leading: const Icon(Icons.show_chart, color: Colors.white),
            title: const Text('Game Stats', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyStats()),
              );
            },
          ),

          // offline game records
          ListTile(
            leading: const Icon(Icons.history, color: Colors.white),
            title: const Text('Offline Game Records', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OfflineGameHistory()),
              );
            },
          ),

          // chat room
          ListTile(
            leading: const Image(image: AssetImage('lib/images/chat.png'), width: 24, height: 24, color: Colors.white,),
            title: const Text('Chat room', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ChatRoom()),
              );
            },
          ),

          // chess board theme
          ListTile(
            leading: const Image(image: AssetImage('lib/images/theme.png'), width: 24, height: 24, color: Colors.white,),
            title: const Text('Select Theme', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ChessboardTheme()),
              );
            },
          ),


          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text('Sign Out', style: TextStyle(color: Colors.white)),
            onTap: () => _showSignOutConfirmation(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
            onTap: () => _showDeleteAccountConfirmation(context),
          ),
        ],
      ),
    );
  }
}
 