import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // If you're using SVG images, import this package

class getRewardActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Refer and Earn Activity"),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.red,
      body: Padding(
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
              width: MediaQuery.of(context).size.width * 1.2, // Increase the width by 20%
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
                // Add your action here
                print("Reward Button Clicked");
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
