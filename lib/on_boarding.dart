import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/visit_report_page.dart';
import 'kyc.dart';
import 'branch_list_page.dart';
import 'notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
                  IconButton(
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => NotificationPage()));
                      },
                      icon: Icon(Icons.notification_add,color: Colors.white,)
                  ),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.onboarding,
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
                        _buildCardItem(context, AppLocalizations.of(context)!.kyc, 'assets/Images/righ_arrow.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BranchListPage(intentFrom: 'KYC'),
                            ),
                          );
                        }),
                        Divider(color: Color(0xFFC0B8B8)),
                        _buildCardItem(context,AppLocalizations.of(context)!.esign, 'assets/Images/righ_arrow.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BranchListPage(intentFrom: 'E SIGN'),
                            ),
                          );
                        }),
                        Divider(color: Color(0xFFC0B8B8)),
                        _buildCardItem(context, AppLocalizations.of(context)!.application, 'assets/Images/righ_arrow.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BranchListPage(intentFrom: 'APPLICATION FORM'),
                            ),
                          );
                        }),
                        Divider(color: Color(0xFFC0B8B8)),
                        _buildCardItem(context,AppLocalizations.of(context)!.housevisit, 'assets/Images/righ_arrow.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BranchListPage(intentFrom: 'House Visit'),
                            ),
                          );
                        }),
                        Divider(color: Color(0xFFC0B8B8)),
                        _buildCardItem(context, AppLocalizations.of(context)!.visitreport, 'assets/Images/righ_arrow.png', () {
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
