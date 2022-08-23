import 'package:billing/bloc/branch_bloc/branch_bloc.dart';
import 'package:billing/bloc/signup_bloc/signup_bloc.dart';
import 'package:billing/main.dart';
import 'package:billing/models/branchDetail.dart';
import 'package:billing/models/createUser_request.dart';
import 'package:billing/models/userDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/login_request.dart';
import '../../widgets/loader_widget.dart';
import '../../widgets/textformfield.dart';
import 'admin_panel.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);
  static String routeName = '/users';

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  TextEditingController userName = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late BranchBloc branchBloc;
  late SignupBloc signupBloc;
  @override
  void initState() {
    branchBloc = BlocProvider.of<BranchBloc>(context);
    branchBloc.add(FetchBranch());

    signupBloc = BlocProvider.of<SignupBloc>(context)
      ..stream.listen((state) {
        if (state is SignupDone) {
          signupBloc.add(FetchUserEvent());

          showToast(message: state.signupResponse.message);
          clearData();
          LoaderWidget().showLoader(context, stopLoader: true);

          /*   Navigator.pushNamedAndRemoveUntil(
              context, AdminPanel.routeName, (route) => false); */
        } else if (state is SignupError) {
          showToast(message: state.error, isError: true);
          LoaderWidget().showLoader(context, stopLoader: true);
        } else if (state is UserDeleted) {
          signupBloc.add(FetchUserEvent());
          showToast(message: "User deleted successfully");
        } else if (state is UserDeleteError) {
          showToast(message: "Something went wrong");
        } else if (state is UpdateUserDone) {
          LoaderWidget().showLoader(context, stopLoader: true);
          signupBloc.add(FetchUserEvent());
          showToast(message: "Updated successfully");
          clearData();
        } else if (state is UpdateUserError) {
          LoaderWidget().showLoader(context, stopLoader: true);
          showToast(message: "Something went wrong");
        }
      });
    //  signupBloc = BlocProvider.of<SignupBloc>(context);
    signupBloc.add(FetchUserEvent());
    super.initState();
  }

  List branches = [];

  var db = FirebaseFirestore.instance;
  List<UserDetail> users = [];

  int id = 0;
  String branchCode = "";
  String userRole = "";
  final formKey = GlobalKey<FormState>();
  List<BranchDetail> branchList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFieldWidget(
                    controller: userName,
                    title: "User",
                    validator: (value) {
                      if (userName.text == null || userName.text == "") {
                        return "Please enter username";
                      }
                    },
                  ),
                  TextFieldWidget(
                    controller: passwordController,
                    title: "Password",
                    validator: (value) {
                      if (id == 0) {
                        if (passwordController.text == null ||
                            passwordController.text == "") {
                          return "Please enter password";
                        }
                      }
                    },
                  ),
                  Container(
                    //height: 70,
                    //margin: const EdgeInsets.symmetric(vertical: 20.0),
                    padding: const EdgeInsets.all(10),
                    child: DropdownButtonFormField(
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please select role";
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black)),
                            // filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "Select Role",
                            fillColor: Colors.blue[200]),
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
                    BlocBuilder<BranchBloc, BranchState>(
                      builder: (context, state) {
                        if (state is BranchDone) {
                          branchList = state.branchList;
                        }
                        return Container(
                          child: Row(
                            children: [
                              IgnorePointer(
                                ignoring: state is BranchLoad,
                                child: Container(
                                  width: state is BranchLoad
                                      ? MediaQuery.of(context).size.width * 0.8
                                      : MediaQuery.of(context).size.width *
                                          0.95,
                                  padding: const EdgeInsets.all(10),

                                  /*   margin: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10), */
                                  child: DropdownButtonFormField(
                                      validator: (value) {
                                        if (userRole != "Admin") {
                                          if (userName.text == null ||
                                              userName.text == "") {
                                            return "Please select branch";
                                          }
                                        }
                                      },
                                      value:
                                          branchCode == "" ? null : branchCode,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          // filled: true,
                                          hintStyle: TextStyle(
                                              color: Colors.grey[800]),
                                          hintText: "Select Branch",
                                          fillColor: Colors.blue[200]),
                                      items: branchList.map((value) {
                                        return DropdownMenuItem<String>(
                                          value: value.ID.toString(),
                                          child: Text(value.branchName),
                                        );
                                      }).toList(),
                                      onChanged: (a) {
                                        branchCode = a.toString();
                                      }),
                                ),
                              ),
                              if (state is BranchLoad)
                                const CircularProgressIndicator()
                            ],
                          ),
                        );
                      },
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
                        if (id == 0) {
                          LoaderWidget().showLoader(context);

                          if (formKey.currentState!.validate()) {
                            context.read<SignupBloc>().add(SignupRequestEvent(
                                CreateuserRequest(
                                    Username: userName.text,
                                    Password: passwordController.text,
                                    Role: userRole,
                                    Branch: int.parse(
                                        branchCode == "" ? "0" : branchCode))));
                          } else {
                            LoaderWidget()
                                .showLoader(context, stopLoader: true);
                          }
                        } else {
                          LoaderWidget().showLoader(context);

                          if (formKey.currentState!.validate()) {
                            context.read<SignupBloc>().add(UpdateUserEvent(
                                id,
                                CreateuserRequest(
                                    Username: userName.text,
                                    Password: passwordController.text,
                                    Role: userRole,
                                    Branch: int.parse(
                                        branchCode == "" ? "0" : branchCode))));
                          } else {
                            LoaderWidget()
                                .showLoader(context, stopLoader: true);
                          }
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
            BlocBuilder<SignupBloc, SignupState>(
              builder: (context, state) {
                if (state is FetchUserDone) {
                  users = state.userList;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          selected: id == users[index].ID,
                          selectedTileColor: Theme.of(context).primaryColor,
                          title: Text(
                            users[index].username,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (users[index].ID != id)
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
                                  signupBloc
                                      .add(DeleteUserEvent(users[index].ID));
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
                if (state is FetchUserLoad)
                  return const CircularProgressIndicator();

                return Container();
              },
            ),
          ],
        ),
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
    /*  users.forEach((user) {
      branchList.forEach((branch) {
        if(user.branch==branch.ID)

      });
    }); */
    id = users[index].ID;
    passwordController.text = "";
    branchCode = users[index].branch.toString();
    userRole = users[index].role;
    userName.text = users[index].username;
  }

  void clearData() {
    setState(() {
      userName.clear();
      passwordController.clear();
      branchCode = "";
      userRole = "";
      id = 0;
    });
  }
}
