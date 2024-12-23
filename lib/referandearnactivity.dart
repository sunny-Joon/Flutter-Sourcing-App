import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_sourcing_app/getrewardactivity.dart';
import 'package:flutter_sourcing_app/howtoreferactivity.dart';

class referandearnactivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Refer and Earn"),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.red,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            // First Image - Clickable
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => howtoreferactivity()),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 180, // Increase the height to 200
                child: SvgPicture.asset(
                  'assets/Images/earn1.svg',
                  fit: BoxFit.fill,
                ),
              ),
            ),

            SizedBox(height: 15),

            // Second Image with Overlay Content
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 180,
                  child: SvgPicture.asset(
                    'assets/Images/Vector.svg',
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    // Referral Code Text
                    Text(
                      'Your Referral Code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),

                    Text(
                      'ABCDEFG',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 19),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.4, // Smaller width
                            child: Card(
                              elevation: 2,
                              color: Colors.white.withOpacity(0.9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Referral Friends',
                                      style: TextStyle(
                                        fontSize: 8, // Smaller font size
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 11), // Smaller spacing
                                    Text(
                                      '0',
                                      style: TextStyle(
                                        fontSize: 8, // Smaller font size
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.4, // Smaller width
                            child: Card(
                              elevation: 2,
                              color: Colors.white.withOpacity(0.9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Cashback Earned',
                                      style: TextStyle(
                                        fontSize: 8, // Smaller font size
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 11),
                                    Text(
                                      '0', // Replace with dynamic value
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),

            SizedBox(height: 15),

            // Third Image - Clickable
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => getRewardActivity()),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.9, // Increase width by 20%
                height: 180, // Increase the height to 200
                child: SvgPicture.asset(
                  'assets/Images/earn3.svg', // Ensure the path is correct
                  fit: BoxFit.fill, // Stretch image to fit the width
                ),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                print("Refer Now Button Clicked");
              },
              child: Text("REFER NOW"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
