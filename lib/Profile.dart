import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/GlobalClass.dart';
import 'package:flutter_sourcing_app/LoginPage.dart';

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
          if (hours >= 0 && minutes >= 0 && seconds >= 0 && minutes < 60 && seconds < 60) {
            _remainingTime = Duration(hours: hours, minutes: minutes, seconds: seconds);
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildBackground(),
          _buildAppBar(context),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.width / 2 - 40),
                SizedBox(height: 20),

                _buildProfilePicture(),
                SizedBox(height: 20),
                _buildUserDetailsCard(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 300, // Specify a height for the grid view
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of columns
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: 4, // Number of grid items
                      itemBuilder: (context, index) {
                        // Define your grid items here
                        if (index == 0) {
                          return _buildGridItem('QR Payment Details', Icons.qr_code);
                        } else if (index == 1) {
                          return _buildGridItem('Get Collection Report', Icons.report);
                        } else if (index == 2) {
                          return _buildGridItem('Another Report', Icons.analytics);
                        } else {
                          return _buildGridItem('More Reports', Icons.insert_chart);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildUserIdDisplay(),
        ],
      ),
    );
  }

  Widget _buildGridItem(String title, IconData icon) {
    return Card(
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          // Add your action here
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.grey[700]),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned(
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
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Positioned(
      top: 35,
      left: 10,
      right: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBackButton(context),
            _buildCenterLogo(),
            _buildLogoutButton(context),
          ],
        ),
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
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
        backgroundImage: AssetImage('assets/Images/profileimage.webp'),
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
            _buildDetailRow(Icons.person, 'Name', _nameController),
            Divider(thickness: 2, indent: 16, endIndent: 16),
            _buildDetailRow(Icons.phone, 'Mobile No', _mobileNoController),
            Divider(thickness: 2, indent: 16, endIndent: 16),
            _buildDetailRow(Icons.work, 'Designation', _designationController),
            Divider(thickness: 2, indent: 16, endIndent: 16),
            _buildDetailRow(Icons.map, 'Creator', _creatorController),
            Divider(thickness: 2, indent: 16, endIndent: 16),
            _buildTimerRow(Icons.timer, 'Time Remaining', _timeDisplay),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, TextEditingController controller) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFD42D3F)),
        SizedBox(width: 8.0),
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            controller.text,
            style: TextStyle(color: Color(0xFFD42D3F)),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerRow(IconData icon, String label, String timerDisplay) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFD42D3F)),
        SizedBox(width: 8.0),
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            timerDisplay,
            style: TextStyle(color: Color(0xFFD42D3F)),
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
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[700]),
        ),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Add your action here
        },
      ),
    );
  }

  Widget _buildUserIdDisplay() {
    return Positioned(
      top: MediaQuery.of(context).size.width / 4,
      left: 0,
      right: 0,
      child: Container(
        height: 45,
        alignment: Alignment.center,
        child: Text(
          _idController.text,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }


}
