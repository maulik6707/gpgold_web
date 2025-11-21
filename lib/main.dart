import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gdgold/firebase_options.dart';
import 'package:gdgold/helper/firebase_api.dart';
import 'package:gdgold/helper/notification_service.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/pages/splash_screen.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:upgrader/upgrader.dart';

import 'l10n/app_localizations.dart';

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  setupFirebase();
  runApp(const MyApp());
}

setupOneSignal() async {
  final deviceState = await OneSignal.User.getOnesignalId();
  SharPreferences.setString('OneSignalPlayerId', "$deviceState");
  SharPreferences.setBoolean('isOneSignalPlayerIdSet', true);
  print("OneSignalPlayerId: $deviceState");
}

void subscribe() {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  messaging.subscribeToTopic('all');
  print("Subscribe to all topic");
}

setupFirebase() async {
  await FirebaseApi().initNotifications();
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NotificationService notificationService = NotificationService();


  @override
  void initState() {
    // TODO: implement initState
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);
    subscribe();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GP Gold',
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      locale: const Locale('en'),
      supportedLocales: const [
        Locale('en'),
        Locale('gu'),


        Locale('hi')
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      theme: ThemeData(
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }

  // final upgrader = Upgrader(
  //   storeController: UpgraderStoreController(
  //     onAndroid: () => UpgraderAppcastStore(appcastURL: appcastURL, osVersion: osVersion),
  //   ),
  // );
}