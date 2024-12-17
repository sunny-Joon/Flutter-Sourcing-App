import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/global_class.dart';
import 'package:flutter_sourcing_app/popup_dialog.dart';
import 'package:flutter_sourcing_app/share_device_id.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api_service.dart';
import 'chat_bot.dart';
import 'device_id_generator.dart';
import 'fragments.dart';
import 'Models/login_model.dart';
import 'terms_conditions.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {

  late String refToken, target;
  bool _isObscure = true;
 /* bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // Define your custom color
    const Color customColor = Color(0xFFD42D3F);
    TextEditingController passwordControllerlogin = TextEditingController(text: '12345');
    final TextEditingController mobileControllerlogin = TextEditingController(text: 'GRST002064');
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
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // _buildBackButton(context),
                  _buildMenuButton(context),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Image.asset(
                    'assets/Images/paisa_logo.png', // Adjust the image path
                    width: double.infinity,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Ver: 1.1',
                      style: TextStyle(fontFamily: "Poppins-Regular",color: customColor),
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
                    style: TextStyle(fontFamily: "Poppins-Regular",
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
                          hintText: 'ABCD123456',
                          hintStyle: TextStyle(fontFamily: "Poppins-Regular",color: Colors.grey.shade400), // Hint color grey
                        ),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),


                  SizedBox(height: 2),
                  Text(
                    'User Name must be at least 10 characters',
                    style: TextStyle(fontFamily: "Poppins-Regular",
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    'Password',
                    style: TextStyle(fontFamily: "Poppins-Regular",
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
                                hintStyle: TextStyle(fontFamily: "Poppins-Regular",color: Colors.grey.shade400),
                              ),
                              obscureText: _isObscure,
                              style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 18),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isObscure ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                          // Placeholder for Lottie animation
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Password must be at least 5 characters',
                    style: TextStyle(fontFamily: "Poppins-Regular",
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 50),
                //  Padding(
                  //  padding: const EdgeInsets.symmetric(horizontal: 25),
                  ElevatedButton(
                      onPressed: () async {
                        if(validateIdPassword(context,mobileControllerlogin.text, passwordControllerlogin.text)){
                          _getLogin(mobileControllerlogin.text, passwordControllerlogin.text, context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, // Text color
                        backgroundColor: customColor, // Background color
                        minimumSize: Size(double.infinity, 45), // Full width with a height of 65
                        textStyle: TextStyle(fontFamily: "Poppins-Regular",fontSize: 18),
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
                          style: TextStyle(fontFamily: "Poppins-Regular",
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
                          style: TextStyle(fontFamily: "Poppins-Regular",
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
      floatingActionButton: buildSupportFAB(context),
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
    // String? DeviceID = await generateDeviceId(userName) as String?;
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
          GlobalClass.imei = value.data.tokenDetails.imeino;
          print('object0');

          if(value.data.foImei.length>0) {
            print('object');
            GlobalClass.target = value.data.foImei[0].targetCommAmt;
            GlobalClass.creator = value.data.foImei[0].creator ?? '';
            GlobalClass.mobile=value.data.foImei[0].mobNo;
            GlobalClass.userName=value.data.foImei[0].name;
            GlobalClass.designation=value.data.foImei[0].designation;
            EasyLoading.dismiss();

          }else{
            EasyLoading.dismiss();
            PopupDialog.showPopup(
                context, value.statuscode.toString(), value.message);
          }
          EasyLoading.dismiss();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Fragments()));
        }
        EasyLoading.dismiss();

      } else {
        EasyLoading.dismiss();
        PopupDialog.showPopup(
            context, value.statuscode.toString(), value.message);
      }

    }).catchError((error){
      EasyLoading.dismiss();
      GlobalClass.showErrorAlert(context, error.toString(), 1);
    });
  }

  Future<void> _launchURLBrowser(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  Widget _buildMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        String url = '';
        if (value == 'App Link') {
          url = 'https://erpservice.paisalo.in:980/PDL.Mobile.Api/api/ApkApp/paisaloSourcingApp';
        } else if (value == 'RD Service Link') {
          url = 'https://erpservice.paisalo.in:980/PDL.Mobile.Api/api/ApkApp/AndroidRDService';
        } else if (value == 'NSDL Link') {
          url = 'https://erpservice.paisalo.in:980/PDL.Mobile.Api/api/ApkApp/AndroidNSDL';
        }
        _launchURLBrowser(url);
      },
      itemBuilder: (BuildContext context) => [
        // App Link Item
        PopupMenuItem<String>(
          value: 'App Link',
          child: Row(
            children: [
              Icon(Icons.link, color: Color(0xFFD42D3F), size: 20),
              SizedBox(width: 10),
              Text('App Link'),
            ],
          ),
        ),
        // Divider between items
        PopupMenuDivider(),
        // RD Service Link Item
        PopupMenuItem<String>(
          value: 'RD Service Link',
          child: Row(
            children: [
              Icon(Icons.build, color: Color(0xFFD42D3F), size: 20),
              SizedBox(width: 10),
              Text('RD Service Link'),
            ],
          ),
        ),
        // Divider between items
        PopupMenuDivider(),
        // NSDL Link Item
        PopupMenuItem<String>(
          value: 'NSDL Link',
          child: Row(
            children: [
              Icon(Icons.business, color: Color(0xFFD42D3F), size: 20),
              SizedBox(width: 10),
              Text('NSDL Link'),
            ],
          ),
        ),
      ],
      // Customize the menu's background color
      offset: Offset(0, 40),  // Position the menu properly if needed
      color: Colors.white,     // Set the background color of the menu
      child: _buildIconContainer(Icons.menu, color: Color(0xFFD42D3F)),
    );
  }

  Widget _buildIconContainer(IconData icon, {Color color = Colors.grey}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      height: 40,
      width: 40,
      alignment: Alignment.center,
      child: Icon(icon, size: 16, color: color),
    );
  }

  Widget buildSupportFAB(BuildContext context) {
    return SpeedDial(
      icon: Icons.support,
      activeIcon: Icons.close,
      backgroundColor: Color(0xFFD42D3F),
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      children: [
        SpeedDialChild(
          child: Icon(Icons.chat),
          label: 'Chatbot',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatActivity()),
            );
          },
        ),
        SpeedDialChild(
          child: Icon(FontAwesomeIcons.whatsapp),
          label: 'WhatsApp Support',
          onTap: () async {
            const whatsappUrl = 'https://wa.me/918595847059?text=Hello';
            if (await canLaunch(whatsappUrl)) {
              await launch(whatsappUrl);
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Error'),
                  content: Text('WhatsApp is not installed. Please install WhatsApp first.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.call),
          label: 'Call Support',
          onTap: () => _makePhoneCall('918595847059'),
        ),
        SpeedDialChild(
          child: Icon(Icons.message),
          label: 'Text Support',
          onTap: () => _sendTextMessage('918595847059'),
        ),
        SpeedDialChild(
          child: Icon(Icons.email),
          label: 'Email Support',
          onTap: () => _sendEmail('techsupport1@paisalo.in'),
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _sendTextMessage(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch SMS app';
    }
  }

  Future<void> _sendEmail(String emailAddress) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
    );
    await launchUrl(launchUri);
  }

  bool validateIdPassword(BuildContext context,String Id,String password) {
    if(Id == null || Id =="" || password == null || password == "" || password.length<5 || Id.length <10 || Id.length>11){
      GlobalClass.showErrorAlert(context, "Wrong Id or Password", 1);
      return false;
    }else{
      return true;
    }
  }

}
