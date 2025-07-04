import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 192, 192, 192),
          borderRadius: BorderRadius.circular(12)
        ),
        child: Row(
          children: [
            // icon
            Icon(Icons.person, color: Colors.black, size: 30),
            const SizedBox(width: 10),
            // text
            Text(text, style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            )),
          ],
        ),
      ),
    );
  }
}