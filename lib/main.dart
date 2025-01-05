import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/Models/global_model2.dart';
import 'package:flutter_sourcing_app/collection.dart';
import 'package:flutter_sourcing_app/stepper_ss.dart';
import 'package:flutter_sourcing_app/submit_ss_qrtransaction.dart';
import 'package:flutter_sourcing_app/utils/localnotificationservice.dart';
 import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'crif.dart';
import 'global_class.dart';
import 'house_visit_form.dart';
import 'login_page.dart';
import 'Models/global_model.dart';
import 'stepper_sd.dart';
import 'package:http/http.dart'as http;
import 'package:url_launcher/url_launcher.dart';

import 'dealer_homepage.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }else{
      print("Notification permission allowed");
    }
  });
  requestPermissions(); // Request permissions when the app starts+

  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; // Change here
  _firebaseMessaging.setAutoInitEnabled(true);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _firebaseMessaging.getToken().then((token){
    prefs.setString("GSMID", token!);
    print("token is $token");
  });
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if(message != null){
      LocalNotificationService.display(message);
      print("getInitialMessage-     ${message}");

    }
  });

  ///forground work
  FirebaseMessaging.onMessage.listen((message) {
    if(message.notification != null){
      print(message.notification?.body);
      print(message.notification?.title);
      print("forground-     ${message.notification?.title}");

    }
    LocalNotificationService.display(message);

  });

  ///When the app is in background but opened and user taps
  ///on the notification
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    final routeFromMessage = message.data["data"];
    // Navigator.of(context).pushNamed(routeFromMessage);
    LocalNotificationService.display(message);
    print("background_OpenedApp-     ${message.notification?.title}");

  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Allow only portrait up orientation
    // DeviceOrientation.portraitDown, // Uncomment to allow upside-down portrait
    // DeviceOrientation.landscapeLeft, // Uncomment to allow landscape left
    // DeviceOrientation.landscapeRight, // Uncomment to allow landscape right
  ]).then((_) {
    runApp(MyApp());
  });
  configLoading();
}
void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false
    ..dismissOnTap = true;
}

void requestPermissions() async {
  // Request permissions
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.microphone,
    Permission.phone,
    Permission.location,
    Permission.notification, // Note: Permission.internet is not needed, as it's automatically granted.
  ].request();

  // Check each permission status
  statuses.forEach((permission, status) {
    if (status.isGranted) {
      print('$permission is granted');
    } else if (status.isDenied) {
      print('$permission is denied');
    } else if (status.isPermanentlyDenied) {
      print('$permission is permanently denied');
      // You can show a dialog to the user explaining why the permission is needed
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    EasyLoading.init();
    return Provider<ApiService>(
      create: (context) => ApiService.create(baseUrl:ApiConfig.baseUrl1),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFF3C3C)),
          useMaterial3: true,
        ),
      home: SplashScreen(),
         //home: LoanEligibilityPage( ficode: 101009,),
         builder: EasyLoading.init(),
      ),
    );
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkForLocalServerUpdate();
    // Navigate to Home Screen after 3 seconds

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child:Image.asset('assets/Images/logo.gif'),
          ),
        ],
      ),
    );
  }
  void _showUpdateDialog(BuildContext context,String url) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text('Update Available'),
          content: Text('A new version of the app is available. Please update to the latest version.'),
          actions: <Widget>[
            TextButton(
              child: Text('Download App'),
              onPressed: () async {
                _launchURLBrowser();
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
               exit(0);
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _launchURLBrowser() async {
    final Uri _url = Uri.parse("https://predeptest.paisalo.in:8084/PDL.Mobile.Api/api/ApkApp/paisaloSourcingApp");
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }
  Future<void> checkForLocalServerUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;
    GlobalClass.appVersion=packageInfo.version;

       ApiService.create(baseUrl: ApiConfig.baseUrl1).VersionCheck(GlobalClass.dbName, appVersion,"S","1").then((response){

         if (response.statuscode == 200) {

           bool isvalid = response.data[0].isvalid;

           if(!isvalid){
             _showUpdateDialog(context,response.data[0].appLink);
           }else{
             Timer(Duration(seconds: 3), () {
               Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(builder: (context) => LoginPage()),
               );
             });
           }
         } else {
           GlobalClass.showErrorAlert(context, "Please check internet connection", 1);

         }
       }).catchError((onError){
         GlobalClass.showErrorAlert(context, "${onError}", 1);

       });
  }
}


