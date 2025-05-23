import 'dart:async';
import 'dart:io';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sourcing_app/utils/localnotificationservice.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_service.dart';
import 'LoginPage/languageprovider.dart';
import 'LoginPage/login_page.dart';
import 'global_class.dart';
import 'package:http/http.dart'as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
   androidProvider: AndroidProvider.debug,
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
  ]).then((_) {
    runApp(ChangeNotifierProvider(create: (context) => languageprovider(),
      child: const MyApp(),
    ));
  });
  configLoading();
}
void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false
    ..dismissOnTap = false;
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
    } else if (status.isDenied) {
    } else if (status.isPermanentlyDenied) {
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

        supportedLocales: const[
          Locale('en'),
          Locale('hi'),
          Locale('mr'),
          Locale('bn')
        ],

        locale:context.watch<languageprovider>().selectedLocale,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFF3C3C)),
          useMaterial3: true,
        ),
        home: SplashScreen(),
        //home: LoanEligibilityPage( ficode: 123,),
        //  home: DealerHomePage(),
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
        print("isvalid2");

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
    print("GlobalClass.appVersion $GlobalClass.appVersion");
    print("packageInfo.version $packageInfo.version");

       ApiService.create(baseUrl: ApiConfig.baseUrl1).VersionCheck(GlobalClass.dbName, appVersion,"S","1").then((response){

         if (response.statuscode == 200) {
           bool isvalid = response.data[0].isvalid;
           print("isvalid $isvalid");

           if(!isvalid){
             print("isvalid1 $isvalid");
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
         GlobalClass.showErrorAlert(context, "Please check internet connection", 1);
       //  GlobalClass.showErrorAlert(context, "${onError}", 1);
       });
  }

}


