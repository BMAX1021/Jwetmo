import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class WordItem {
  final String word;
  final String hint;

  const WordItem(this.word, this.hint);
}

final List<WordItem> words = [
  WordItem("BONJOU", "Se yon mo pou salye moun"),
  WordItem("FLUTTER", "Framework pou devlopman mobil"),
  WordItem("LEKOL", "Kote elèv aprann"),
  WordItem("LIV", "Ou li li pou aprann"),
  WordItem("PYTHON", "Langaj pwogramasyon"),
];

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Random _random = Random();

  late WordItem current;
  late List<bool> revealed;

  int chances = 5;
  int gameId = 0;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    current = words[_random.nextInt(words.length)];
    revealed = List.filled(current.word.length, false);
    chances = 5;
    gameId++;
    setState(() {});
  }

  void _guessLetter(String letter) {
    bool found = false;

    for (int i = 0; i < current.word.length; i++) {
      if (current.word[i] == letter) {
        revealed[i] = true;
        found = true;
      }
    }

    if (!found) chances--;

    setState(() {});

    _checkResult();
  }

  void _checkResult() {
    if (revealed.every((e) => e)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            win: true,
            word: current.word,
            onRestart: _startGame,
          ),
        ),
      );
    } else if (chances <= 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            win: false,
            word: current.word,
            onRestart: _startGame,
          ),
        ),
      );
    }
  }

  String get displayWord {
    String text = "";
    for (int i = 0; i < current.word.length; i++) {
      text += revealed[i] ? "${current.word[i]} " : "* ";
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4FACFE),
              Color(0xFF00F2FE),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Affichage du mot avec lettres révélées
                Text(
                  displayWord,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Indice
                Text(
                  "Endis: ${current.hint}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                
                // Chances restantes
                Text(
                  "Chans ki rete: $chances",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                
                // Clavier de lettres
                _buildKeyboard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboard() {
    const String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: alphabet.split('').map((letter) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
            minimumSize: const Size(50, 50),
          ),
          onPressed: () => _guessLetter(letter),
          child: Text(
            letter,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4FACFE),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// 🎯 CLASSE RESULTSCREEN (qui était manquante!)
class ResultScreen extends StatelessWidget {
  final bool win;
  final String word;
  final VoidCallback onRestart;

  const ResultScreen({
    super.key,
    required this.win,
    required this.word,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4FACFE),
              Color(0xFF00F2FE),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  win ? "OU GENYEN 🎉" : "OU PÈDI 😢",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Mo a te: $word",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ✅ Kontinye (VÈT)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        onRestart();
                      },
                      child: const Text(
                        "Kontinye Jwe",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // ❌ Kite (WOUJ)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                      ),
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text(
                        "Kite",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}