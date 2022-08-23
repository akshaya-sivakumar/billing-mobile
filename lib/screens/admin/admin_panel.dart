import 'package:billing/screens/admin/branches.dart';
import 'package:billing/screens/admin/new_item_create.dart';
import 'package:billing/screens/admin/sidedishes.dart';
import 'package:billing/screens/admin/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  static String routeName = '/adminPanel';

  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Admin Panel"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              adminCard(context, "Users", () {
                Navigator.of(context).pushNamed(Users.routeName);
              }),
              adminCard(context, "Branches", () {
                Navigator.of(context).pushNamed(Branches.routeName);
              }),
              adminCard(context, "Menu", () {
                Navigator.of(context).pushNamed(NewItemCreatePage.routeName);
              }),
              adminCard(context, "Side dish", () {
                Navigator.of(context).pushNamed(SideDishes.routeName);
              })
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector adminCard(
      BuildContext context, String title, Function() onchange) {
    return GestureDetector(
      onTap: onchange,
      child: Card(
        elevation: 5,
        child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width / 2 - 30,
            color: Theme.of(context).primaryColor.withOpacity(0.4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )
              ],
            )),
      ),
    );
  }
}
