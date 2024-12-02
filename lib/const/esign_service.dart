import 'package:flutter/services.dart';

class EsignService {
  static const platform = MethodChannel('com.example.intent');

  EsignService() {
    platform.setMethodCallHandler(_handleCallback);
  }

  Future<void> startActivityForResult() async {
    try {
      final result = await platform.invokeMethod('startActivityForResult');
      print(result);  // Logs "Intent started!"
    } on PlatformException catch (e) {
      print("Failed to start intent: ${e.message}");
    }
  }

  Future<void> _handleCallback(MethodCall call) async {
    if (call.method == 'onActivityResult') {
      String result = call.arguments;
      // Handle the result (e.g., display the message)
      print("Result from activity: $result");
    }
  }
  
}
