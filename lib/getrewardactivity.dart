import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

class getrewardactivity extends StatelessWidget {
  final String referralCode;

  getrewardactivity({required this.referralCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD42D3F),
      body:Column(children: [
        SizedBox(height: 50,),
        Padding(padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.grey.shade300),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  child: Center(
                    child: Icon(Icons.arrow_back_ios_sharp, size: 16),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              Center(
                child: Image.asset(
                  'assets/Images/logo_white.png', // Replace with your logo asset path
                  height: 40,
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
          height: MediaQuery.of(context).size.height-110,
          child: SingleChildScrollView(child:
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out the content
            crossAxisAlignment: CrossAxisAlignment.center, // Center the content
            children: [
              // First Image
              SvgPicture.asset(
                'assets/Images/get1.svg', // Ensure the path is correct
                height: 170,
                width: double.infinity, // Full screen width
                fit: BoxFit.cover, // Stretch image to fit the container
              ),
              SizedBox(height: 20), // Add space between images

              // Second Image
              Container(
                width: MediaQuery.of(context).size.width * 1.2, // Slightly wider than the screen
                child: SvgPicture.asset(
                  'assets/Images/get2.svg', // Ensure the path is correct
                  height: 170,
                  fit: BoxFit.cover, // Stretch image to fit the container
                ),
              ),
              SizedBox(height: 20), // Add space between images

              // Third Image
              SvgPicture.asset(
                'assets/Images/get3.svg', // Ensure the path is correct
                height: 170,
                width: double.infinity, // Full screen width
                fit: BoxFit.cover, // Stretch image to fit the container
              ),
              SizedBox(height: 20), // Add space between images

              // Button at the bottom
              ElevatedButton(
                onPressed: () {
                  String shareMessage =
                      "Join Paisalo group with my referral code *$referralCode* to get more benefits. "
                      "Register on this link https://www.paisalo.in/home/cso with my referral code to become a CSO.";

                  try {
                    Share.share(shareMessage);
                    print("Message shared: $shareMessage");
                  } catch (e) {
                    print("Error sharing message: $e");
                  }
                },
                child: Text("REFER NOW"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(
                    0xFFC01024), // Text color
                  elevation: 5, // Elevation
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Padding
                  textStyle: TextStyle(fontSize: 20), // Text style
                ),
              ),
            ],
          ),
        ),),)

      ],) ,

    );
  }
}
