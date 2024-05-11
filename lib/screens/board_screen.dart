import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:task_collab/screens/task_screen.dart';
import 'package:task_collab/widgets/textfield.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key, required this.title, required this.boardID});

  final String title;
  final String boardID;

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  TextEditingController nameController = TextEditingController();
  final controller = PageController(viewportFraction: 0.8);
  FirebaseFirestore db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> taskgroupsStream;
  String helperText = "";
  String errorText = "";

  @override
  void initState() {
    super.initState();
    taskgroupsStream = FirebaseFirestore.instance
        .collection("boards")
        .doc(widget.boardID)
        .collection("taskgroups")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Add user"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField2(
                            controller: nameController,
                            hintText: "User Email",
                            helperText: helperText,
                            errorText: errorText == "" ? null : errorText,
                          )
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Cancel")),
                        TextButton(
                            onPressed: () {
                              QueryDocumentSnapshot<Map<String, dynamic>> user;
                              try {
                                db
                                    .collection("users")
                                    .where("email",
                                        isEqualTo: nameController.text.trim())
                                    .get()
                                    .then((value) {
                                  user = value.docs.firstWhere((element) =>
                                      element.data()["email"] ==
                                      nameController.text.trim());
                                  db
                                      .collection("boards")
                                      .doc(widget.boardID)
                                      .update({
                                        "users": FieldValue.arrayUnion([
                                          db.collection("users").doc(user.id)
                                        ]),
                                      })
                                      .then((value) => setState(() {
                                            errorText = "";
                                            helperText =
                                                "Added: ${nameController.text.trim()}";
                                          }))
                                      .onError((error, stackTrace) =>
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text(error.toString()))));
                                  nameController.text = "";
                                });
                              } catch (e) {
                                setState(() {
                                  helperText = "";
                                  errorText = "User not found";
                                });
                              }
                            },
                            child: Text("Add")),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.group_add,
                color: Colors.white,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: taskgroupsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Press '+' to create a Task Group"),
            );
          }

          return Stack(
            children: [
              SizedBox(
                height: 500,
                child: PageView(
                  controller: controller,
                  children: snapshot.data!.docs
                      .map((boardDocument) {
                        Map<String, dynamic> data =
                            boardDocument.data()! as Map<String, dynamic>;

                        Stream<QuerySnapshot> tasksStream = db
                            .collection("boards")
                            .doc(widget.boardID)
                            .collection("taskgroups")
                            .doc(boardDocument.id)
                            .collection("tasks")
                            .snapshots();
                        return Container(
                          width: 280,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade200),
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      data["name"],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Create task"),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField2(
                                                    controller: nameController,
                                                    hintText: "Task name",
                                                  )
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: Text("Cancel")),
                                                TextButton(
                                                    onPressed: () {
                                                      db
                                                          .collection("boards")
                                                          .doc(widget.boardID)
                                                          .collection(
                                                              "taskgroups")
                                                          .doc(boardDocument.id)
                                                          .collection("tasks")
                                                          .doc()
                                                          .set({
                                                            "taskName":
                                                                nameController
                                                                    .text
                                                                    .trim(),
                                                            "description": "",
                                                            "owner":
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser
                                                                    ?.uid,
                                                            "startDate": FieldValue
                                                                .serverTimestamp(),
                                                            // "finishDate": "",
                                                            "createdAt": FieldValue
                                                                .serverTimestamp(),
                                                            "completed": false
                                                          })
                                                          .then((value) =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop())
                                                          .onError((error,
                                                                  stackTrace) =>
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                          content:
                                                                              Text(error.toString()))));
                                                      nameController.text = "";
                                                    },
                                                    child: Text("Create")),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.add))
                                ],
                              ),
                              StreamBuilder(
                                stream: tasksStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text(snapshot.error.toString());
                                  }

                                  if (snapshot.data?.docs.isEmpty ?? true) {
                                    return SizedBox(
                                      height: 400,
                                      child: const Center(
                                        child: Text("Press '+' to add task"),
                                      ),
                                    );
                                  }

                                  return SizedBox(
                                    height: 400,
                                    child: ListView(
                                      children: snapshot.data?.docs
                                              .map((taskDocument) {
                                                Map<String, dynamic> data =
                                                    taskDocument.data()!
                                                        as Map<String, dynamic>;

                                                return GestureDetector(
                                                  child: Container(
                                                    // height: 100,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 10),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4),
                                                    decoration: BoxDecoration(
                                                      boxShadow:
                                                          kElevationToShadow[1],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                    ),
                                                    child: Text(
                                                      data["taskName"],
                                                      style: TextStyle(
                                                          decoration: data[
                                                                  "completed"]
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : null),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      CupertinoPageRoute(
                                                        fullscreenDialog: true,
                                                        builder: (context) =>
                                                            TaskScreen(
                                                          boardID:
                                                              widget.boardID,
                                                          taskgroupID:
                                                              boardDocument.id,
                                                          taskID:
                                                              taskDocument.id,
                                                          taskData: data,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              })
                                              .toList()
                                              .cast() ??
                                          [],
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        );
                      })
                      .toList()
                      .cast(),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height - 150),
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: snapshot.data!.docs.length,
                      effect: ScrollingDotsEffect(),
                    ),
                  ))
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Create task group"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField2(
                      controller: nameController,
                      hintText: "Task group name",
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
                            .doc(widget.boardID)
                            .collection("taskgroups")
                            .doc()
                            .set({
                              "name": nameController.text.trim(),
                              // "owner": FirebaseAuth.instance.currentUser?.uid,
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
