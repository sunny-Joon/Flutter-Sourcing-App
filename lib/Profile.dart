import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/GlobalClass.dart';

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

  // Timer and remaining time variables
  Duration _remainingTime = Duration();
  String _timeDisplay = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Set initial values for the controllers
    _creatorController.text = GlobalClass.creator;
    _idController.text = GlobalClass.id;
    _validityController.text = GlobalClass.address;
    _mobileNoController.text = GlobalClass.mobile;
    _nameController.text = GlobalClass.userName;
    _designationController.text = GlobalClass.designation;

    // Start the timer countdown
    _startTimer();
  }

  // Function to start the timer countdown
  void _startTimer() {
    // Get the time string from _validityController
    String validityString = _validityController.text.trim(); // Get the time string and trim extra spaces

    // Ensure that the string is in the format "hh:mm:ss"
    if (validityString.isNotEmpty && validityString.contains(':')) {
      print("DateTiem $validityString 1");
      List<String> timeParts = validityString.split(':');

      // Ensure that there are exactly 3 parts (hours, minutes, seconds)
      if (timeParts.length == 3) {
        try {
          int hours = int.parse(timeParts[0]);
          int minutes = int.parse(timeParts[1]);
          int seconds = int.parse(timeParts[2]);

          // Check if the parsed values are reasonable
          if (hours >= 0 && minutes >= 0 && seconds >= 0 && minutes < 60 && seconds < 60) {
            _remainingTime = Duration(hours: hours, minutes: minutes, seconds: seconds);
            _timeDisplay = _formatTime(_remainingTime);

            // Start the countdown timer
            _timer = Timer.periodic(Duration(seconds: 1), (timer) {
              if (_remainingTime.inSeconds > 0) {
                setState(() {
                  _remainingTime = _remainingTime - Duration(seconds: 1);
                  _timeDisplay = _formatTime(_remainingTime);
                });
              } else {
                setState(() {
                  _timeDisplay = 'Session expired';
                });
                _timer?.cancel(); // Stop the timer once the time expires
              }
            });
          } else {
            // If invalid values (like negative hours/minutes/seconds) are detected
            setState(() {
              _timeDisplay = 'Invalid time format1';
            });
          }
        } catch (e) {
          // Catch parsing errors
          setState(() {
            _timeDisplay = 'Invalid time format2';
          });
        }
      } else {
        setState(() {
          _timeDisplay = 'Invalid time format3';
        });
      }
    } else {
      setState(() {
        print("DateTiem $validityString 1");

        _timeDisplay = 'Invalid time format4';
      });
    }
  }


  // Function to format the time in "hh:mm:ss" format
  String _formatTime(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -MediaQuery.of(context).size.width,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height, // Set height to screen height
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Images/sphere.png'), // Your background image
                  fit: BoxFit.contain, // Makes the image cover the entire screen
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: (MediaQuery.of(context).size.width / 2)-40), // Adjust this value as needed
                // Circular Profile Picture
                Center(
                  child: CircleAvatar(
                    radius: 50.0, // Adjust size of the circle
                    backgroundImage: AssetImage('assets/Images/profileimage.png'), // Profile pic
                  ),
                ),
                SizedBox(height: 20),

                // User Details Section
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  color: Colors.white.withOpacity(0.8), // Slight transparency for the card
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(Icons.person, 'Name', _nameController),
                        _buildDetailRow(Icons.phone, 'Mobile No', _mobileNoController),
                        _buildDetailRow(Icons.work, 'Designation', _designationController),
                        _buildDetailRow(Icons.map, 'Creator', _creatorController),
                        _buildTimerRow(Icons.timer, 'Time Remaining', _timeDisplay),
                      ],
                    ),
                  ),
                ),

                // Additional Action Cards
                _buildActionCard('Get QR Payment Details'),
                _buildActionCard('Get Collection Report'),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.width / 4,
            left: 0,
            right: 0,
            child: Container(
              height: 45,
              child: Center(
                child: Text(
                  _idController.text,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text on background
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          SizedBox(width: 8.0),
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              controller.text,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerRow(IconData icon, String label, String timerDisplay) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          SizedBox(width: 8.0),
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              timerDisplay,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          children: [
            Container(
              height: 45,
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                // Add your action for this button here
              },
            ),
          ],
        ),
      ),
    );
  }
}
