import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/qr_payment_reports.dart';

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

  String tabName = "Punch In";
  Duration _remainingTime = Duration();
  String _timeDisplay = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
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
      backgroundColor: Color(0xFFD42D3F),

      body: Stack(
        children: [
          // Background sphere
          Positioned(
            top: -MediaQuery.of(context).size.width - 50,
            left: -50,
            right: -50,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Images/sphere.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Header with back, logo, and logout buttons
          Positioned(
            top: 35,
            left: 10,
            right: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 // _buildBackButton(context),
                  SizedBox(width: 50,),
                  _buildCenterLogo(),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ),

          // Main content: Profile picture, user details, and action cards
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.width / 3.6),
                _buildProfilePicture(),
                SizedBox(
                  height: 30,
                ),
                _buildUserDetailsCard(),

                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      child: GridView.builder(
                        padding: EdgeInsets.all(0),
                        shrinkWrap:
                            true, // Ensure the grid view doesn't expand infinitely
                        physics:
                            NeverScrollableScrollPhysics(), // Disable scrolling for GridView
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of columns
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                        ),
                        itemCount: 3, // Number of grid items
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return _buildGridItem(
                                'QR Payment Report', Icons.qr_code, () {
                              // Action for QR Payment Details
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QrPaymentReports(),
                                ),
                              );
                              // Add navigation or other actions here
                            });
                          } else if (index == 1) {
                            return _buildGridItem(
                                'Collection Report', Icons.currency_rupee, () {
                              // Action for Get Collection Report
                              print('Get Collection Report Clicked');
                              // Add navigation or other actions here
                            });
                          } else if (index == 2) {
                            return _buildGridItem(
                                'Morpho Recharge', Icons.fingerprint, () {
                              // Action for Another Report
                              print('Another Report Clicked');
                              // Add navigation or other actions here
                            });
                          } else {
                            return _buildGridItem(
                                'More Reports', Icons.insert_chart, () {
                              // Action for More Reports
                              print('More Reports Clicked');
                              // Add navigation or other actions here
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 10,
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    color: Colors.green,
                    width: MediaQuery.of(context).size.width - 50,
                    child: InkWell(
                      onTap: () {
                        punchInOut(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 11.0),
                        alignment: Alignment.center,
                        child: Text(
                          tabName,
                          style: TextStyle(fontFamily: "Poppins-Regular",
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
    );
  }

  Widget _buildGridItem(String title, IconData icon, VoidCallback onTap) {
    return Card(

      color: Colors.white,
      elevation: 6,
      margin: EdgeInsets.all(6),
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: EdgeInsets.all(4),child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.grey),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: "Poppins-Regular",
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ],
        ),),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: _buildIconContainer(Icons.arrow_back_ios_sharp),
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

                onPressed: (){
                  EasyLoading.dismiss();
                  Navigator.of(context).pop(true);
                 } ,
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  EasyLoading.dismiss();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => LoginPage()));
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
            _buildDetailRow(Icons.perm_identity, 'ID ', _idController),
            Divider(thickness: 2, indent: 16, endIndent: 16),
            _buildDetailRow(Icons.person, 'Name ', _nameController),
            Divider(thickness: 2, indent: 16, endIndent: 16),
            _buildDetailRow(Icons.phone, 'Mobile No ', _mobileNoController),
            Divider(thickness: 2, indent: 16, endIndent: 16),
            _buildDetailRow(Icons.work, 'Designation ', _designationController),
            Divider(thickness: 2, indent: 16, endIndent: 16),
            _buildDetailRow(Icons.map, 'Creator ', _creatorController),
            Divider(thickness: 2, indent: 16, endIndent: 16),
            _buildTimerRow(Icons.timer, 'Time Remaining ', _timeDisplay),
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
            style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 11, fontWeight: FontWeight.bold)),
        Expanded(
          child: Text(
            controller.text,
            style: TextStyle(fontFamily: "Poppins-Regular",color: Color(0xFFD42D3F)),
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
            style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 11, fontWeight: FontWeight.bold)),
        Expanded(
          child: Text(
            timerDisplay,
            style: TextStyle(fontFamily: "Poppins-Regular",color: Color(0xFFD42D3F)),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(String title) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontFamily: "Poppins-Regular",
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700]),
        ),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Add your action here
        },
      ),
    );
  }

  Future<void> punchInOut(BuildContext context) async {
    EasyLoading.show(
      status: 'Loading...',
    );
    final api = ApiService.create(baseUrl: ApiConfig.baseUrl1);
    Map<String, dynamic> requestBody = {
      "location": "100745868994",
    };
    String type = "PUNCHOUT";
    return await api
        .punchInOut(GlobalClass.token, GlobalClass.dbName, requestBody, type)
        .then((value) {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();
        setState(() {
          tabName = "PUNCH OUT";
        });
        GlobalClass.showSuccessAlert(context, value.message, 1);
      } else {
        EasyLoading.dismiss();
        GlobalClass.showUnsuccessfulAlert(context, value.message, 1);
      }
    });
  }

}
