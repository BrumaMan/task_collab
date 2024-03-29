import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_collab/screens/login_screen.dart';
import 'package:task_collab/screens/signup_screen.dart';
import 'package:task_collab/widgets/button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "ACME",
              style: TextStyle(fontSize: 32.0, color: Colors.white),
            ),
            Image.asset(
              "assets/MessyDoodle.png",
              width: 350.0,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Button(
                  onPressed: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
                  },
                  color: Colors.white,
                  child: Text(
                    "Log in",
                  ),
                  minWidth: 150.0,
                  padding: EdgeInsets.only(bottom: 8.0),
                ),
                Button(
                  variant: "outlined",
                  onPressed: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const SignupScreen(),
                    ));
                  },
                  color: Colors.white,
                  child: Text(
                    "Sign up",
                    style: TextStyle(color: Colors.white),
                  ),
                  minWidth: 150.0,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
