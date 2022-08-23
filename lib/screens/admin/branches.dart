import 'package:billing/bloc/branch_bloc/branch_bloc.dart';
import 'package:billing/main.dart';
import 'package:billing/models/branchDetail.dart';
import 'package:billing/models/branch_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/textformfield.dart';

class Branches extends StatefulWidget {
  const Branches({Key? key}) : super(key: key);
  static String routeName = '/branches';

  @override
  State<Branches> createState() => _BranchesState();
}

class _BranchesState extends State<Branches> {
  TextEditingController itemController = TextEditingController();
  late BranchBloc branchBloc;
  @override
  void initState() {
    branchBloc = BlocProvider.of<BranchBloc>(context);
    branchBloc.stream.listen((state) {
      if (state is CreateBranchDone) {
        showToast(message: "Branch created successfully");
        branchBloc.add(FetchBranch());
      } else if (state is CreateBranchError) {
        showToast(message: "Branch not created", isError: true);
      } else if (state is UpdateBranchDone) {
        showToast(message: "Branch updated successfully");
        setState(() {
          id = 0;
        });
        branchBloc.add(FetchBranch());
      } else if (state is UpdateBranchError) {
        showToast(message: "Branch not updated", isError: true);
      } else if (state is DeleteBranchDone) {
        showToast(message: "Branch deleted successfully");
        branchBloc.add(FetchBranch());
      } else if (state is DeleteBranchError) {
        showToast(message: "Branch not deleted", isError: true);
      }
    });
    branchBloc.add(FetchBranch());

    super.initState();
  }

  var db = FirebaseFirestore.instance;
  List<BranchDetail> branches = [];

  int id = 0;
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
                      id == 0
                          ? context.read<BranchBloc>().add(CreateBranch(
                              BranchRequest(Branchname: itemController.text)))
                          : context.read<BranchBloc>().add(UpdateBranchEvent(id,
                              BranchRequest(Branchname: itemController.text)));
                      itemController.clear();
                    },
                    label:
                        id == 0 ? const Text("Create") : const Text("Update"),
                    icon: id == 0
                        ? const Icon(Icons.add)
                        : const Icon(Icons.update))
              ],
            ),
          ),
          BlocBuilder<BranchBloc, BranchState>(
            builder: (context, state) {
              if (state is BranchDone) {
                branches = state.branchList;
                return Expanded(
                  child: ListView.builder(
                    itemCount: branches.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        selected: id == branches[index].ID,
                        selectedTileColor: Theme.of(context).primaryColor,
                        title: Text(
                          branches[index].branchName,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (branches[index].ID != id)
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () async {
                                  id = branches[index].ID;
                                  itemController.text =
                                      branches[index].branchName;
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
                                branchBloc
                                    .add(DeleteBranchEvent(branches[index].ID));
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
    );
  }
}
