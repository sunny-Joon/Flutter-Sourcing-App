import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/global_class.dart';
import 'package:flutter_sourcing_app/target_set_page.dart';
import 'package:provider/provider.dart';

import 'api_service.dart';
import 'collection.dart';
import 'leader_board.dart';
import 'on_boarding.dart';
import 'profile.dart';
import 'target_car_gif.dart';
import 'const/appcolors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentSliderValue = 2500; // Initial value in thousands
  int _displayValue = 0; // Display value for the text
  int _page = 0;
  AppColors appColors = new AppColors();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (GlobalClass.target == 0) {
      _showAlertDialog(context);
    } else {
      _displayValue = GlobalClass.target;
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80), // Add some space at the top
            Container(
              width: MediaQuery.of(context).size.width - 30,
              margin: EdgeInsets.symmetric(
                  horizontal: 15.0), // 15dp margin on left and right
              padding:
              EdgeInsets.only(left: 30.0, right: 30, top: 30, bottom: 50),
              decoration: BoxDecoration(
                color: Color(0xFFD42D3F),
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/Images/curvedBackground.png'), // replace with your background image
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo with top margin
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Image.asset(
                      'assets/Images/paisa_logo.png', // replace with your logo
                      height: 45,
                    ),
                  ),
                  // Rupees image with top margin
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Image.asset(
                      'assets/Images/rupees.png', // replace with your image asset
                      height: 30,
                    ),
                  ),
                  // Monthly text with top margin
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'Monthly',
                      style: TextStyle(fontFamily: "Poppins-Regular",
                        fontSize: 20,
                        color: Color(0xFF6D6D6D), // dark grey color
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Disbursement Target text with top margin
                  Text(
                    'Comission Target',
                    style: TextStyle(fontFamily: "Poppins-Regular",
                      fontSize: 20,
                      color: Color(0xFF6D6D6D),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Container with margin from top and bottom
                  SizedBox(height: 10),
                  Text(
                    '₹ ${_displayValue.toStringAsFixed(0)}',
                    style: TextStyle(fontFamily: "Poppins-Regular",
                      fontSize: 28,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      Color(0xFFD42D3F), // Button background color
                      padding: EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Rectangular corners
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TargetSetPage()),
                      );
                    },
                    child: Text(
                      'Reset target',
                      style: TextStyle(fontFamily: "Poppins-Regular",
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Add space between sections
            // Bottom section with cards
            /*GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TargetCarGif()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'TAP TO KNOW YOUR PROGRESS',
                      style: TextStyle(fontFamily: "Poppins-Regular",
                        fontSize: 18,
                        color: Color(0xFFC5C3C3),
                        shadows: [
                          *//* Shadow(

                          blurRadius: 10.0,
                          color: Colors.black,
                        ),*//*
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Icon(
                      Icons.double_arrow_outlined,
                      color: Color(0xFFC5C3C3),
                    ),
                  ],
                ))*/



            SizedBox(height: 10), // Add space before the row
            Row(
              children: [
                Flexible(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center, // Center vertically
                            children: [
                              Text(
                                'Current Earning',
                                style: TextStyle(fontFamily: "Poppins-Regular",
                                  fontSize: 16,
                                  color: Color(0xFF6D6D6D),
                                ),
                              ),
                              SizedBox(height: 10), // Add some spacing
                              Flexible(
                                child: TextField(
                                  controller: TextEditingController(text: '\₹0000'),
                                  style: TextStyle(fontFamily: "Poppins-Regular",
                                    fontSize: 16,
                                    color: Color(0xFF6D6D6D),
                                  ),
                                  textAlign: TextAlign.center,
                                  readOnly: true, // Make it read-only
                                  decoration: InputDecoration(
                                    border:
                                    InputBorder.none, // Remove underline
                                  ),
                                ),
                              ),
                              SizedBox(height: 10), // Add some spacing
                              Text(
                                '10 People are earning more commission',
                                style: TextStyle(fontFamily: "Poppins-Regular",
                                  fontSize: 16,
                                  color: Color(0xFF6D6D6D),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Card(
                      color: Colors.red[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Earn Maximum Commission',
                                style: TextStyle(fontFamily: "Poppins-Regular",
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5),
                              Text(
                                'AB RUKNA NAHI',
                                style: TextStyle(fontFamily: "Poppins-Regular",
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                             /* Icon(
                                Icons.double_arrow_outlined,
                                color: Color(0xFFC5C3C3),
                              ),*/
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20), // Add some space at the bottom
          ],
        ),
      ),
    );
  }


  Future<int?> _showAlertDialog(BuildContext context) async {
    _currentSliderValue = 2500; // Reset slider value to initial value

    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              content: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                    image: AssetImage('assets/Images/curvedBackground.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Image.asset(
                        'assets/Images/paisa_logo.png',
                        height: 45,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Image.asset(
                        'assets/Images/rupees.png',
                        height: 30,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Monthly',
                        style: TextStyle(fontFamily: "Poppins-Regular",
                          fontSize: 24,
                          color: Color(0xFF6D6D6D),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Disbursement Target',
                        style: TextStyle(fontFamily: "Poppins-Regular",
                          fontSize: 24,
                          color: Color(0xFF6D6D6D),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Slider(
                        value: _currentSliderValue.toDouble(),
                        min: 0,
                        max: 10000, // Max value in thousands (10 million)
                        divisions:
                            10000, // Ensure divisions are set to the number of thousand increments
                        label:
                            '${(_currentSliderValue * 1000).toStringAsFixed(0)}',
                        onChanged: (value) {
                          setState(() {
                            _currentSliderValue = value.toInt();
                          });
                        },
                        onChangeEnd: (value) async {
                          await _setTarget(context, value.toInt());
                          Navigator.of(context).pop(value.toInt());
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Value: ${(_currentSliderValue * 1000).toStringAsFixed(0)}',
                        style: TextStyle(fontFamily: "Poppins-Regular",
                          fontSize: 16,
                          color: Color(0xFF6D6D6D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _setTarget(BuildContext context, int target) async {
    int targetAmount = target.toInt() * 1000;

    final api = Provider.of<ApiService>(context, listen: false);

    Map<String, dynamic> requestBody = {
      "TargetCommAmt": targetAmount,
    };

    return await api
        .insertMonthlytarget(GlobalClass.token, GlobalClass.dbName, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();

        if (value.data[0].errormsg == null || value.data[0].errormsg.isEmpty) {
          GlobalClass.showSuccessAlert(context, value.message, 1);
          setState(() {
            _displayValue = targetAmount;
          });
        } else {
          GlobalClass.showUnsuccessfulAlert(context, value.data[0].errormsg, 1);
        }
      } else {
        EasyLoading.dismiss();
        GlobalClass.showErrorAlert(context, value.message, 1);
      }
    });
  }
}
