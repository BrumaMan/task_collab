import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_collab/screens/board_screen.dart';
import 'package:task_collab/widgets/textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> boardsStream;

  @override
  void initState() {
    super.initState();
    boardsStream = FirebaseFirestore.instance
        .collection("boards")
        .where("users",
            arrayContains: db
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser?.uid))
        // .orderBy("createdAt")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Boards"),
      ),
      body: StreamBuilder(
        stream: boardsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs
                .map((document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return ListTile(
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(4.0)),
                    ),
                    title: Text(data["title"]),
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => BoardScreen(
                            title: data["title"],
                            boardID: document.id,
                          ),
                        ),
                      );
                    },
                  );
                })
                .toList()
                .cast(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Create board"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField2(
                      controller: nameController,
                      hintText: "Board title",
                    )
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Cancel")),
                  TextButton(
                      onPressed: () {
                        db
                            .collection("boards")
                            .doc()
                            .set({
                              "title": nameController.text.trim(),
                              "owner": FirebaseAuth.instance.currentUser?.uid,
                              "users": [
                                db
                                    .collection("users")
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                              ],
                              "createdAt": FieldValue.serverTimestamp()
                            })
                            .then((value) => Navigator.of(context).pop())
                            .onError((error, stackTrace) =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error.toString()))));
                        nameController.text = "";
                      },
                      child: Text("Create")),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
