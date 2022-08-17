import 'package:billing/models/workMangerInputDataModel.dart';
import 'package:billing/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final scaffoldkey = GlobalKey<ScaffoldMessengerState>();
const immediatenotification = "com.aksh.immediate.notification";

void showToast({
  message,
  context,
  bool isError = false,
}) {
  scaffoldkey.currentState?.clearSnackBars();
  scaffoldkey.currentState?.showSnackBar(SnackBar(
    elevation: 6,
    content: InkWell(
      onTap: () {
        scaffoldkey.currentState?.clearSnackBars();
      },
      child: Container(
        color: isError ? const Color(0xFFFBF2F4) : const Color(0xFFE1F4E5),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              fontFamily: "futura",
              color:
                  isError ? const Color(0xFFB00020) : const Color(0xFF35B350)),
        ),
      ),
    ),
    behavior: SnackBarBehavior.fixed,
    duration: const Duration(seconds: 4),
    dismissDirection: DismissDirection.vertical,
    backgroundColor:
        isError ? const Color(0xFFFBF2F4) : const Color(0xFFE1F4E5),
  ));
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WorkMangerInputData workMangerInputData =
        WorkMangerInputData.fromJson(inputData);
    switch (task) {
      case immediatenotification:
        await flutterLocalNotificationsPlugin.show(
          workMangerInputData.id,
          workMangerInputData.title,
          workMangerInputData.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
            workMangerInputData.id.toString(),
            enableVibration: true,
            playSound: true,
            priority: Priority.max,
            // sound:
            //     const RawResourceAndroidNotificationSound('spidermansound.mp3'),
            visibility: NotificationVisibility.public,
            importance: Importance.max,
            workMangerInputData.title,
          )),
        );

        break;
    }

    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: IOSInitializationSettings()),
  );
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

Future firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  return Future<void>.value();
  //log("in background" + message.notification!.body.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Billing App',
      onGenerateRoute: generateRoute,
      initialRoute: '/',
      scaffoldMessengerKey: scaffoldkey,
      theme: ThemeData(
          elevatedButtonTheme:
              const ElevatedButtonThemeData(style: ButtonStyle()),
          textTheme: const TextTheme(
              subtitle1: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
              headline1: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              headline2: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          scaffoldBackgroundColor: Colors.white,
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.blue[100]),
          primaryColor: Colors.blue[100],
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue[100],
              titleTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              iconTheme: const IconThemeData(color: Colors.black))),
    );
  }
}
