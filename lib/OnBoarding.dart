import 'package:flutter/material.dart';
// Import the KYC page
import 'kyc.dart';
import 'manager_list_page.dart';

class OnBoarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      appBar: AppBar(
        title: Text('OnBoarding'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Text(
                'Onboarding',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'VisbyCFRegular',
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Image.asset(
                'assets/onboard_background.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(height: 46),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(38.0),
                ),
                elevation: 15.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      _buildCardItem(context, 'KYC', 'assets/Images/right_button.png', () {
                        // Navigate to Manager List page with 'Kyc' string
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManagerListPage(data: 'KYC'),
                          ),
                        );
                      }),
                      Divider(color: Color(0xFFF6F6F6)),
                      _buildCardItem(context, 'E SIGN', 'assets/Images/right_button.png', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManagerListPage(data: 'E SIGN'),
                          ),
                        );
                      }),
                      Divider(color: Color(0xFFF6F6F6)),
                      _buildCardItem(context, 'APPLICATION FORM', 'assets/Images/right_button.png', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManagerListPage(data: 'APPLICATION FORM'),
                          ),
                        );
                      }),
                      Divider(color: Color(0xFFF6F6F6)),
                      _buildCardItem(context, 'HOUSE VISIT', 'assets/Images/right_button.png', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManagerListPage(data: 'HOUSE VISIT'),
                          ),
                        );
                      }),
                      Divider(color: Color(0xFFF6F6F6)),
                      _buildCardItem(context, 'Visit Report', 'assets/Images/right_button.png', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManagerListPage(data: 'Visit Report'),
                          ),
                        );
                      }),
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

  Widget _buildCardItem(BuildContext context, String title, String asset, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'VisbyCFBold',
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Image.asset(asset),
              ),
            ),
          ],
        ),
      ),
    );
  }
}