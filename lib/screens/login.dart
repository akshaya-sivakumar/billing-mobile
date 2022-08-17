import 'package:billing/models/workMangerInputDataModel.dart';
import 'package:billing/screens/admin/admin_panel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notification_scheduler/firebase_notification_scheduler.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import '../main.dart';
import '../widgets/textformfield.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Future<List<ScheduledNotification>> getScheduledNotificationFuture;

  @override
  void initState() {
    super.initState();
  }

  Future<String> getFirebase() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginBody(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: siginInButton(context),
    );
  }

  SafeArea loginBody(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Theme.of(context).primaryColor,
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/launch_icon.png',
                  height: 100,
                  width: 100,
                ),
              ],
            ),
          ),
          loginForm(context)
        ],
      ),
    );
  }

  SizedBox siginInButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      child: ElevatedButton(
          onPressed: onSignin,
          child: Text(
            "Sign In",
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: Colors.white),
          )),
    );
  }

  SingleChildScrollView loginForm(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            "Sign In",
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        TextFieldWidget(
          controller: userController,
          isTitle: true,
          leadingIcon: const Icon(Icons.account_box_rounded),
          title: "UserName",
        ),
        TextFieldWidget(
          controller: passwordController,
          isTitle: true,
          leadingIcon: const Icon(Icons.lock),
          title: "Password",
        ),
      ],
    ));
  }

  var db = FirebaseFirestore.instance;

  void onSignin() async {
    // Workmanager().registerOneOffTask(
    //   immediatenotification,
    //   immediatenotification,
    //   inputData: WorkMangerInputData(
    //           id: 1,
    //           title: "Smart Billing",
    //           body: 'Welcome ${"Akash".toString()}')
    //       .toJson(),
    // );
    try {
      await db
          .collection("users")
          .where("userName", isEqualTo: userController.text)
          .get()
          .then((value) => {
                if (value.docs.isNotEmpty)
                  {
                    if (value.docs.first["password"] == passwordController.text)
                      {
                        showToast(
                            message:
                                'Welcome ${value.docs.first["userName"].toString()}'),
                        if (value.docs.first["userRole"] == "Admin")
                          {Navigator.pushNamed(context, AdminPanel.routeName)}
                        else
                          {}
                      }
                    else
                      {showToast(message: 'Invalid Password', isError: true)}
                  }
                else
                  {showToast(message: 'User Not found', isError: true)}
              });
    } on FirebaseAuthException catch (e) {
      showToast(message: e.message.toString(), isError: true);
    }
  }
}
