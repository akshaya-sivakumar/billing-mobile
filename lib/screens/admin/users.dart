import 'package:billing/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/textformfield.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);
  static String routeName = '/users';

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  TextEditingController userName = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    fetchUsers();
    fetchBranches();
    super.initState();
  }

  List branches = [];
  Future<void> fetchBranches() async {
    await db.collection("branches").get().then((value) => {
          branches = value.docs
              .map((e) => {"branchName": e["branchName"], "id": e.id})
              .toList()
        });
    setState(() {});
  }

  var db = FirebaseFirestore.instance;
  List users = [];
  Future<void> fetchUsers() async {
    await db.collection("users").get().then((value) => {
          users = value.docs
              .map((e) => {
                    "userName": e["userName"],
                    "password": e["password"],
                    "branchCode": e["branchCode"],
                    "userRole": e["userRole"],
                    "id": e.id
                  })
              .toList()
        });
    setState(() {});
  }

  String id = "";
  String branchCode = "";
  String userRole = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFieldWidget(
                  controller: userName,
                  title: "User",
                ),
                TextFieldWidget(
                  controller: passwordController,
                  title: "Password",
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 10),
                  child: DropdownButtonFormField(
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Select Role',
                      ),
                      value: userRole == "" ? null : userRole,
                      items: ["Admin", "User"].map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (a) {
                        setState(() {
                          userRole = a.toString();
                        });
                      }),
                ),
                if (userRole != "Admin")
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10),
                    child: DropdownButtonFormField(
                        value: branchCode == "" ? null : branchCode,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Select Branch',
                        ),
                        items: branches.map((value) {
                          return DropdownMenuItem<String>(
                            value: value["id"],
                            child: Text(value["branchName"]),
                          );
                        }).toList(),
                        onChanged: (a) {
                          branchCode = a.toString();
                        }),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    onPressed: () async {
                      bool isAlreadyThere = users
                          .where((element) => (id != element["id"])
                              ? element["userName"] == userName.text
                              : false)
                          .toList()
                          .isNotEmpty;
                      if (userName.text.isNotEmpty && !isAlreadyThere) {
                        if (id == "" &&
                            (userRole == "Admin" ? true : branchCode != "")) {
                          await db.collection("users").add(userMap);
                          showToast(
                              message: "${userName.text} Added Successfully");
                          clearData();
                        } else if ((userRole == "Admin"
                            ? true
                            : branchCode != "")) {
                          await db.collection("users").doc(id).update(userMap);
                          showToast(
                              message: "${userName.text} Updated Successfully");
                          clearData();
                        } else {
                          showToast(
                              message: "Branch Needed for User", isError: true);
                        }

                        fetchUsers();
                      } else if (isAlreadyThere) {
                        showToast(
                            message: "User Name Already Exist", isError: true);
                      } else {
                        showToast(message: "User Name is Empty", isError: true);
                      }
                    },
                    label:
                        id == "" ? const Text("Create") : const Text("Update"),
                    icon: id == ""
                        ? const Icon(Icons.add)
                        : const Icon(Icons.update))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  selected: id == users[index]["id"],
                  selectedTileColor: Theme.of(context).primaryColor,
                  title: Text(
                    users[index]["userName"],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (users[index]["id"] != id)
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () async {
                            updateFields(index);

                            setState(() {});
                          },
                        )
                      else
                        IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            clearData();
                            setState(() {});
                          },
                        ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await db
                              .collection("users")
                              .doc(users[index]["id"])
                              .delete();
                          showToast(
                              message:
                                  "${users[index]["userName"]} Deleted Successfully");
                          id = "";
                          fetchUsers();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Map<String, Object?> get userMap {
    return {
      "userName": userName.text,
      "password": passwordController.text,
      "branchCode": branchCode,
      "userRole": userRole
    };
  }

  void updateFields(int index) {
    id = users[index]["id"];
    passwordController.text = users[index]["password"];
    branchCode = users[index]["branchCode"];
    userRole = users[index]["userRole"];
    userName.text = users[index]["userName"];
  }

  void clearData() {
    userName.clear();
    passwordController.clear();
    branchCode = "";
    userRole = "";
    id = "";
  }
}
