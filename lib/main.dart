import 'package:flutter/material.dart';
import 'package:questionmakerteacher/screens/auth.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'questionmaker teacher',
      theme: ThemeData.light().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
          surface: const Color(0xffbabab8)
        ),
        scaffoldBackgroundColor: const Color(0xffbabab8)
      ),
      darkTheme: ThemeData.dark().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
              surface: const Color.fromARGB(255, 50, 58, 60)
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60)
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Theme tests"),),
        ),
        body: const AuthScreen(),
      )
    );
  }
}