import 'package:flutter/material.dart';
import 'package:lightbot_flutter/providers/game_provider.dart';
import 'package:lightbot_flutter/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(), // Inicia o jogo com o nível 1
      child: MaterialApp(
        title: 'Lightbot Flutter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
