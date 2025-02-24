import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class howtoreferactivity extends StatelessWidget {
  final String referralCode;

  howtoreferactivity({required this.referralCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD42D3F),
      body: Container(

        padding: EdgeInsets.all(0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 36,),

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

           Padding(padding: EdgeInsets.all(16),child: Column(
             children: [
               Text(
                 AppLocalizations.of(context)!.howtorefer,
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
                 AppLocalizations.of(context)!.earn1,
               ),
               StepWidget(
                 stepNumber: "2",
                 stepDescription:
                 AppLocalizations.of(context)!.earn2,
               ),
               StepWidget(
                 stepNumber: "3",
                 stepDescription:
                 AppLocalizations.of(context)!.earn3,
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
                     foregroundColor: Colors.white, backgroundColor: Color(
                       0xFFC01024), // Text color
                     elevation: 5, // Elevation
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(12), // Rounded corners
                     ),
                     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Padding
                     textStyle: TextStyle(fontSize: 20), // Text style
                   ),
                   child: Text(AppLocalizations.of(context)!.refernow),
                 ),
               ),
             ],),),


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
            ),
          ),
        ],
      ),
    );
  }
}

