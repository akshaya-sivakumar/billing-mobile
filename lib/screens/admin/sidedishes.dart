import 'package:billing/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/textformfield.dart';

class SideDishes extends StatefulWidget {
  const SideDishes({Key? key}) : super(key: key);
  static String routeName = '/sidedishes';

  @override
  State<SideDishes> createState() => _BranchesState();
}

class _BranchesState extends State<SideDishes> {
  TextEditingController itemController = TextEditingController();
  @override
  void initState() {
    fetchsideDishes();
    super.initState();
  }

  var db = FirebaseFirestore.instance;
  List sidedishes = [];
  Future<void> fetchsideDishes() async {
    await db.collection("sidedishes").get().then((value) => {
          sidedishes = value.docs
              .map((e) => {"sideDishName": e["sideDishName"], "id": e.id})
              .toList()
        });
    setState(() {});
  }

  String id = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SideDishes")),
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
                      bool isAlreadyThere = sidedishes
                          .where((element) => (id != element["id"])
                              ? element["sideDishName"] == itemController.text
                              : false)
                          .toList()
                          .isNotEmpty;
                      if (itemController.text.isNotEmpty && !isAlreadyThere) {
                        if (id == "") {
                          await db
                              .collection("sidedishes")
                              .add({"sideDishName": itemController.text});
                          showToast(
                              message:
                                  "${itemController.text} Added Successfully");
                        } else {
                          await db
                              .collection("sidedishes")
                              .doc(id)
                              .update({"sideDishName": itemController.text});
                          showToast(
                              message:
                                  "${itemController.text} Updated Successfully");
                        }
                        id = "";

                        fetchsideDishes();
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
              itemCount: sidedishes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  selected: id == sidedishes[index]["id"],
                  selectedTileColor: Theme.of(context).primaryColor,
                  title: Text(
                    sidedishes[index]["sideDishName"],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (sidedishes[index]["id"] != id)
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () async {
                            id = sidedishes[index]["id"];
                            itemController.text =
                                sidedishes[index]["sideDishName"];
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
                              .collection("sidedishes")
                              .doc(sidedishes[index]["id"])
                              .delete();
                          showToast(
                              message:
                                  "${sidedishes[index]["sideDishName"]} Deleted Successfully");
                          id = "";
                          fetchsideDishes();
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
