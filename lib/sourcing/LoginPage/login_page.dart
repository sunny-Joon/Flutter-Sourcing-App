import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_sourcing_app/Models/banner_post_model.dart';
import 'package:flutter_sourcing_app/sourcing/LoginPage/share_device_id.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../EncryptionUtils.dart';
import '../../api_service.dart';
import '../OnBoarding/fragments.dart';
import '../global_class.dart';
import 'chat_bot.dart';
import 'device_id_generator.dart';
import 'languageprovider.dart';
import 'terms_conditions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String refToken, target;
  bool _isObscure = true;
  late TextEditingController passwordControllerlogin =
      TextEditingController(text: 'Admin@12');
  late TextEditingController mobileControllerlogin =
      TextEditingController(text: 'GRST002064');

  final LocalAuthentication auth = LocalAuthentication();
  bool _showBiometricIcon = false;
  bool isAvailable=false;
  bool isDeviceSupported=false;
  bool _loginCalled = false;
  /* bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;*/
  String appVersion = "0.0";

  //securityquestion
  /*final TextEditingController answerController = TextEditingController();

  String? selectedQuestion;
  String? answer;
   List<String> securityQuestions = [
    'What is your school name?',
    'What is your father\'s name?',
    'What is your birthplace?',
    'What was your first pet\'s name?',
    'What is your favorite food?'
  ];*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppVersion();
    _checkBiometricAvailability();
    mobileControllerlogin.text="GRST002064";
    passwordControllerlogin.text="Admin@12";
  }

  @override
  void dispose() {
    passwordControllerlogin.dispose();
    mobileControllerlogin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define your custom color
    const Color customColor = Color(0xFFD42D3F);
    //passwordControllerlogin = TextEditingController(text: '');
    //mobileControllerlogin = TextEditingController(text: '');
    String deviceId = '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Align all text to the left
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupMenuButton<String>(
                    color: Colors.blueGrey,
                    icon: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset(
                          'assets/Images/languages.png',
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                    ),
                    onSelected: (value) {
                      context.read<languageprovider>().changelanguage(value);
                    },
                    itemBuilder: (BuildContext context) {
                      return languageprovider.language.map((language) {
                        return PopupMenuItem<String>(
                          value: language['locale'],
                          child: Container(
                            color: Colors.yellow,
                            child: Row(
                              children: [
                                Image.asset(
                                  language['icon'],
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(language['name']),
                              ],
                            ),
                          ),
                        );
                      }).toList();
                    },
                  ),
                  // _buildMenuButton(context) on the right
                  _buildMenuButton(context),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Image.asset(
                    'assets/Images/paisa_logo.png', // Adjust the image path
                    width: double.infinity,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Ver: $appVersion',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", color: customColor),
                    ),
                  ),
                  SizedBox(height: 10),
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
                    AppLocalizations.of(context)!.user,
                    style: TextStyle(
                      fontFamily: "Poppins-Regular",
                      color: customColor,
                      fontSize: 20,
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.grey.shade400), // Grey border
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
                          hintStyle: TextStyle(
                              fontFamily: "Poppins-Regular",
                              color: Colors.grey.shade400), // Hint color grey
                        ),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),

                  SizedBox(height: 2),
                  Text(
                    AppLocalizations.of(context)!.usererror,
                    style: TextStyle(
                      fontFamily: "Poppins-Regular",
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    AppLocalizations.of(context)!.password,
                    style: TextStyle(
                      fontFamily: "Poppins-Regular",
                      color: customColor,
                      fontSize: 20,
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.grey.shade400), // Grey border
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
                                hintStyle: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    color: Colors.grey.shade400),
                              ),
                              obscureText: _isObscure,
                              style: TextStyle(
                                  fontFamily: "Poppins-Regular", fontSize: 18),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                    AppLocalizations.of(context)!.passerror,
                    style: TextStyle(
                      fontFamily: "Poppins-Regular",
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 30),
//securityquestion
                /*  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Security Question',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    value: selectedQuestion,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedQuestion = newValue;
                      });
                    },
                    items: securityQuestions.map((String question) {
                      return DropdownMenuItem<String>(
                        value: question,
                        child: Text(question),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 10),
                  TextField(
                    controller: answerController,
                    decoration: InputDecoration(
                      labelText: 'Your Answer',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  // Save Button
                  ElevatedButton(
                    onPressed: saveSecurityQuestionAndAnswer,
                    child: Text("Save Security Info"),
                  ),*/

                /*  Align(
                    alignment: Alignment.centerRight,

                    child:TextButton(
                      onPressed: () {
                        showChangePasswordDialog(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFFD42D3F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10), // some padding
                        minimumSize: Size(0, 0), // ensures no extra space
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // shrink button
                      ),
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.end, // optional, for safety
                      ),
                    ),

                  ),
*/
                  //  Padding(
                  //  padding: const EdgeInsets.symmetric(horizontal: 25),

                  ElevatedButton(
                    onPressed: () async {

                      if (validateIdPassword(
                          context,
                          mobileControllerlogin.text,
                          passwordControllerlogin.text)) {
                        _getLogin(mobileControllerlogin.text,
                            passwordControllerlogin.text, context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      // Text color
                      backgroundColor: customColor,
                      // Background color
                      minimumSize: Size(double.infinity, 45),
                      // Full width with a height of 65
                      textStyle: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(0), // Rectangular corners
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.login),
                  ),

                /*  ElevatedButton(
                    onPressed: () async {

print("_loginCalled$_loginCalled");
                      // Call login only once
                      if (validateIdPassword(
                          context,
                          mobileControllerlogin.text,
                          passwordControllerlogin.text)) {

                        if(_loginCalled){

                            // Show alert if login was already called
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Alert"),
                                content: Text("Please change your password"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text("OK"),
                                  )
                                ],
                              ),
                            );
                            return; // Exit function, don't call API again

                        }else{
                          print("_loginCalled2$_loginCalled");
                          _getLogin(mobileControllerlogin.text,
                              passwordControllerlogin.text, context);
                        }

                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: customColor,
                      minimumSize: Size(double.infinity, 45),
                      textStyle: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.login),
                  ),
*/
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
                                  title:
                                      Text(AppLocalizations.of(context)!.error),
                                  content: Text(
                                      AppLocalizations.of(context)!.usererror),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text(
                                          AppLocalizations.of(context)!.ok),
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
                                    content: Text(AppLocalizations.of(context)!
                                        .faileddeviceid),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!.ok),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context)!.sharedevice,
                          style: TextStyle(
                            fontFamily: "Poppins-Regular",
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
                          AppLocalizations.of(context)!.term,
                          style: TextStyle(
                            fontFamily: "Poppins-Regular",
                            color: customColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Center(
                    child: TextButton(
                      onPressed: () async {
                        _launchprivacypolicy();
                      },
                      child: Text(
                        'Privacy policy',
                        style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          color: customColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),


                  Center(
                    child: _showBiometricIcon
                        ? IconButton(
                            onPressed: _authenticateWithBiometrics,
                            icon: const Icon(Icons.fingerprint,
                                size: 80, color: Colors.green),
                            tooltip: "Login with Biometric",
                          )
                        : const SizedBox(), // Hide the icon
                  ),

                  /*     ElevatedButton(
                    onPressed: _authenticateWithBiometrics,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, // Text color
                      backgroundColor: Colors.green, // Background color
                      minimumSize: const Size(double.infinity, 45), // Full width with a height of 45
                      textStyle: const TextStyle(
                        fontFamily: "Poppins-Regular",
                        fontSize: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0), // Rectangular corners
                      ),
                    ),
                    child: const Text('Login With BioMetric'),
                  ),*/
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
          content: Text(AppLocalizations.of(context)!.necessarypermissions),
          actions: [
            TextButton(
              onPressed: () async {
                await openAppSettings();
                Navigator.of(context).pop(false); // User chose to deny
              },
              child: Text(AppLocalizations.of(context)!.opensetting),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User chose to deny
              },
              child: Text(AppLocalizations.of(context)!.deny),
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
      Permission.location,
      Permission.storage,
      Permission.phone,
      Permission.notification,
    ];

    final statuses =
        await Future.wait(permissions.map((perm) => perm.request()));

    return statuses.every((status) => status.isGranted);
  }

  void handleDioError(dynamic error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.badResponse) {
        if (error.response != null && error.response?.data != null) {
          final data = error.response?.data;
          if (data is Map<String, dynamic>) {
            // Check for 'message' field
            if (data.containsKey('message')) {
              print('Message: ${data['message']}');
            }

            // Check for 'errors' field (if exists)
            if (data.containsKey('errors')) {
              final errors = data['errors'];
              if (errors is Map<String, dynamic>) {
                errors.forEach((key, value) {
                  print('$key: $value');
                });
              }
            }

            // Check for 'data' field
            if (data.containsKey('data')) {
              final dataField = data['data'];
              if (dataField is Map<String, dynamic>) {
                // Access nested 'foImei' or any other nested fields
                if (dataField.containsKey('foImei')) {
                  final foImei = dataField['foImei'];
                  if (foImei is Map<String, dynamic>) {
                    if (foImei.containsKey('errormsg')) {
                      print('Error message from foImei: ${foImei['errormsg']}');
                    }
                    if (foImei.containsKey('isValidate')) {
                      print('Is Validate: ${foImei['isValidate']}');
                    }
                  }
                }
              }
            } else {
              print('Data field not found in response');
            }
          } else {
            print('Response data is not a Map<String, dynamic>');
          }
        } else {
          print('Response or response data is null');
        }
      } else {
        print('DioError type: ${error.type}');
        print('Error message: ${error.message}');
      }
    } else if (error is MapEntry<dynamic, dynamic>) {
      print('Expected error: ${error.toString()}');
    } else {
      print('Unexpected error: ${error.toString()}');
      if (error is TypeError) {
        print('TypeError: ${error}');
      }
    }
  }

  Future<void> _getLogin(
      String userName, String userPassword, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userName);
    await prefs.setString('password', userPassword);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
      );
    });
    final api = Provider.of<ApiService>(context, listen: false);

    Map<String, dynamic> requestBody = {
      "userName": userName,
    //  "password": userPassword,
       "password": EncryptionUtils.encrypt(userPassword),
      "GsmId": "SSTST002064"
    };
    // 0646498585477244 DeviceID grst002064
    // 2234514145687247 DeviceID grst003057
    // String? DeviceID = await generateDeviceId(userName) as String?;
    return await api.getLogins("7110698875679244", GlobalClass.dbName, requestBody).then((value) async {
      try {
        if (value.statuscode == 200) {
          _loginCalled = true;
          print("_loginCalled3$_loginCalled");
          refToken = value.data.tokenDetails.token.toString();
          if (value.message == 'Login Successfully !!') {
            GlobalClass.showSuccessAlert(context, value.message, 1);
           // GlobalClass.showErrorAlert(context, "Your session has expired. Please log in again to continue.", 2);
            // Assign values to GlobalClass static members
            /*    if (value.data.foImei.isEmpty) {
                  EasyLoading.dismiss();
                  GlobalClass.showUnsuccessfulAlert(
                      context, "Error: foImei is empty. Login unsuccessful.", 1);
                  return; // Stop further execution
                }*/
            GlobalClass.token = 'Bearer ' + refToken;
            GlobalClass.deviceId = value.data.tokenDetails.deviceSrNo;

            GlobalClass.id = value.data.tokenDetails.userName;
            GlobalClass.validity = value.data.tokenDetails.validity;
            GlobalClass.imei = value.data.tokenDetails.imeino;
            GlobalClass.EmpId = value.data.tokenDetails.empId;
            print('object0');

            if (value.data.foImei.length > 0) {
              print('object');
              GlobalClass.target = value.data.foImei[0].targetCommAmt;
              GlobalClass.mobile = value.data.foImei[0].mobNo;
              GlobalClass.userName = value.data.foImei[0].name;
              GlobalClass.designation = value.data.foImei[0].designation;
              //  GlobalClass.creator = value.data.foImei[0].creator;
            //  GlobalClass.userType ='Dealer';

              for (var foImeiItem in value.data.foImei) {
                if (foImeiItem.creator != null) {
                  try {
                    var matchedCreator = value.data.getCreatorList.firstWhere(
                      (creatorItem) =>
                          creatorItem.creatorName == foImeiItem.creator,
                    );

                    GlobalClass.creatorId = matchedCreator.creatorId.toString();
                    GlobalClass.creator = matchedCreator.creatorName;
                    print("Matched creatorID: ${GlobalClass.creatorId}");
                    print("Matched creatorName: ${GlobalClass.creator}");
                  } catch (e) {
                    print(
                        "No matching creator found for ${foImeiItem.creator}");
                  }
                }
              }

              EasyLoading.dismiss();
              getBannersAndFlashMessage();
            } else {
              // EasyLoading.dismiss();
              // Navigator.pushReplacement(
              //     context, MaterialPageRoute(builder: (context) => Fragments()));

              EasyLoading.dismiss();
              GlobalClass.showUnsuccessfulAlert(context,
                  value.statuscode.toString() + "," + value.message, 1);
            }

            if (value.data.getCreatorList.isNotEmpty) {
              GlobalClass.creatorlist = value.data.getCreatorList;

              // for (var creatorItem in value.data.getCreatorList) {
              //   if (creatorItem.creatorId != null) {
              //     GlobalClass.creatorId = creatorItem.creatorId.toString();
              //     break;
              //   }
              // }
            } else {
              GlobalClass.showUnsuccessfulAlert(context, value.message, 1);
            }

            // EasyLoading.dismiss();
            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (context) => Fragments()));
          } else {
            EasyLoading.dismiss();
            GlobalClass.showUnsuccessfulAlert(
                context, value.statuscode.toString() + "," + value.message, 1);
          }
        } else {
          EasyLoading.dismiss();
          GlobalClass.showUnsuccessfulAlert(
              context, value.statuscode.toString() + "," + value.message, 1);
        }
      } catch (err) {
        EasyLoading.dismiss();
        GlobalClass.showErrorAlert(context, "SOMETHING WENT WRONG", 1);
        handleDioError(err);
      }
    }).catchError((error) {
      EasyLoading.dismiss();

      if (error is DioException) {
        if (error.type == DioExceptionType.badResponse) {
          if (error.response != null && error.response?.data != null) {
            final data = error.response?.data;
            if (data is Map<String, dynamic>) {
              // Access the 'message' key
              // Further parsing (if necessary)
              if (data.containsKey('data')) {
                final dataField = data['data'];
                if (dataField is Map<String, dynamic>) {
                  if (dataField.containsKey('foImei')) {
                    final foImei = dataField['foImei'];
                    if (foImei is Map<String, dynamic>) {
                      if (foImei.containsKey('errormsg')) {
                        GlobalClass.showErrorAlert(
                            context,
                            'Error message from foImei: ${foImei['errormsg']}',
                            1);
                      }
                      if (foImei.containsKey('isValidate')) {
                        print('Is Validate: ${foImei['isValidate']}');
                        GlobalClass.showErrorAlert(
                            context, 'Is Validate: ${foImei['isValidate']}', 1);
                      }
                    }
                  }
                }
              }
            } else {
              EasyLoading.dismiss();

              GlobalClass.showErrorAlert(
                  context, 'Error message: ${error.message}', 1);
            }
          } else {
            EasyLoading.dismiss();

            GlobalClass.showErrorAlert(
                context, 'Error message: ${error.message}', 1);
          }
        } else {
          EasyLoading.dismiss();

          print('DioError type: ${error.type}');
          print('Error message: ${error.message}');
          GlobalClass.showErrorAlert(
              context, 'Error message: ${error.message}', 1);
        }
      } else {
        EasyLoading.dismiss();
        print('Unexpected error: ${error.toString()}');
        GlobalClass.showErrorAlert(
            context, 'Unexpected error: ${error.toString()}', 1);
      }
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
          url =
              'https://predeptest.paisalo.in:8084/PDL.Mobile.Api/api/ApkApp/paisaloSourcingApp';
        } else if (value == 'RD Service Link') {
          url =
              'https://play.google.com/store/apps/details?id=com.idemia.l1rdservice';
        } else if (value == 'NSDL Link') {
          url =
              'https://erpservice.paisalo.in:980/PDL.Mobile.Api/api/ApkApp/AndroidNSDL';
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
              Text(AppLocalizations.of(context)!.applink),
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
              Text(AppLocalizations.of(context)!.rdservice),
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
              Text(AppLocalizations.of(context)!.nsdl),
            ],
          ),
        ),
      ],
      // Customize the menu's background color
      offset: Offset(0, 40),
      // Position the menu properly if needed
      color: Colors.white,
      // Set the background color of the menu
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
          label: AppLocalizations.of(context)!.chat,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatActivity()),
            );
          },
        ),
        /* SpeedDialChild(
          child: Icon(FontAwesomeIcons.whatsapp),
          label: 'WhatsApp Support',
          onTap: () async {
            const whatsappUrl = 'https://wa.me/+918081108281';
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
        ),*/
        SpeedDialChild(
          child: Icon(Icons.call),
          label: AppLocalizations.of(context)!.callsupport,
          onTap: () => _makePhoneCall('918595847059'),
        ),
        /* SpeedDialChild(
          child: Icon(Icons.message),
          label: 'Text Support',
          onTap: () => _sendTextMessage('918595847059'),
        ),*/
        SpeedDialChild(
          child: Icon(Icons.email),
          label: AppLocalizations.of(context)!.emailsupport,
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

  bool validateIdPassword(BuildContext context, String? id, String? password) {
    if (id == null || id.isEmpty || password == null || password.isEmpty) {
      GlobalClass.showErrorAlert(
          context, AppLocalizations.of(context)!.pleaseidandpass, 1);
      return false;
    } else if (password.length < 3 || id.length < 10 || id.length > 11) {
      GlobalClass.showErrorAlert(
          context, AppLocalizations.of(context)!.invalididandpass, 1);
      return false;
    } else {
      return true;
    }
  }

  void getBannersAndFlashMessage() {
    final api = Provider.of<ApiService>(context, listen: false);
    api
        .getBannersAndFlashMessage(
            GlobalClass.dbName, GlobalClass.token, "S", "B")
        .then((value) {
      if (value.statuscode == 200 &&
          value.data.isNotEmpty &&
          value.data[0].banner.isNotEmpty) {
        print(value.data[0].banner);
        GlobalClass.banner_name = value.data[0].banner;
        print(GlobalClass.banner_name);
      }
      api
          .getBannersAndFlashMessage(
              GlobalClass.dbName, GlobalClass.token, "S", "F")
          .then((value) {
        if (value.statuscode == 200 &&
            value.data.isNotEmpty &&
            value.data[0].banner.isNotEmpty) {
          print(value.data[0].banner);
          if (value.data[0].banner.isNotEmpty) {
            GlobalClass.flash_image_name =
                'https://predeptest.paisalo.in:8084/LOSDOC/BannerPost/${value.data[0].banner}';
          }
          GlobalClass.flash_advertisement = value.data[0].advertisement;
          GlobalClass.flash_description = value.data[0].description;
        }
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Fragments()));
      });
    });
  }

  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    final LocalAuthentication auth = LocalAuthentication();

    try {
       isAvailable = await auth.canCheckBiometrics;
       isDeviceSupported = await auth.isDeviceSupported();

      if (!isAvailable || !isDeviceSupported) {
        GlobalClass.showErrorAlert(
            context, "Biometric authentication not available", 1);
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      String? pass = prefs.getString('password');

      // if (userId == null || pass == null || userId.isEmpty || pass.isEmpty) {
      //   GlobalClass.showErrorAlert(context, "Please enter ID & Password first!", 1);
      //   return;
      // }

      bool authenticated = await auth.authenticate(
        localizedReason: "Use your fingerprint to login",
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        if (validateIdPassword(context, userId, pass)) {
          _getLogin(userId!, pass!, context);
        }
        getBannersAndFlashMessage();
        GlobalClass.showSuccessAlert(
            context, "Biometric Authentication Successful!", 1);
      } else {
        GlobalClass.showErrorAlert(context, "Authentication Failed", 1);
      }
    } on PlatformException catch (e) {
      print("Biometric error: ${e.code} - ${e.message}"); // Debugging
      GlobalClass.showErrorAlert(context, "Biometric error: ${e.message}", 1);
    }
  }

  Future<void> _checkBiometricAvailability() async {
    final LocalAuthentication auth = LocalAuthentication();

     isAvailable = await auth.canCheckBiometrics;
     isDeviceSupported = await auth.isDeviceSupported();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? pass = prefs.getString('password');

    setState(() {
      _showBiometricIcon = isAvailable &&
          isDeviceSupported &&
          userId != null &&
          pass != null &&
          userId.isNotEmpty &&
          pass.isNotEmpty;
    });
  }

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text("Change Password"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Old Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD42D3F),
              ),
              onPressed: () {
                String oldPass = oldPasswordController.text.trim();
                String newPass = newPasswordController.text.trim();
                String confirmPass = confirmPasswordController.text.trim();

                if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please fill all fields."),
                  ));
                  return;
                }

                if (newPass != confirmPass) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("New and confirm passwords do not match."),
                  ));
                  return;
                }

                // Perform your change password API call or logic here
                print("Changing password...");

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }


    Future<void> _launchprivacypolicy() async {
      final Uri _url = Uri.parse("https://paisalo.in/Home/aadhaarconsentpolicy");
      if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $_url');
      }
    }



//securityquestion
/*  void saveSecurityQuestionAndAnswer() {
    if (selectedQuestion != null && answerController.text.trim().isNotEmpty) {
      setState(() {
        answer = answerController.text.trim();
      });

      // 👇 You can save this data to backend or local storage as per your need
      print("Selected Question: $selectedQuestion");
      print("Answer: $answer");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Security question and answer saved!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a question and enter answer")),
      );
    }
  }*/
}
