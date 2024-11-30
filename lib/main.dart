import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/StepperSS.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ApiService.dart';
import 'LoginPage.dart';
import 'StepperSd.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  requestPermissions(); // Request permissions when the app starts+
  runApp(const MyApp());
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
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFD42D3F)),
          useMaterial3: true,
        ),
         home: SplashScreen(),
         builder: EasyLoading.init(),
         // home:MultiStepForm(),
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
    // Navigate to Home Screen after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
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
}
