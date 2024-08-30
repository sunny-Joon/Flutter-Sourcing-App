import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/AdhaarData.dart';
import 'package:flutter_sourcing_app/FamMemIncome.dart';
import 'package:flutter_sourcing_app/FinancialInfoPage.dart';
import 'package:flutter_sourcing_app/GuarantorsPage.dart';
import 'package:flutter_sourcing_app/PersonalData.dart';
import 'FamilyBorrowings.dart';

class ApplicationForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00796B), // teal_700 equivalent
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Text(
                'Application Form', // Corresponds to @string/application_form
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'VisbyCFRegular', // Corresponds to @font/visbycfregular
                  color: Colors.white,
                  fontSize: 24, // Corresponds to @dimen/bigheading
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Image.asset(
              'assets/onboard_background.png', // Corresponds to @drawable/onboard_background
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
            SizedBox(height: 46),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(38.0), // Corresponds to app:cardCornerRadius
                ),
                elevation: 15.0, // Corresponds to app:cardElevation
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      buildCardItem(
                        context,
                        'Aadhaar Data',
                            () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdhaarData()),
                        ),
                      ),
                      Divider(color: Color(0xFFF6F6F6)),
                      buildCardItem(
                        context,
                        'Personal Details',
                            () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PersonalData()),
                        ),
                      ),
                      Divider(color: Color(0xFFF6F6F6)),
                      buildCardItem(
                        context,
                        'Financial Info',
                            () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FinancialInfoPage()),
                        ),
                      ),
                      Divider(color: Color(0xFFF6F6F6)),
                      buildCardItem(
                        context,
                        'Family Income',
                            () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FamMemIncome()),
                        ),
                      ),
                      Divider(color: Color(0xFFF6F6F6)),
                      buildCardItem(
                        context,
                        'Family Borrowings',
                            () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FamilyBorrowings()),
                        ),
                      ),
                      Divider(color: Color(0xFFF6F6F6)),
                      buildCardItem(
                        context,
                        'Guarantors',
                            () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GuarantorsPage()),
                        ),
                      ),
                      Divider(color: Color(0xFFF6F6F6)),
                      buildCardItem(
                        context,
                        'KYC Scanning',
                            () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => KYCScanningPage()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCardItem(BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45, // Height of each card item
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'VisbyCFBold', // Corresponds to @font/visbycfbold
                  fontSize: 16, // Corresponds to @dimen/subheading
                  color: Colors.black,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              flex: 1,
              child: Checkbox(
                value: false,
                onChanged: (bool? newValue) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KYCScanningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('KYC Scanning')),
      body: Center(child: Text('KYC Scanning Page')),
    );
  }
}
