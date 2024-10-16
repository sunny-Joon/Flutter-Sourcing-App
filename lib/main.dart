import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'ApiService.dart';
import 'LoginPage.dart';
import 'QRDATA.dart';
import 'QRScanPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  requestPermissions(); // Request permissions when the app starts
  runApp(const MyApp());
}

void requestPermissions() async {
  // Request permissions
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.phone,
    Permission.storage,
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
      create: (context) => ApiService.create(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: LoginPage(),
          home:LoginPage(),
      ),
    );
  }
}
