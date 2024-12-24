import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

import 'getrewardactivity.dart';
import 'howtoreferactivity.dart';

class referandearnactivity extends StatefulWidget {
  @override
  _referandearnactivitystate createState() => _referandearnactivitystate();
}

class _referandearnactivitystate extends State<referandearnactivity> {
  final TextEditingController referralCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchReferralCode();
  }

  void fetchReferralCode() async {
    await Future.delayed(Duration(seconds: 2));

    String fetchedReferralCode = "rps123";
    setState(() {
      referralCodeController.text = fetchedReferralCode;
    });
  }

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
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => howtoreferactivity()),
                );

              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 180,
                child: SvgPicture.asset(
                  'assets/Images/earn1.svg',
                  fit: BoxFit.fill,
                ),
              ),
            ),

            SizedBox(height: 15),

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
                    Text(
                      'Your Referral Code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Dynamic referral code
                    Text(
                      referralCodeController.text.isNotEmpty
                          ? referralCodeController.text
                          : 'Loading...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoCard(
                          title: 'Total Referral Friends',
                          value: '0',
                        ),
                        _buildInfoCard(
                          title: 'Total Cashback Earned',
                          value: '0',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 15),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => getRewardActivity()),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 180,
                child: SvgPicture.asset(
                  'assets/Images/earn3.svg',
                  fit: BoxFit.fill,
                ),
              ),
            ),

            SizedBox(height: 20),

            // Refer Now Button
            ElevatedButton(
              onPressed: () {
                String shareMessage =
                    "Join Paisalo group with my referral code *${referralCodeController.text}* to get more benefits. "
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
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for info cards
  Widget _buildInfoCard({required String title, required String value}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
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
                title,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 11),
              Text(
                value,
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
