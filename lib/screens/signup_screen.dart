import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_collab/screens/home_screen.dart';
// import 'package:task_collab/screens/settingup_screen.dart';
import 'package:task_collab/widgets/button.dart';
import 'package:task_collab/widgets/textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? passswordError;
  String? emailError;
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
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
                      "Sign up for your account",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    TextField2(
                      controller: emailController,
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      hintText: "Enter email address",
                      errorText: emailError,
                    ),
                    TextField2(
                      controller: nameController,
                      hintText: "Enter full name",
                    ),
                    TextField2(
                      controller: passwordController,
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      hintText: "Create password",
                      errorText: passswordError,
                      obscureText: true,
                    )
                  ],
                ),
              ),
              Button(
                onPressed: () async {
                  try {
                    // ignore: unused_local_variable
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim())
                        .then((value) {
                      value.user?.updateDisplayName(nameController.text.trim());

                      db.collection("users").doc(value.user?.uid).set({
                        "name": nameController.text.trim(),
                        "email": emailController.text.trim(),
                        "createdAt": FieldValue.serverTimestamp()
                      }).onError((error, stackTrace) =>
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString()))));
                    });

                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      setState(() {
                        passswordError = "The password is too weak";
                      });
                    } else if (e.code == 'email-already-in-use') {
                      setState(() {
                        emailError =
                            "The account already exists for that email.";
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
                minWidth: 180.0,
                padding: EdgeInsets.symmetric(vertical: 150.0),
                child: Text(
                  "Sign up",
                  style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
