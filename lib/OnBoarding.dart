import 'package:flutter/material.dart';
import 'kyc.dart';
import 'Branch_List_Page.dart';

class OnBoarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 115),
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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/Images/curvedBackground.png',
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: 500, // Adjust the height as needed
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildCardItem(context, 'KYC', 'assets/Images/righ_arrow.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BranchListPage(intentFrom: 'KYC'),
                            ),
                          );
                        }),
                        Divider(color: Color(0xFFC0B8B8)),
                        _buildCardItem(context, 'E SIGN', 'assets/Images/righ_arrow.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BranchListPage(intentFrom: 'E SIGN'),
                            ),
                          );
                        }),
                        Divider(color: Color(0xFFC0B8B8)),
                        _buildCardItem(context, 'APPLICATION FORM', 'assets/Images/righ_arrow.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BranchListPage(intentFrom: 'APPLICATION FORM'),
                            ),
                          );
                        }),
                        Divider(color: Color(0xFFC0B8B8)),
                        _buildCardItem(context, 'HOUSE VISIT', 'assets/Images/righ_arrow.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BranchListPage(intentFrom: 'House Visit'),
                            ),
                          );
                        }),
                        Divider(color: Color(0xFFC0B8B8)),
                        _buildCardItem(context, 'Visit Report', 'assets/Images/righ_arrow.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BranchListPage(intentFrom: 'Visit Report'),
                            ),
                          );
                        }),
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

  Widget _buildCardItem(BuildContext context, String title, String asset, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 24),
        child: Row(
          children: [
            Expanded(
              flex: 4,
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
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(asset),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
