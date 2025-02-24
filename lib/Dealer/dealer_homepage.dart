import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'dealer_branch_list.dart';
import 'dealer_kycform2.dart';

class DealerHomePage extends StatefulWidget {

  @override
  _DealerHomePageState createState() => _DealerHomePageState();
}
class _DealerHomePageState extends State<DealerHomePage> {

  CarouselSliderController buttonCarouselController = CarouselSliderController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body:Column(
          children: [
            SizedBox(height: 42,),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                        Border.all(width: 1, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: Center(
                        child: Icon(Icons.arrow_back_ios_sharp, size: 13),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Center(
                    child: Image.asset(
                      'assets/Images/logo_white.png',
                      // Replace with your logo asset path
                      height: 30,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),

          Container(
            height: MediaQuery.of(context).size.height-200,
            child:Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Card(
                    margin: EdgeInsets.all(20),
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
                                'Mandatory processes of application in terms of providing loan.',
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
                                      builder: (context) =>DealerBranchListPage(intentFrom: "PendingCases")),
                                    );
                              },
                              child:Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures space between text and icon
                                  children: [
                                    Text(
                                      'Pending Cases',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
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
                                        builder: (context) =>DealerBranchListPage(intentFrom: "SanctionedCases")),

                                );
                              },
                              child:Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures space between text and icon
                                  children: [
                                    Text(
                                      'Sanctioned Cases',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
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
                                        builder: (context) =>DealerBranchListPage(intentFrom: "Disbursedcases")),
                                    );
                              },
                              child:Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures space between text and icon
                                  children: [
                                    Text(
                                      'Disbursed cases',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
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
          ),
        ],),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.red,),
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>DealerKYCPage2()
                /*BranchListPage(intentFrom: "Dealer"))*/,
              ));
        },
      ),
    );
  }


}
