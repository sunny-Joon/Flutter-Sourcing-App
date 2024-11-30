
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'ApiService.dart';
import 'Fragments.dart';
import 'GlobalClass.dart';


class TargetSetPage extends StatefulWidget {



  @override
  State<TargetSetPage> createState() => _TargetSetPageState();
}

class _TargetSetPageState extends State<TargetSetPage> {
  double rotationAngle = 0.0;
  int currentPage = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    _targetedAmount=GlobalClass.target.toDouble();

  }

  final currencyFormatter = NumberFormat('#,##0', 'en_US');
  double _targetedAmount = 15000; // Initial amount
  static const double _maxAmount = 10000000; // Maximum amount for the slider
  static const int _divisions = 100;

  int colorchange = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFD42D3F),
        body: Stack(
          children: [
            Center(
                child: Container(
                  width: MediaQuery.of(context).size.width-30, // Adjust the width as needed
                  height: MediaQuery.of(context).size.height/2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/Images/card_bg.png'),
                      // Replace with your SVG file path
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 25),
                      // Replace 'assets/your_image.svg' with your SVG file path
                      Image(
                        image: AssetImage('assets/Images/paisa_logo.png'),
                        height: MediaQuery.of(context).size.height/10,
                        width: 140,
                      ),
                      SizedBox(height: 15),
                      Image(
                        image: AssetImage('assets/Images/money_ic.png'),
                        height: MediaQuery.of(context).size.height/20,
                        width: 50,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Set your monthly\ncommission target",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30, color: Colors.black54),
                      ),
                      SizedBox(height: 15),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        decoration: BoxDecoration(
                            color: Color(0xFFD42D3F)),
                        child: Text(
                          '${currencyFormatter.format(_targetedAmount)}',
                          style: TextStyle(fontSize: 26, color: Colors.white),
                        ),
                      ),
                      Container(
                          width: 260,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Color(0xFFD42D3F),
                              inactiveTrackColor: Colors.grey.shade300,
                              thumbColor: Color(0xFFD42D3F),
                              overlayColor: Colors.black.withAlpha(32),
                              valueIndicatorColor: Colors.black,
                              trackHeight: 4.0,
                              thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 8.0),
                              overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 16.0),
                            ),
                            child: Slider(

                              onChanged: (double value) {

                                setState(() {
                                  _targetedAmount = value * _maxAmount;
                                });
                              },
                              onChangeEnd: (double value) {
                                _setTarget(context,_targetedAmount.toInt());


                              },
                              min: 0.0,
                              max: 1.0,
                              divisions: _divisions,
                              value: _targetedAmount /
                                  _maxAmount, // Optional: If needed for discrete values
                            ),
                          )),

                      // Optional space between image and other content
                    ],
                  ),
                )),
            Visibility(
              visible: currentPage == 0 ? true : false,
              child: Listener(
                onPointerMove: (_) {
                  setState(() {
                    colorchange = 1;
                  });
                }, onPointerUp: (_) {
                setState(() {
                  colorchange = 0;
                });
              },
                child: PageView(

                  controller: pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      currentPage = page;
                    });
                  },
                  children: [
                    _buildPage(Color(0xFFD42D3F), 'Welcome',
                        "${GlobalClass.userName}",
                        'swipe to start earning', Icons.arrow_forward),
                    _buildPage1(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(Color color, String welcome, String name, String text,
      IconData ic) {
    return Transform.rotate(
      angle: currentPage == 0 ? rotationAngle : 0.0,
      alignment: Alignment.center,
      child: Listener(
        onPointerMove: (PointerMoveEvent event) {
          if (currentPage == 0) {
            setState(() {
              rotationAngle = -5 * (3.1415926535 / 180); // Adjust sensitivity
            });
          }
        },
        onPointerUp: (_) {
          if (currentPage == 0) {
            setState(() {
              rotationAngle = 0.0;
            });
          }
        },
        child: Container(
          color: colorchange == 0 ? color : Color(0xB2D42D3F),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Welcome', style: TextStyle(color: Colors.white,
                  fontSize: 30,
                  fontFamily: 'Visbyfregular',),)
                , Text(
                  name,
                  style: TextStyle(
                    fontSize: 45,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20,),
                Text(text, style: TextStyle(color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Visbyfregular'),),

                Container(
                  width: 80,
                  child: Image.asset(
                    "assets/Images/arrow.gif", // Replace with your image URL
                    fit: BoxFit
                        .cover, // Adjust the fit as needed (contain, cover, fill, etc.)
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return Transform.rotate(
      angle: currentPage == 0 ? rotationAngle : 0.0,
      alignment: Alignment.center,
      child: Listener(
        onPointerMove: (PointerMoveEvent event) {
          if (currentPage == 0) {
            setState(() {
              rotationAngle = -5 * (3.1415926535 / 180); // Adjust sensitivity
            });
          }
        },
        onPointerUp: (_) {
          if (currentPage == 0) {
            setState(() {
              rotationAngle = 0.0;
            });
          }
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Text(
              '',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _setTarget(BuildContext context, int target) async {

EasyLoading.show(status: "Please wait...");
    int targetAmount = target.toInt();

    final api = Provider.of<ApiService>(context, listen: false);

    Map<String, dynamic> requestBody = {
      "TargetCommAmt": targetAmount,
    };

    return await api
        .insertMonthlytarget(GlobalClass.token,GlobalClass.dbName, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();

        if (value.data[0].errormsg == null || value.data[0].errormsg.isEmpty) {
          // GlobalClass.showSuccessAlert(
          //     context, value.message,1);
          setState(() {
          GlobalClass.target=target;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Fragments()));
          });
        } else {
          GlobalClass.showUnsuccessfulAlert(
              context, value.data[0].errormsg,1);
        }
      } else {
        EasyLoading.dismiss();
        GlobalClass.showErrorAlert(
            context,value.message,1);
      }
    });
  }
  // Future<void> _setTargetOfCsp(int targetedAmount, String CSPCode) async {
  //
  //
  //   final api = Provider.of<ApiService>(context, listen: false);
  //   var now = DateTime.now();
  //   var monthFormat = DateFormat.MMMM(); // Month name format
  //   var yearFormat = DateFormat.y(); // Year format
  //
  //   String monthName = monthFormat.format(now); // Getting current month name
  //   String year = yearFormat.format(now);
  //   print("month name $monthName and Year Name $year");// Getting current year
  //   print("Bearer ${widget.loginResponse.data.token}");
  //   return api
  //       .setTarget(
  //       "Bearer ${widget.loginResponse.data.token}",
  //       CSPCode,targetedAmount.toString(),monthName,year)
  //       .then((value) {
  //     if (value.statusCode==200 && value.data=="1") {
  //       prefs.setString('monthlyTarget', targetedAmount.toString());
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) =>
  //             HomePage(loginResponse: this.widget.loginResponse,username: CSPCode,)),
  //       );
  //     }
  //
  //   });
  // }


}


