import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/visit_report_page.dart';
import 'kyc.dart';
import 'Branch_List_Page.dart';

class OnBoarding extends StatefulWidget {

  @override
  _OnboardingState createState() => _OnboardingState();

}
class _OnboardingState extends State<OnBoarding>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10,top: 50,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: Container(
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   border: Border.all(
                      //       width: 1, color: Colors.grey.shade300),
                      //   borderRadius: BorderRadius.all(Radius.circular(5)),
                      // ),
                      height: 40,
                      width: 40,
                      // alignment: Alignment.center,
                      // child: Center(
                      //   child: Icon(Icons.arrow_back_ios_sharp, size: 16),
                      // ),
                    ),
                    // onTap: () {
                    //   setState(() {
                    //     Navigator.pop(context);                  });
                    // },
                  ),
                  Center(
                    child: Text(
                      'ONBOARDING',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: "Poppins-Regular",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24 // Make the text bold
                      ),
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
            SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20,top: 10,bottom: 50),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Image.asset(
                    'assets/Images/curvedBackground.png',
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height/1.8, // Adjust the height as needed
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10,bottom: 20),
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
                              builder: (context) => VisitReportPage(),
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
                style: TextStyle(fontFamily: "Poppins-Regular",
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
