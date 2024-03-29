import 'package:flutter/material.dart';

class SettingupScreen extends StatefulWidget {
  const SettingupScreen(
      {super.key,
      required this.email,
      required this.name,
      required this.password});

  final String email;
  final String name;
  final String password;

  @override
  State<SettingupScreen> createState() => _SettingupScreenState();
}

class _SettingupScreenState extends State<SettingupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Setting up",
              style: TextStyle(fontSize: 32.0, color: Colors.white),
            ),
            const Text(
              "Your ACME account is being set up",
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80.0),
              child: Image.asset(
                "assets/ReadingDoodle.png",
                width: 500.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
