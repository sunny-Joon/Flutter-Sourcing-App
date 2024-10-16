import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/AdhaarData.dart';
import 'package:flutter_sourcing_app/FamMemIncome.dart';
import 'package:flutter_sourcing_app/FinancialInfoPage.dart';
import 'package:flutter_sourcing_app/GuarantorsPage.dart';
import 'package:flutter_sourcing_app/PersonalData.dart';
import 'FamilyBorrowings.dart';
import 'Models/BorrowerListModel.dart';

class ApplicationForm extends StatelessWidget {

  final BorrowerListDataModel borrower;

  ApplicationForm({required this.borrower});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F), // Background color
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Application Form', // Header text
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'VisbyCFRegular',
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                Image.asset(
                'assets/Images/curvedBackground.png',
                fit: BoxFit.fill,
                width: double.infinity,
                height: 700, // Adjust the height as needed
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                buildListItem(
                                  context,
                                  'Aadhaar Data',
                                      () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AdhaarData(
                                      borrower: borrower
                                    )),
                                  ),
                                ),
                                buildListItem(
                                  context,
                                  'Personal Details',
                                      () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PersonalData(
                                      borrower: borrower
                                    )),
                                  ),
                                ),
                                buildListItem(
                                  context,
                                  'Financial Info',
                                      () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => FinancialInfoPage(
                                      borrower: borrower
                                    )),
                                  ),
                                ),
                                buildListItem(
                                  context,
                                  'Family Income',
                                      () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => FamMemIncome(
                                      borrower: borrower
                                    )),
                                  ),
                                ),
                                buildListItem(
                                  context,
                                  'Family Borrowings',
                                      () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => FamilyBorrowings(
                                      borrower: borrower,
                                    )),
                                  ),
                                ),
                                buildListItem(
                                  context,
                                  'Guarantors',
                                      () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => GuarantorsPage(
                                      borrower: borrower,
                                    )),
                                  ),
                                ),
                                buildListItem(
                                  context,
                                  'KYC Scanning',
                                      () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => KYCScanningPage()),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListItem(BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8), // Semi-transparent background for readability
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'VisbyCFBold',
                  fontSize: 16,
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
