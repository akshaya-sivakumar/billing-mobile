import 'dart:convert';
import 'dart:io';

import 'package:billing/bloc/login_bloc/login_bloc.dart';
import 'package:billing/models/login_request.dart';
import 'package:billing/models/workMangerInputDataModel.dart';
import 'package:billing/screens/admin/admin_panel.dart';
import 'package:billing/screens/dashboard.dart';
import 'package:billing/screens/sign_up.dart';
import 'package:billing/widgets/loader_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notification_scheduler/firebase_notification_scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late LoginBloc loginBloc;
  @override
  void initState() {
    super.initState();

    initNotification();
    loginBloc = BlocProvider.of<LoginBloc>(context)
      ..stream.listen((state) {
        if (state is LoginDone) {
          LoaderWidget().showLoader(context, stopLoader: true);
          showToast(message: state.loginResponse.message);
          Navigator.pushNamedAndRemoveUntil(
              context, Dashboard.routeName, (route) => false);
        } else if (state is LoginError) {
          LoaderWidget().showLoader(context, stopLoader: true);
          showToast(message: state.error, isError: true);
        }
      });
  }

  Future<void> initNotification() async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message != null) {}
    });
    FirebaseMessaging.onMessage.listen((event) async {
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
      if (event != null) {}
    });
  }

  Future<String> getFirebase() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);
    return fcmToken!;
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(key: formKey, child: loginBody(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          WidgetsBinding.instance.window.viewInsets.bottom == 0
              ? siginInButton(context)
              : null,
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

  Container siginInButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.7,
            child: ElevatedButton(
                onPressed: onSignin,
                child: Text(
                  "Sign In",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(color: Colors.white),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Dashboard.routeName);
                },
                child: Text("If you dont have an account? Click here")),
          )
        ],
      ),
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
          validator: (value) {
            if (value == "") {
              return "Please enter username";
            }
            return null;
          },
        ),
        TextFieldWidget(
          controller: passwordController,
          isTitle: true,
          leadingIcon: const Icon(Icons.lock),
          title: "Password",
          validator: (value) {
            if (value == "") {
              return "Please enter valid password";
            }
            return null;
          },
        ),
      ],
    ));
  }

  var db = FirebaseFirestore.instance;

  void onSignin() async {
    LoaderWidget().showLoader(context);
    if (formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(LoginRequestEvent(LoginRequest(
          Username: userController.text, Password: passwordController.text)));
    } else {
      LoaderWidget().showLoader(context, stopLoader: true);
    }
  }
}
