import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_collab/screens/home_screen.dart';
import 'package:task_collab/widgets/button.dart';
import 'package:task_collab/widgets/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? passswordError;
  String? emailError;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log in"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "ACME",
                style: TextStyle(fontSize: 32.0),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Log into your account",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    TextField2(
                      controller: emailController,
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      hintText: "Enter email address",
                      errorText: emailError,
                    ),
                    TextField2(
                      controller: passwordController,
                      hintText: "Enter password",
                      errorText: passswordError,
                      obscureText: true,
                    )
                  ],
                ),
              ),
              Button(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim());
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'wrong-password') {
                      setState(() {
                        passswordError = "The password is incorrect";
                      });
                    } else if (e.code == 'user-disabled') {
                      setState(() {
                        emailError = "This account has been disabled";
                      });
                    } else if (e.code == 'user-not-found') {
                      setState(() {
                        emailError =
                            "There is no account associated with this email";
                      });
                    } else if (e.code == 'invalid-email') {
                      setState(() {
                        emailError = "This email address is not valid";
                      });
                    }
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                child: Text(
                  "Log in",
                  style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
                minWidth: 180.0,
                padding: EdgeInsets.symmetric(vertical: 180.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
