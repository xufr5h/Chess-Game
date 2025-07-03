import 'package:chess_app/profile/game_stats.dart';
import 'package:chess_app/profile/offline_game_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final bool isDrawerOpen;
  final VoidCallback onCloseDrawer;
  final double drawerWidth;

   CustomDrawer({
    super.key,
    required this.isDrawerOpen,
    required this.onCloseDrawer,
    this.drawerWidth = 300,
  });

    final User? user = FirebaseAuth.instance.currentUser;
    // sign out method
    void _signOut() async {
      await FirebaseAuth.instance.signOut();
    }

    // delete account method
    void _deleteAccount() async {
      await  user?.delete();
    }


  @override
  Widget build(BuildContext context) {

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      right: isDrawerOpen ? 0 : -drawerWidth,
      top: 0,
      bottom: 0,
      child: Container(
        width: drawerWidth,
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
      ),
    );
  }

  void _showSignOutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 81, 39, 25),
        title: const Text('Are you sure you want to sign out?', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              _signOut();
              Navigator.pop(context);
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 81, 39, 25),
        title: const Text('Are you sure you want to delete your account?', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              _deleteAccount();
              Navigator.pop(context);
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}