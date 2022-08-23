import 'package:billing/bloc/sidedish_bloc/sidedish_bloc.dart';
import 'package:billing/main.dart';
import 'package:billing/models/createSidedish_request.dart';
import 'package:billing/models/sidedish_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/textformfield.dart';

class SideDishes extends StatefulWidget {
  const SideDishes({Key? key}) : super(key: key);
  static String routeName = '/sidedishes';

  @override
  State<SideDishes> createState() => _BranchesState();
}

class _BranchesState extends State<SideDishes> {
  TextEditingController itemController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  late SidedishBloc sidedishBloc;
  @override
  void initState() {
    sidedishBloc = BlocProvider.of<SidedishBloc>(context);
    sidedishBloc.add(FetchSidedish());
    sidedishBloc.stream.listen((state) {
      if (state is CreateSidedishDone) {
        showToast(message: "Created successfully");
        itemController.clear();
        quantityController.clear();
        unitController.clear();
        sidedishBloc.add(FetchSidedish());
      } else if (state is CreateSidedishError) {
        showToast(message: "Not Created successfully", isError: true);
        sidedishBloc.add(FetchSidedish());
      } else if (state is UpdateSidedishDone) {
        showToast(message: "Updated successfully");
        itemController.clear();
        quantityController.clear();
        unitController.clear();
        setState(() {
          id = 0;
        });
        sidedishBloc.add(FetchSidedish());
      } else if (state is UpdateSidedishError) {
        showToast(message: "Not Updated successfully", isError: true);
        sidedishBloc.add(FetchSidedish());
      } else if (state is DeleteSidedishDone) {
        showToast(message: "Deleted successfully");
        sidedishBloc.add(FetchSidedish());
      } else if (state is DeleteSidedishError) {
        showToast(message: "not deleted");
      }
    });
    super.initState();
  }

  var db = FirebaseFirestore.instance;
  List<SidedishDetail> sidedishes = [];
  final formKey = GlobalKey<FormState>();
  int id = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SideDishes")),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFieldWidget(
              controller: itemController,
              title: "Side dish",
              validator: (value) {
                if (itemController.text == null || itemController.text == "") {
                  return "Please enter dish name";
                }
              },
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4 - 10,
                  child: TextFieldWidget(
                    controller: quantityController,
                    title: "Quantity",
                    validator: (value) {
                      if (quantityController.text == null ||
                          quantityController.text == "") {
                        return "Please enter Quantity";
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.62,
                  child: TextFieldWidget(
                    controller: unitController,
                    title: "Unit",
                    validator: (value) {
                      if (unitController.text == null ||
                          unitController.text == "") {
                        return "Please enter Unit";
                      }
                    },
                  ),
                ),
              ],
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
                        if (formKey.currentState!.validate()) {
                          id == 0
                              ? context.read<SidedishBloc>().add(CreateSidedish(
                                  CreateSidedishRequest(
                                      Item: itemController.text,
                                      Quantity: quantityController.text,
                                      Unit: unitController.text)))
                              : context.read<SidedishBloc>().add(
                                  UpdateSidedishEvent(
                                      id,
                                      CreateSidedishRequest(
                                          Item: itemController.text,
                                          Quantity: quantityController.text,
                                          Unit: unitController.text)));
                        }
                      },
                      label:
                          id == 0 ? const Text("Create") : const Text("Update"),
                      icon: id == 0
                          ? const Icon(Icons.add)
                          : const Icon(Icons.update))
                ],
              ),
            ),
            BlocBuilder<SidedishBloc, SidedishState>(
              builder: (context, state) {
                if (state is SidedishDone) {
                  sidedishes = state.sidedishList;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: sidedishes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          selected: id == sidedishes[index].ID,
                          selectedTileColor: Theme.of(context).primaryColor,
                          title: Text(
                            sidedishes[index].item,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (sidedishes[index].ID != id)
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    id = sidedishes[index].ID;
                                    itemController.text =
                                        sidedishes[index].item;
                                    quantityController.text =
                                        sidedishes[index].quantity;
                                    unitController.text =
                                        sidedishes[index].unit;
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
                                    id = 0;
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
                                  sidedishBloc.add(DeleteSidedishEvent(
                                      sidedishes[index].ID));
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }

                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
