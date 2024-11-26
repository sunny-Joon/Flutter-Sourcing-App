import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/GlobalClass.dart';
import 'package:flutter_sourcing_app/PopupDialog.dart';
import 'package:flutter_sourcing_app/SharedeviceId.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ApiService.dart';
import 'DeviceIdGenerator.dart';
import 'Fragments.dart';
import 'Models/login_model.dart';
import 'TermsConditions.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {

  late String refToken, target;
 /* bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;*/

  @override
  Widget build(BuildContext context) {
    // Define your custom color
    const Color customColor = Color(0xFFD42D3F);
    TextEditingController passwordControllerlogin = TextEditingController(text: '12345');
    final TextEditingController mobileControllerlogin =
        TextEditingController(text: 'GRST002064');
    String deviceId = '';

    // Check and request permissions
    _checkAndRequestPermissions(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Align all text to the left
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  Image.asset(
                    'assets/Images/paisa_logo.png', // Adjust the image path
                    width: double.infinity,
                  ),
                  SizedBox(height: 80),
                  Center(
                    child: Text(
                      'Ver: 1.1',
                      style: TextStyle(color: customColor),
                    ),
                  ),
                  SizedBox(height: 20),
                 /* Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade400), // Grey border
                    ),elevation: 0,
                    color: Colors.white, // White background
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(), // Removes the underline
                        items: [
                          DropdownMenuItem<String>(
                            value: "Database1",
                            child: Text("Database1"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Database2",
                            child: Text("Database2"),
                          ),
                        ],
                        onChanged: (String? newValue) {},
                        hint: Text('Select Database'),
                      ),
                    ),
                  ),*/

                  SizedBox(height: 20),
                  Text(
                    'User ID',
                    style: TextStyle(
                      color: customColor,
                      fontSize: 20,
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade400), // Grey border
                    ),
                    elevation: 0, // Remove elevation
                    color: Colors.white, // Set background color to white
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextField(
                        controller: mobileControllerlogin,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'GRST000223',
                          hintStyle: TextStyle(color: Colors.grey.shade400), // Hint color grey
                        ),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),


                  SizedBox(height: 5),
                  Text(
                    'User Name must be at least 10 characters',
                    style: TextStyle(
                      color: customColor,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    'Password',
                    style: TextStyle(
                      color: customColor,
                      fontSize: 20,
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade400), // Grey border
                    ),
                    elevation: 0,
                    color: Colors.white, // Set background color to white
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: passwordControllerlogin,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '*****',
                                hintStyle: TextStyle(color: Colors.grey.shade400), // Hint color greyS
                              ),
                              obscureText: true,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Icon(Icons.visibility),
                          // Placeholder for Lottie animation
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Password must be at least 5 characters',
                    style: TextStyle(
                      color: customColor,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 50),
                //  Padding(
                  //  padding: const EdgeInsets.symmetric(horizontal: 25),
                  ElevatedButton(
                      onPressed: () async {
                        _getLogin(mobileControllerlogin.text, passwordControllerlogin.text, context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, // Text color
                        backgroundColor: customColor, // Background color
                        minimumSize: Size(double.infinity, 45), // Full width with a height of 65
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0), // Rectangular corners
                        ),
                      ),
                      child: Text('LOGIN'),
                    ),
              //    ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          if (mobileControllerlogin.text.isEmpty) {
                            // Show popup if UserId is blank
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content:
                                      const Text('UserId cannot be blank.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // Fetch deviceId and navigate only if successful
                            String? deviceId = await generateDeviceId(
                                mobileControllerlogin.text) as String?;
                            if (deviceId != null && deviceId.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Sharedeviceid(
                                    mobile: mobileControllerlogin.text,
                                    deviceid: deviceId,
                                  ),
                                ),
                              );
                            } else {
                              // Handle the case where deviceId is not fetched
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                        'Failed to generate Device ID.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Share Device Id',
                          style: TextStyle(
                            color: customColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsConditions()),
                          );
                        },
                        child: Text(
                          'Terms & Conditions',
                          style: TextStyle(
                            color: customColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      /*floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isExpanded) ...[
            ScaleTransition(
              scale: _animation,
              alignment: Alignment.bottomCenter,
              child: _buildFab(Icons.chat, 'Chatbot', () {
                // Your chatbot action here
              }),
            ),
            ScaleTransition(
              scale: _animation,
              alignment: Alignment.bottomCenter,
              child: _buildFab(Icons.email, 'Email', () {
                // Your email action here
              }),
            ),
            ScaleTransition(
              scale: _animation,
              alignment: Alignment.bottomCenter,
              child: _buildFab(Icons.call, 'Call Support', () {
                // Your call support action here
              }),
            ),
            ScaleTransition(
              scale: _animation,
              alignment: Alignment.bottomCenter,
              child: _buildFab(Icons.call, 'WhatsApp', () {
                // Your WhatsApp action here
              }),
            ),
          ],
          FloatingActionButton(
            onPressed: _toggle,
            child: Icon(_isExpanded ? Icons.close : Icons.add),
          ),
        ],
      ),*/
    );
  }

  Future<bool> _checkAndRequestPermissions(BuildContext context) async {
    final permissions = [
      Permission.camera,
      Permission.location,
      Permission.phone,
      Permission.notification,
    ];

    final statuses = await Future.wait(permissions.map((perm) => perm.status));

    // Check if all permissions are granted
    bool allGranted = statuses.every((status) => status.isGranted);

    if (!allGranted) {
      bool? shouldProceed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('Permissions Required'),
          content: Text(
              'This app requires certain permissions to function correctly. Please grant the necessary permissions.'),
          actions: [
            TextButton(
              onPressed: () async {
                await openAppSettings();
                Navigator.of(context).pop(false); // User chose to deny
              },
              child: Text('Open Settings'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User chose to deny
              },
              child: Text('Deny'),
            ),
          ],
        ),
      );

      if (shouldProceed == false) {
        // Exit the app if permissions are denied
        // Use this line to close the app if needed
        // exit(0); // Uncomment to force exit
        return false;
      } else {
        // Optionally, you can recheck permissions after the user has opened settings
        return await _checkPermissions();
      }
    }

    return true;
  }

  Future<bool> _checkPermissions() async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
      Permission.location,
      Permission.storage,
      Permission.phone,
      Permission.notification,
    ];

    final statuses =
        await Future.wait(permissions.map((perm) => perm.request()));

    return statuses.every((status) => status.isGranted);
  }

  Future<void> _getLogin( String userName, String userPassword, BuildContext context) async {
     EasyLoading.show(status: 'Loading...',);
    final api = Provider.of<ApiService>(context, listen: false);
    Map<String, dynamic> requestBody = {
      "userName": userName,
      "password": userPassword,
      "GsmId": "SSTST002064"
    };

    return await api
        .getLogins("0646498585477244", GlobalClass.dbName, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        refToken = value.data.tokenDetails.token.toString();
        if (value.message == 'Login Successfully !!') {
          // Assign values to GlobalClass static members

          GlobalClass.token = 'Bearer ' + refToken;
          GlobalClass.deviceId = value.data.tokenDetails.deviceSrNo;
          GlobalClass.id = value.data.tokenDetails.userName;
          GlobalClass.validity = value.data.tokenDetails.validity;
          GlobalClass.imei = value.data.foImei.toString() ?? '';
          print('object0');

          if(value.data.foImei.length>0) {
            print('object');
            GlobalClass.target = value.data.foImei[0].targetCommAmt;
            GlobalClass.creator = value.data.foImei[0].creator ?? '';
            GlobalClass.mobile=value.data.foImei[0].mobNo;
            GlobalClass.userName=value.data.foImei[0].name;
            GlobalClass.designation=value.data.foImei[0].designation;

          }else{
            PopupDialog.showPopup(
                context, value.statuscode.toString(), value.message);
          }
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Fragments()));
        }
        EasyLoading.dismiss();
      } else {
        PopupDialog.showPopup(
            context, value.statuscode.toString(), value.message);
        //  _showErrorDialog(context);
        EasyLoading.dismiss();
      }

    });
  }

  Widget _buildFab(IconData icon, String tooltip, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: FloatingActionButton(
        onPressed: onPressed,
        tooltip: tooltip,
        child: Icon(icon),
      ),
    );
  }

  /*void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }*/


}
