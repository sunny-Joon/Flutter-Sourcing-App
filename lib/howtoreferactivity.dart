import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class howtoreferactivity extends StatelessWidget {
  final String referralCode;

  howtoreferactivity({required this.referralCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Refer and Earn Activity"),
      ),
      body: Container(
        color: Colors.red,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How To Refer a Friend and Earn?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            StepWidget(
              stepNumber: "1",
              stepDescription:
              "Click On 'Refer Now' and copy the message with your unique referral code.",
            ),
            StepWidget(
              stepNumber: "2",
              stepDescription:
              "Send the message to your friends via SMS, WhatsApp, Facebook or Email.",
            ),
            StepWidget(
              stepNumber: "3",
              stepDescription:
              "Ask your friend to fill in the form with your referral code and get ready to get rewarded.",
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red, // Set text color to red
                  backgroundColor: Colors.white, // Set background color to white
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Optional: padding for better button size
                ),
                child: Text('REFER NOW'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StepWidget extends StatelessWidget {
  final String stepNumber;
  final String stepDescription;
  const StepWidget({
    Key? key,
    required this.stepNumber,
    required this.stepDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.red,
            child: Text(
              stepNumber,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Text(
              stepDescription,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
              overflow: TextOverflow.ellipsis, // Handle text overflow
              maxLines: 2, // Limit to 2 lines if the text is long
            ),
          ),
        ],
      ),
    );
  }
}
