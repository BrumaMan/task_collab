import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_collab/screens/account_screen.dart';
import 'package:task_collab/screens/boards_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int screenIndex = 0;
  List<Widget> screens = [const BoardsScreen(), const AccountScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[screenIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              screenIndex = value;
            });
          },
          currentIndex: screenIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_outlined), label: "Boards"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: "Account")
          ]),
    );
  }
}
