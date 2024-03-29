import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_collab/firebase_options.dart';
import 'package:task_collab/screens/home_screen.dart';
import 'package:task_collab/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 50, 119, 185)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      }
    });

    // FirebaseAuth.instance.currentUser != null
    //     ? Navigator.of(context).pushAndRemoveUntil(
    //         CupertinoPageRoute(
    //           builder: (context) => const HomeScreen(),
    //         ),
    //         (route) => false,
    //       )
    //     : Navigator.of(context).pushAndRemoveUntil(
    //         CupertinoPageRoute(
    //           builder: (context) => const WelcomeScreen(),
    //         ),
    //         (route) => false,
    //       );
    return const SizedBox.shrink();
  }
}
