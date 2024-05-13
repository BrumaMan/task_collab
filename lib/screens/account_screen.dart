import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_collab/widgets/button.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String getInitials() {
    List<String> names = currentUser.currentUser?.displayName?.split(' ') ?? [];
    String initials = "";
    names.forEach((element) {
      initials = initials + element[0];
    });

    return initials;
  }

  FirebaseAuth currentUser = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
              leading: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(100.0)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 8.0, left: 8.0, top: 4.0, bottom: 4.0),
                  child: Text(
                    getInitials(),
                    style: const TextStyle(fontSize: 32.0),
                  ),
                ),
              ),
              title: Text(
                currentUser.currentUser?.displayName ?? "",
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(currentUser.currentUser?.email ?? ""),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12.0, bottom: 12.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: kElevationToShadow[1],
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: ListTile.divideTiles(context: context, tiles: [
                  const ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    leading: Icon(Icons.sort),
                    title: Text("Licenses"),
                  ),
                  const ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    leading: Icon(Icons.smartphone),
                    title: Text("App version"),
                    subtitle: Text("1.0.0 (Prototype)"),
                  )
                ]).toList(),
              ),
            ),
            Button(
              onPressed: () {
                currentUser.signOut();
              },
              color: Theme.of(context).scaffoldBackgroundColor,
              minWidth: double.maxFinite,
              child: const Text(
                "Log out",
                style: TextStyle(fontSize: 16.0, color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }
}
