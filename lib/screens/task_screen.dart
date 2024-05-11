import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_collab/widgets/textfield.dart';

// ignore: must_be_immutable
class TaskScreen extends StatefulWidget {
  TaskScreen(
      {super.key,
      required this.boardID,
      required this.taskgroupID,
      required this.taskID,
      required this.taskData});

  final String boardID;
  final String taskgroupID;
  final String taskID;
  Map<String, dynamic> taskData;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late TextEditingController descController;
  late dynamic owner = "";
  bool generating = false;
  List<OpenAIChatCompletionChoiceMessageModel> messages = [];

  @override
  void initState() {
    super.initState();
    descController =
        TextEditingController(text: widget.taskData["description"]);
    db
        .collection("users")
        .doc(widget.taskData["owner"])
        .get()
        .then((value) => setState(() => owner = value.data()?["name"]));

    widget.taskData["finishDate"] == null
        ? widget.taskData["finishDate"] = ""
        : widget.taskData["finishDate"];

    messages = [
      OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
                'Write a description in abbout 20 words and dont include the task name, for a task based off of its name, delimited by triple quotes """${widget.taskData["taskName"]}"""')
          ])
    ];
  }

  void generateDescription() {
    if (generating) {
      return;
    }
    setState(() => generating = true);
    Stream<OpenAIStreamChatCompletionModel> chatStream = OpenAI.instance.chat
        .createStream(model: "gpt-3.5-turbo", messages: messages);

    debugPrint(descController.text);

    descController.text = "";
    chatStream.listen(
      (event) {
        final char = event.choices.first.delta.content?.first?.text ?? "";
        descController.text = descController.text + char;

        debugPrint(descController.text);
      },
      onDone: () {
        setState(() {
          widget.taskData["description"] = descController.text;
          generating = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 217, 217),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(
              widget.taskData["taskName"],
              style: TextStyle(
                  decoration: widget.taskData["completed"]
                      ? TextDecoration.lineThrough
                      : null),
            ),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close)),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      widget.taskData["completed"] =
                          widget.taskData["completed"] ? false : true;
                    });
                  },
                  icon: Icon(widget.taskData["completed"]
                      ? Icons.block
                      : Icons.check)),
              IconButton(
                  onPressed: () {
                    db
                        .collection("boards")
                        .doc(widget.boardID)
                        .collection("taskgroups")
                        .doc(widget.taskgroupID)
                        .collection("tasks")
                        .doc(widget.taskID)
                        .delete()
                        .then((value) => Navigator.pop(context));
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  )),
            ],
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 18.0)),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.symmetric(horizontal: BorderSide())),
              child: TextField2(
                controller: descController,
                hintText: "Add description...",
                withBorder: false,
                onChanged: (p0) => setState(() {
                  widget.taskData["description"] = p0;
                }),
                suffix: IconButton(
                    onPressed: () {
                      generateDescription();
                    },
                    icon: Icon(Icons.auto_awesome)),
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 18.0)),
          SliverToBoxAdapter(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.symmetric(horizontal: BorderSide())),
                child: Text("Assigned to: $owner")),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 18.0)),
          SliverToBoxAdapter(
            child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                decoration: const BoxDecoration(
                    color: Colors.white, border: Border(top: BorderSide())),
                child: GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.fromMillisecondsSinceEpoch(
                            widget.taskData["startDate"].seconds * 1000),
                        firstDate: DateTime(DateTime.fromMillisecondsSinceEpoch(
                                widget.taskData["startDate"].seconds * 1000)
                            .year),
                        lastDate: DateTime(DateTime.now().year + 5));

                    if (picked != null &&
                        picked != widget.taskData["startDate"]) {
                      setState(() {
                        widget.taskData["startDate"] = Timestamp(
                            picked.millisecondsSinceEpoch ~/ 1000,
                            picked.microsecondsSinceEpoch ~/ 100000000);
                      });
                    }
                  },
                  child: Text(
                      "Start Date: ${DateTime.fromMillisecondsSinceEpoch(widget.taskData["startDate"].seconds * 1000).format("d M Y")}"),
                )),
          ),
          SliverToBoxAdapter(
            child: Divider(
              thickness: 1.0,
              height: 1.0,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                decoration: BoxDecoration(
                    color: Colors.white, border: Border(bottom: BorderSide())),
                child: GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.fromMillisecondsSinceEpoch(
                            widget.taskData["startDate"].seconds * 1000),
                        firstDate: DateTime(DateTime.fromMillisecondsSinceEpoch(
                                widget.taskData["startDate"].seconds * 1000)
                            .year),
                        lastDate: DateTime(DateTime.now().year + 5));

                    if (picked != null &&
                        picked != widget.taskData["finishDate"]) {
                      setState(() {
                        widget.taskData["finishDate"] = Timestamp(
                            picked.millisecondsSinceEpoch ~/ 1000,
                            picked.microsecondsSinceEpoch ~/ 100000000);
                      });
                    }
                  },
                  child: Text(widget.taskData["finishDate"] != ""
                      ? "Finish Date: ${DateTime.fromMillisecondsSinceEpoch(widget.taskData["finishDate"].seconds * 1000).format("d M Y")}"
                      : "Add finish date..."),
                )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          db
              .collection("boards")
              .doc(widget.boardID)
              .collection("taskgroups")
              .doc(widget.taskgroupID)
              .collection("tasks")
              .doc(widget.taskID)
              .update(widget.taskData)
              .then((value) =>
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Changes Saved"),
                    behavior: SnackBarBehavior.floating,
                  )));
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
