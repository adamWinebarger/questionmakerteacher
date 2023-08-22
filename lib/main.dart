import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:questionmakerteacher/screens/auth.dart';
import 'package:questionmakerteacher/screens/patient_list_screen.dart';
import 'package:questionmakerteacher/screens/splash.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          surface: const Color(0xff8f8f8f),
        ),
        scaffoldBackgroundColor: const Color(0xffbabab8),
      ),
      darkTheme: ThemeData.dark().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
              surface: const Color.fromARGB(255, 42, 51, 59)
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60)
      ),
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Center(child: Text("Theme tests"),),
        // ),
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            if (dataSnapshot.hasData) {
              return PatientListScreen();
            } else {
              return const AuthScreen();
            }
          }
        ),
      )
    );
  }
}