import 'dart:convert';
import 'dart:io';

import 'package:billing/models/workMangerInputDataModel.dart';
import 'package:billing/screens/admin/admin_panel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notification_scheduler/firebase_notification_scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message != null) {
        print(message.notification!.body);
        print("--------");
        print(message.data);
      }
    });
    FirebaseMessaging.onMessage.listen((event) async {
      print(event.data);

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
              'repeating channel id', 'repeating channel name',
              channelDescription: 'repeating description');
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      if (Platform.isAndroid) {
        await flutterLocalNotificationsPlugin.show(1, event.notification!.title,
            event.notification!.body, platformChannelSpecifics,
            payload: json.encode(event.data));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      print("on meesage");
      if (event != null) {
        print(event.notification!.body);
        print("--------");
        print(event.data);
      } else {
        // redirectToSplash();
      }
      /*  MyApp.navigatorKey.currentState!.pushNamedAndRemoveUntil("/chatlist",
          (route) {
        return false;
      }); */
      //   MyApp.navigatorKey.currentState!.pushNamed("/chatlist");
    });
  }

  Future<String> getFirebase() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);
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
    print(getFirebase());
  }
}
