import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/collection_report.dart';
import 'package:flutter_sourcing_app/qr_payment_reports.dart';
import 'package:flutter_sourcing_app/utils/current_location.dart';
import 'package:provider/provider.dart';
import 'api_service.dart';
import 'global_class.dart';
import 'login_page.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _creatorController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _validityController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController deviceSirNoController = TextEditingController();
  String tabName = "";
  Duration _remainingTime = Duration();
  String _timeDisplay = '';
  Timer? _timer;
  bool punchCard = true;
  @override
  void initState() {
    super.initState();
    attendanceStatus(context);
    _initializeControllers();
    _startTimer();
  }

  void _initializeControllers() {
    _creatorController.text = GlobalClass.creator;
    _idController.text = GlobalClass.id;
    _validityController.text = GlobalClass.address;
    _mobileNoController.text = GlobalClass.mobile;
    _nameController.text = GlobalClass.userName;
    _designationController.text = GlobalClass.designation;
  }

  void _startTimer() {
    String validityString = _validityController.text.trim();
    if (validityString.isNotEmpty && validityString.contains(':')) {
      List<String> timeParts = validityString.split(':');
      if (timeParts.length == 3) {
        try {
          int hours = int.parse(timeParts[0]);
          int minutes = int.parse(timeParts[1]);
          int seconds = int.parse(timeParts[2]);
          if (hours >= 0 &&
              minutes >= 0 &&
              seconds >= 0 &&
              minutes < 60 &&
              seconds < 60) {
            _remainingTime =
                Duration(hours: hours, minutes: minutes, seconds: seconds);
            _timeDisplay = _formatTime(_remainingTime);
            _timer = Timer.periodic(Duration(seconds: 1), (timer) {
              if (_remainingTime.inSeconds > 0) {
                setState(() {
                  _remainingTime -= Duration(seconds: 1);
                  _timeDisplay = _formatTime(_remainingTime);
                });
              } else {
                setState(() {
                  _timeDisplay = 'Session expired';
                });
                _timer?.cancel();
              }
            });
          } else {
            _setInvalidTimeFormat();
          }
        } catch (e) {
          _setInvalidTimeFormat();
        }
      } else {
        _setInvalidTimeFormat();
      }
    } else {
      _setInvalidTimeFormat();
    }
  }

  void _setInvalidTimeFormat() {
    setState(() {
      _timeDisplay = 'Invalid time format';
    });
  }

  String _formatTime(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD42D3F),
      endDrawer: Container(
        width: 120,
        height: MediaQuery.of(context).size.height/1.5, // Set the width of the drawer
        child: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Home ListTile with QR Payment Report
              ListTile(
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  // Navigate to QR Payment Reports
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QrPaymentReports()),
                  );
                },
                title: Column(
                  children: const [
                    Icon(Icons.currency_rupee),
                    SizedBox(height: 5),
                    Text('QR Payment Report', style: TextStyle(fontSize: 9)),
                  ],
                ),
              ),
              // Settings ListTile with Collection Report
              ListTile(
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  // Navigate to QR Payment Reports
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CollectionStatus()),
                  );
                },
                title: Column(
                  children: const [
                    Icon(Icons.currency_rupee),
                    SizedBox(height: 5),
                    Text('Collection Report', style: TextStyle(fontSize: 8)),
                  ],
                ),
              ),
              // About ListTile with Morpho Recharge
              ListTile(
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  showCustomAlertDialog(context);
                },
                title: Column(
                  children: const [
                    Icon(Icons.info),
                    SizedBox(height: 5),
                    Text('Morpho Recharge', style: TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawerEnableOpenDragGesture: true,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height - 45,
          ),
          child: Stack(
            children: [
              // Background sphere
              Positioned(
                top: -MediaQuery.of(context).size.width - 50,
                left: -50,
                right: -50,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Images/sphere.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // Header with logo and logout buttons
              Positioned(
                top: 35,
                left: 10,
                right: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 50),
                      _buildCenterLogo(),
                      _buildLogoutButton(context),
                    ],
                  ),
                ),
              ),
              // Main content
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.width / 5),
                    _buildProfilePicture(),
                    SizedBox(height: 30),
                    _buildUserDetailsCard(),
                    // Action cards
                    Container(
                      height: MediaQuery.of(context).size.height / 6,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1,
                          ),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _buildGridItem('QR Payment Report', Icons.qr_code, () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => QrPaymentReports()),
                                );
                              });
                            } else if (index == 1) {


                              return _buildGridItem('Morpho Recharge', Icons.find_in_page_sharp, () {
                                showCustomAlertDialog(context);
                              });
                            } else if (index == 2) {
                              return _buildGridItem('Other Reports', Icons.currency_rupee, () {

                                Scaffold.of(context).openEndDrawer();

                              });
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                    // Punch In/Out button
                    Card(
                      elevation: 10,
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        color: punchCard ? Colors.green : Colors.grey,
                        width: MediaQuery.of(context).size.width - 50,
                        child: InkWell(
                          onTap: punchCard ? () {
                            punchInOut(context);
                          } : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 11.0),
                            alignment: Alignment.center,
                            child: Text(
                              tabName,
                              style: const TextStyle(
                                fontFamily: "Poppins-Regular",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(String title, IconData icon, VoidCallback onTap) {
    return Card(
      color: Colors.white,
      elevation: 6,
      margin: EdgeInsets.all(6),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: Colors.grey),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins-Regular",
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to Logout?'),
            actions: [
              TextButton(
                onPressed: () {
                  EasyLoading.dismiss();
                  Navigator.of(context).pop(true);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  EasyLoading.dismiss();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }, // Exit the app
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      child: _buildIconContainer(Icons.logout, color: Color(0xFFD42D3F)),
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

  Widget _buildCenterLogo() {
    return Image.asset(
      'assets/Images/logo_white.png',
      height: 30,
    );
  }

  Widget _buildProfilePicture() {
    return Center(
      child: CircleAvatar(
        radius: 50.0,
        backgroundImage: AssetImage('assets/Images/user_ic.png'),
      ),
    );
  }

  Widget _buildUserDetailsCard() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.credit_card, 'ID ', _idController),
            Divider(thickness: 2, indent: 16, endIndent: 16),
            _buildDetailRow(Icons.person, 'Name ', _nameController),
            Divider(thickness: 2, indent: 16, endIndent: 16),
            _buildDetailRow(Icons.phone, 'Mobile No ', _mobileNoController),
            Divider(thickness: 2, indent: 16, endIndent: 16),
            _buildDetailRow(Icons.work, 'Designation ', _designationController),
            Divider(thickness: 2, indent: 16, endIndent: 16),
            _buildDetailRow(Icons.admin_panel_settings, 'Creator ', _creatorController),
            // Divider(thickness: 2, indent: 16, endIndent: 16),
            // _buildTimerRow(Icons.timer, 'Time Remaining ', _timeDisplay),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      IconData icon, String label, TextEditingController controller) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFD42D3F)),
        Text(label,
            style: TextStyle(
                fontFamily: "Poppins-Regular",
                fontSize: 11,
                fontWeight: FontWeight.bold)),
        Expanded(
          child: Text(
            controller.text,
            style: TextStyle(
                fontFamily: "Poppins-Regular", color: Color(0xFFD42D3F)),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerRow(IconData icon, String label, String timerDisplay) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFD42D3F)),
        Text(label,
            style: TextStyle(
                fontFamily: "Poppins-Regular",
                fontSize: 11,
                fontWeight: FontWeight.bold)),
        Expanded(
          child: Text(
            timerDisplay,
            style: TextStyle(
                fontFamily: "Poppins-Regular", color: Color(0xFFD42D3F)),
          ),
        ),
      ],
    );
  }

  Future<void> punchInOut(BuildContext context) async {
    var _latitude=0.0;
    var _longitude=0.0;
    currentLocation _locationService = currentLocation();
    try {
      Map<String, dynamic> locationData =
      await _locationService.getCurrentLocation();
      _latitude = locationData['latitude'];
      _longitude = locationData['longitude'];

    } catch (e) {
      print("Error getting current location: $e");

    }


    if (_latitude == 0.0 || _longitude == 0.0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Location Error"),
          content: Text("Please enable your location services or open location settings."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    EasyLoading.show(
      status: 'Loading...',
    );
    final api = ApiService.create(baseUrl: ApiConfig.baseUrl1);
    Map<String, dynamic> requestBody = {
      "location": "$_latitude,$_longitude",
    };

    return await api
        .punchInOut(GlobalClass.token, GlobalClass.dbName, requestBody, tabName)
        .then((value) {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();
        if(tabName == "PUNCHOUT"){
          punchCard = false;
          tabName = "PUNCHIN";
        }else {
          setState(() {
            tabName = "PUNCHOUT";
          });
        }
        GlobalClass.showSuccessAlert(context, value.message, 1);
      } else {
        EasyLoading.dismiss();
        GlobalClass.showUnsuccessfulAlert(context, value.message, 1);
      }
    });
  }

  void showCustomAlertDialog(BuildContext context) {
    final TextEditingController deviceSirNoController =
        TextEditingController(text: '2306I0052');

    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent closing the dialog by clicking outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recharge'),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Morpho Device Sir No",
                  style: TextStyle(
                    fontFamily: "Poppins-Regular",
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 1),
                Container(
                  width: double.infinity, // Set the desired width
                  child: Center(
                    child: TextFormField(
                      maxLength: 11,
                      controller: deviceSirNoController,
                      keyboardType: TextInputType.text,
                      // Set the input type
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        counterText: "",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Device Sir No';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                try {
                  Map<String, dynamic> locationData =
                      await currentLocation().getCurrentLocation();
                  var _latitude = 0.0;
                  var _longitude = 0.0;
                  _latitude = locationData['latitude'];
                  _longitude = locationData['longitude'];
                  MorphoRechargeApi(context, _latitude, _longitude);
                } catch (e) {
                  print("Error getting current location: $e");
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
                minimumSize: Size(100, 50), // Width and height of the button
              ),
              child: Text('Submit',
                  style: TextStyle(color: Colors.white)), // Text color
            ),
          ],
        );
      },
    );
  }

  Future<void> MorphoRechargeApi(
      BuildContext context, double latitude, double longitude) async {
    EasyLoading.show(
      status: 'Loading...',
    );

    final api = Provider.of<ApiService>(context, listen: false);
    Map<String, dynamic> requestBody = {
      "creator": "AGRA",
      "groupCode": "009",
      "cityCode": "2299",
      "deviceSirNo": deviceSirNoController.text,
      "Lat": latitude.toString(),
      "Long": longitude.toString()
    };

    await api
        .morphorecharge(GlobalClass.dbName, GlobalClass.token, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        GlobalClass.showUnsuccessfulAlert(
            context, "Unsuccessful to send Request", 1);
      }
    }).catchError((error) {
      EasyLoading.dismiss();
      GlobalClass.showUnsuccessfulAlert(context, "Server side Error", 1);
    });
  }


  Future<void> attendanceStatus(BuildContext context) async {
    EasyLoading.show(
      status: 'Loading...',
    );

    final api = Provider.of<ApiService>(context, listen: false);

    await api.AttendanceStatus(GlobalClass.token,GlobalClass.dbName,  GlobalClass.id)
        .then((value) async {
      if (value.statuscode == 200) {
        if(value.data.length >0){
          if(value.data[0].inTime !=null && value.data[0].outTime!=null){
            setState(() {
              punchCard = false;
              tabName = "PUNCHIN";
            });
          }else{
            setState(() {
              tabName = "PUNCHOUT";
            });
          }
        }else{
          setState(() {
            tabName = "PUNCHIN";
          });
        }

        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        GlobalClass.showUnsuccessfulAlert(
            context, "Attendance Status Fail", 1);
      }
    }).catchError((error) {
      EasyLoading.dismiss();
      GlobalClass.showUnsuccessfulAlert(context, error.toString(), 1);
    });
  }
}
