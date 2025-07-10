import 'package:chess_app/helper/chess_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chess_app/helper/theme_provider.dart';

class ChessboardTheme extends StatelessWidget {
  const ChessboardTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      appBar: AppBar(
        title: const Text(
          'Chessboard Theme',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        itemCount: availableThemes.length,
        itemBuilder: (context, index) {
          final theme = availableThemes[index];
          final isSelected = themeProvider.currentTheme == theme;

          return AnimatedScale(
            scale: isSelected ? 1.02 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: () {
                themeProvider.setTheme(theme);
              },
              child: Card(
                color: isSelected
                    ? Colors.green.withAlpha(120)
                    : Colors.white.withAlpha(60),
                elevation: isSelected ? 8.0 : 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(
                    color: isSelected ? Colors.green : Colors.transparent,
                    width: 2.0,
                  ),
                ),
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Semantics(
                  label: 'Theme: ${theme.name}, ${isSelected ? "selected" : "not selected"}',
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Theme preview (small chessboard-like grid)
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: const Color.fromARGB(255, 218, 214, 214), width: 1.0),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: theme.lightSquareColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: theme.darkSquareColor,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: theme.darkSquareColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: theme.lightSquareColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        // Theme name
                        Expanded(
                          child: Text(
                            theme.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.white70,
                            ),
                          ),
                        ),
                        // Selected indicator
                        if (isSelected)
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green.withAlpha(120),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}