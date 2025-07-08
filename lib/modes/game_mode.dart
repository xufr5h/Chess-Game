import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chess_app/modes/chess_board.dart';
import 'package:chess_app/components/input_name.dart';
import 'package:chess_app/modes/play_with_computer.dart';
import 'package:chess_app/modes/play_with_friend.dart';
import 'package:chess_app/profile/profile.dart';

class GameMode extends StatefulWidget {
  const GameMode({super.key});

  @override
  State<GameMode> createState() => _GameModeState();
}

class _GameModeState extends State<GameMode> {
  bool _isDrawerOpen = false;

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
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Main content area
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGameModeCard(
                      icon: Icons.computer,
                      label: 'Play with Computer',
                      onTap: () {
                        final user = FirebaseAuth.instance.currentUser;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayWithComputer(
                              whitePlayerEmail: user?.email ?? 'White',
                              blackPlayerName: 'Computer',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildGameModeCard(
                      icon: Icons.person,
                      label: 'Play with Friend',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => InputName(
                            onNameSubmitted: (name) {
                              Navigator.pop(context);
                              final user = FirebaseAuth.instance.currentUser;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlayWithFriend(
                                    blackPlayerName: name,
                                    whitePlayerEmail: user?.email ?? 'White',
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildGameModeCard(
                      icon: Icons.wifi,
                      label: 'Online Mode',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChessBoard(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Overlay when drawer is open
          if (_isDrawerOpen)
            GestureDetector(
              onTap: () => setState(() => _isDrawerOpen = false),
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.black54,
              ),
            ),

          // Sliding drawer
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            right: _isDrawerOpen ? 0 : -300,
            top: 0,
            bottom: 0,
            width: 300,
            child: Material(
              elevation: 16,
              color: const Color.fromARGB(255, 35, 44, 49),
              child: MyProfile(
                isDrawerOpen: _isDrawerOpen,
                onCloseDrawer: () => setState(() => _isDrawerOpen = false),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildGameModeCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 300,
      height: 180,
      child: Card(
        elevation: 4,
        color: const Color.fromARGB(255, 192, 192, 192),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: const Color.fromARGB(255, 46, 151, 29),
                ),
                const SizedBox(height: 15),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 31, 28, 28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.home, size: 32, color: Colors.white),
            onPressed: () {},
          ),
          GestureDetector(
            onTap: () => setState(() => _isDrawerOpen = !_isDrawerOpen),
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('lib/images/cat.jpeg'),
            ),
          ),
        ],
      ),
    );
  }
}