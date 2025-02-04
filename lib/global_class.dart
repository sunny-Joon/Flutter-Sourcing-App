import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/Models/login_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xml/xml.dart';

import 'collectionbranchlist.dart';

class GlobalClass {
  // Singleton pattern to ensure only one instance of GlobalClass
  GlobalClass._privateConstructor();
  static final GlobalClass _instance = GlobalClass._privateConstructor();
  factory GlobalClass() {
    return _instance;
  }

  static String id = "";
  static List<GetCreatorList> creatorlist = [];
  static String creatorId = "";

  static int rank = 0;
  static String creator = "";
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
  static String banner_name = "";
  static String flash_image_name = "";
  static String flash_advertisement = "";
  static String flash_description = "";
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
  static void showSuccessAlertclose(
      BuildContext context, String message, int a,
      {Widget? destinationPage}) {
    showAlert1(context, 'Successful', message, Colors.green, a,
        destinationPage: destinationPage);
  }

  // Method to show an unsuccessful alert
    static void showUnsuccessfulAlert(BuildContext context,String Message,int a) {
      showAlert(
        context,
        'Failure',
        Message,
        Colors.blue,
        a
      );
    }


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
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async {
          // Prevent the dialog from closing when back button is pressed
          return false;
        },
        child: AlertDialog(
          backgroundColor: Colors.white,
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
                  style: TextStyle(fontFamily: "Poppins-Regular",
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
            style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 16, color: Colors.black87),
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
                 /* if(context == CollectionBranchListPage){
                     // Close the popup

                  }*/
                  Navigator.of(context).pop(); // Close the dialog
                } else if (a == 2) {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Close the page
                  Navigator.of(context).pop(); // Close the page
                  Navigator.of(context).pop(); // Close the page
                }
              },
              child: Text(
                'OK',
                style: TextStyle(fontFamily: "Poppins-Regular",color: Colors.white),
              ),
            ),
          ],
        )
        );
      },
    );
  }


  static void showAlert1(BuildContext context, String title, String message,
      Color color, int a,
      {Widget? destinationPage}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () async {
            // Prevent the dialog from closing when back button is pressed
            return false;
          },
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),
            ),
            title: Row(
              children: [
                Icon(Icons.info, color: color, size: 28),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: "Poppins-Regular",
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
              style: TextStyle(
                  fontFamily: "Poppins-Regular",
                  fontSize: 16,
                  color: Colors.black87),
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
                  if (destinationPage != null) {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => destinationPage),
                    );
                  } else {
                    if (a == 1) {
                      Navigator.of(context).pop(); // Close the dialog
                    } else if (a == 2) {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.of(context).pop(); // Close the dialog
                    } else {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.of(context).pop(); // Close the page
                      Navigator.of(context).pop(); // Close the page
                      Navigator.of(context).pop(); // Close the page
                    }
                  }
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                      fontFamily: "Poppins-Regular", color: Colors.white),
                ),
              ),
            ],
          ));
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

  static String getTodayDate() {
    final now = DateTime.now();
    return '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';
  }
  static String getCurrentYear() {
    final now = DateTime.now();
    return now.year.toString();
  }

  static String getCurrentMonth() {
    final now = DateTime.now();
    // Get the full month name using DateFormat
    return DateFormat('MMMM').format(now); // 'MMMM' returns the full month name
  }

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    final croppedImage =_cropImage(new File(pickedImage!.path));
    return croppedImage != null ? croppedImage : null;
  }
  Future<File?> _cropImage(File imageFile) async {
    if (imageFile != null) {
      CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: imageFile!.path,
          compressQuality: 100,
          maxHeight: 700,
          maxWidth: 700,
          compressFormat: ImageCompressFormat.jpg,

          uiSettings: [
            AndroidUiSettings(
                toolbarColor: Color(0xFFD42D3F),
                toolbarTitle: 'Crop',
                toolbarWidgetColor: Colors.white,
                cropGridColor: Colors.black,
                backgroundColor: Color(0xFFD42D3F),
                cropFrameColor: Color(0xFFD42D3F),
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(title: 'Crop')
          ]);

      if (cropped != null) {
        return File(cropped.path);
      }else{
        return null;
      }
    }
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


  String transformFilePathToUrl(String filePath) {
    const String urlPrefix = 'https://predeptest.paisalo.in:8084/LOSDOC//FiDocs//';
    const String localPrefix = 'D:\\LOSDOC\\FiDocs\\';
    if (filePath.startsWith(localPrefix)) {
      // Remove the local prefix and replace with the URL prefix
      return filePath.replaceFirst(localPrefix, urlPrefix).replaceAll('\\', '//');
    }
    // Return the filePath as is if it doesn't match the local prefix
    return filePath;
  }

  Widget ListShimmerItem() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2, bottom: 2),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        elevation: 5,
        child: Container(
          height: 60, // Increased height for better visibility
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Shimmer.fromColors(
            direction: ShimmerDirection.ltr,
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Row(
              children: [
                // Circle
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 16),
                // Branch Name
                Expanded(
                  child: Text(
                    'Loading ...',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Arrow
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade300,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
