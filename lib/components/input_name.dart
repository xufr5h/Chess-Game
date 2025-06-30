import 'package:chess_app/components/textfield.dart';
import 'package:flutter/material.dart';

class InputName extends StatefulWidget {
  final Function(String) onNameSubmitted;

  const InputName({super.key, required this.onNameSubmitted});

  @override
  State<InputName> createState() => _InputNameState();
}

class _InputNameState extends State<InputName> {
  final TextEditingController _nameController = TextEditingController();
  String? _errorText;

  // method to submit the name 
  void _submitName(){
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorText = "Name cannot be empty!";
      });
    return;
    } 
    widget.onNameSubmitted(name);
    Navigator.of(context).pop(); 
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 81, 39, 25),
      content: SizedBox(
        width: 300,
        height: 150,
        child: Column(
          children: [
            const SizedBox(height: 60),
            MyTextfield(
              controller: _nameController, 
              hintText: 'Enter your name', 
              obscuretext: false,
              errorText: _errorText,
              ),
          ],
        ),
      ),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: const Text('Cancel', style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            ),
            ),
          ),
          ElevatedButton(
            onPressed: _submitName, 
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            ),
            child: const Text('Submit'),
          ),
        ],
    );
  }
}