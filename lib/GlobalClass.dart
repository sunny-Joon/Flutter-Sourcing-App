import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GlobalClass {
  // Singleton pattern to ensure only one instance of GlobalClass
  GlobalClass._privateConstructor();
  static final GlobalClass _instance = GlobalClass._privateConstructor();
  factory GlobalClass() {
    return _instance;
  }

  static String id = "";
  static String creator = "";
  static String address = "";
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
  static double? longitude;
  static double? latitude;

  static const List<String> storeValues = ['YES', 'NO'];
  static const List<String> oneToNine = ['1', '2', '3','4', '5', '6','7', '8', '9'];
  static const List<String> lenderType = ['Organised Sector', 'Unorganised Sector'];


  // Method to show a success alert
  void showSuccessAlert(BuildContext context) {
    showAlert(
      context,
      'Successful',
      'Data saved successfully.',
      Colors.green,
    );
  }

  // Method to show an unsuccessful alert
  void showUnsuccessfulAlert(BuildContext context) {
    showAlert(
      context,
      'Unsuccessful',
      'Data not saved.',
      Colors.red,
    );
  }

  // Method to show a network error alert
  void showErrorAlert(BuildContext context) {
    showAlert(
      context,
      'Error',
      'Network loss.',
      Colors.orange,
    );
  }

  // Private method to show an alert dialog
  void showAlert(BuildContext context, String title, String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: color),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the page
              },
              child: Text('OK'),
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

  Future<String?> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      return pickedImage.path;
    }
    return null;
  }

}
