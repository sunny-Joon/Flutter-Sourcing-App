import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xml/xml.dart';

class GlobalClass {
  // Singleton pattern to ensure only one instance of GlobalClass
  GlobalClass._privateConstructor();
  static final GlobalClass _instance = GlobalClass._privateConstructor();
  factory GlobalClass() {
    return _instance;
  }

  static String id = "";
  static String creator = "BAREILLY";
  static String address = "";
  static String mobile = "";
  static String designation = "";
  static String validity = "";
  static String areaCode = "";
  static String password = "";
  static String userName = "";
  static String token = "";
  static String collectionToken = "";
  static String liveToken = "";
  static String tag = "";
  static String imei = "";
  static String databaseName = "";
  static String dbName = "kDnH5KSEQ2zYUc1sg63RQg==";
  static String deviceId = "";
  static int target = 0;
  static String? appVersion;

  static const List<String> storeValues = ['YES', 'NO'];
  static const List<String> oneToNine = ['1', '2', '3','4', '5', '6','7', '8', '9'];
  static const List<String> lenderType = ['Organised Sector', 'Unorganised Sector'];


  // Method to show a success alert
  static void showSuccessAlert(BuildContext context,String Message,int a) {
    showAlert(
      context,
      'Successful',
      Message,
      Colors.green,
      a
    );
  }

  // Method to show an unsuccessful alert
  static void showUnsuccessfulAlert(BuildContext context,String Message,int a) {
    showAlert(
      context,
      'Faliure',
      Message,
      Colors.blue,
      a
    );
  }

  // Method to show a network error alert
  static void showErrorAlert(BuildContext context,String Message,int a) {
    showAlert(
      context,
      'Error',
      Message,
        Color(0xFFD42D3F),
      a
    );
  }

  // Private method to show an alert dialog
  static void showAlert(BuildContext context, String title, String message, Color color, int a) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.info, color: color, size: 28),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color, // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (a == 1) {
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Close the page
                }
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
  int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    return pickedImage != null ? File(pickedImage.path) : null;
  }

  static void showSnackBar(BuildContext context,String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$message")),
    );
  }
  static void showToast_Error(String message) {
    Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  static bool isXml(String data) {
    // Trim whitespace to ensure valid checking
    final trimmedData = data.trim();

    // Check if it starts with "<" and ends with ">"
    if (trimmedData.startsWith('<') && trimmedData.endsWith('>')) {
      try {
        // Try parsing the string using XML parser
        final xmlDoc = XmlDocument.parse(trimmedData);
        return true; // Successfully parsed, so it's valid XML
      } catch (e) {
        return false; // Parsing failed, so it's not valid XML
      }
    }
    return false; // Does not start and end with < and >
  }

}
