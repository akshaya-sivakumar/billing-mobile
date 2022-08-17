import 'package:billing/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/textformfield.dart';

class Branches extends StatefulWidget {
  const Branches({Key? key}) : super(key: key);
  static String routeName = '/branches';

  @override
  State<Branches> createState() => _BranchesState();
}

class _BranchesState extends State<Branches> {
  TextEditingController itemController = TextEditingController();
  @override
  void initState() {
    fetchBranches();
    super.initState();
  }

  var db = FirebaseFirestore.instance;
  List branches = [];
  Future<void> fetchBranches() async {
    await db.collection("branches").get().then((value) => {
          branches = value.docs
              .map((e) => {"branchName": e["branchName"], "id": e.id})
              .toList()
        });
    setState(() {});
  }

  String id = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Branches")),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFieldWidget(
            controller: itemController,
            title: "Branch",
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
                      bool isAlreadyThere = branches
                          .where((element) => (id != element["id"])
                              ? element["branchName"] == itemController.text
                              : false)
                          .toList()
                          .isNotEmpty;
                      if (itemController.text.isNotEmpty && !isAlreadyThere) {
                        if (id == "") {
                          await db
                              .collection("branches")
                              .add({"branchName": itemController.text});
                          showToast(
                              message:
                                  "${itemController.text} Added Successfully");
                        } else {
                          await db
                              .collection("branches")
                              .doc(id)
                              .update({"branchName": itemController.text});
                          showToast(
                              message:
                                  "${itemController.text} Updated Successfully");
                        }
                        id = "";

                        fetchBranches();
                      } else if (isAlreadyThere) {
                        showToast(
                            message: "Branch Name Already Exist",
                            isError: true);
                      } else {
                        showToast(
                            message: "Branch Name is Empty", isError: true);
                      }
                      itemController.clear();
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
              itemCount: branches.length,
              itemBuilder: (context, index) {
                return ListTile(
                  selected: id == branches[index]["id"],
                  selectedTileColor: Theme.of(context).primaryColor,
                  title: Text(
                    branches[index]["branchName"],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (branches[index]["id"] != id)
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () async {
                            id = branches[index]["id"];
                            itemController.text = branches[index]["branchName"];
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
                            id = "";
                            itemController.clear();
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
                              .collection("branches")
                              .doc(branches[index]["id"])
                              .delete();
                          showToast(
                              message:
                                  "${branches[index]["branchName"]} Deleted Successfully");
                          id = "";
                          fetchBranches();
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
}
