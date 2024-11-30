import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/Models/GlobalModel2.dart';
import 'package:flutter_sourcing_app/StepperSS.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ApiService.dart';
import 'GlobalClass.dart';
import 'LoginPage.dart';
import 'Models/GlobalModel.dart';
import 'StepperSd.dart';
import 'package:http/http.dart'as http;
import 'package:url_launcher/url_launcher.dart';


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
                // downloadApk('https://erpservice.paisalo.in:980/PDL.Mobile.Api/api/ApkApp/Csp');
                // setState(() {
                //   Navigator.of(context).pop();
                //   _showDownloadingDialog(context);
                // });
                //await Clipboard.setData(ClipboardData(text: "https://erpservice.paisalo.in:980/PDL.Mobile.Api/api/ApkApp/Csp"));
                // copied successfully

                // Navigator.pushReplacement(
                //   context as BuildContext,
                //   MaterialPageRoute(
                //     builder: (context) => (MyWebView(url: url,)),
                //   ),
                // );
                _launchURLBrowser(url);
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _launchURLBrowser(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }
  Future<void> checkForLocalServerUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;
    GlobalClass.appVersion=packageInfo.version;

    try {
     GlobalModel response= await ApiService.create(baseUrl: ApiConfig.baseUrl1).VersionCheck(GlobalClass.dbName, appVersion,"S","1");

      if (response.statuscode == 200) {

        // if (appVersionModel.data is int) {
        print(response.toJson());
          bool isvalid = response.data[0].isvalid;

          if(isvalid){
            _showUpdateDialog(context,response.data[0].appLink);
          }else{
            Timer(Duration(seconds: 3), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            });
          }


        // } else if (appVersionModel.data is String) {
        //
        //   String stringValue = appVersionModel.data;
        //   print("Response for App Version ${stringValue}");
        //   if(apkDownloaded==0){
        //     _showUpdateDialog(context,stringValue.trim());
        //
        //   }else if(apkDownloaded==2){
        //     _showDownloadingDialog(context);
        //
        //   }else{
        //     _showDownloadedDialog(context);
        //   }
        //
        // } else {
        //   // Handle other types if necessary
        // }
      } else {
        // Handle error

      }
    } catch (e) {
      print(e);
      // Handle exception
     }
  }

}
