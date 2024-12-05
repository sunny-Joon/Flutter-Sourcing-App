import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/branch_list_page.dart';

class DealerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
                margin: EdgeInsets.all(35),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(40.0)), // Updated line
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(left: 30,right: 30,top: 70,bottom: 70),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 13, right: 13),
                        child: Center(
                          child: Text(
                            'KYC Check mandatory process of identifying and verifying.',
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center, // Center the text within the available space
                          ),
                        ),
                      ),

                      SizedBox(height: 10.0), // Space between the text and card
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        color: Color(0xFFD42D3F),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BranchListPage(intentFrom: "Dealer")),
                            );
                          },
                          child:Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures space between text and icon
                              children: [
                                Text(
                                  'KYC',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    // fontWeight: FontWeight.bold, // Uncomment if needed
                                  ),
                                ),
                                Transform.rotate(
                                  angle: -3.14159 / 2, // 90 degrees in radians (rotates to the left)
                                  child: Icon(
                                    Icons.expand_circle_down_rounded,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
