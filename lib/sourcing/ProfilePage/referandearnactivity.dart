import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../api_service.dart';
import '../HomePage/getrewardactivity.dart';
import '../global_class.dart';
import 'howtoreferactivity.dart';

class referandearnactivity extends StatefulWidget {
  @override

  _referandearnactivitystate createState() => _referandearnactivitystate();
}

class _referandearnactivitystate extends State<referandearnactivity> {
  final TextEditingController referralCodeController = TextEditingController();
  late String fetchedReferralCode;
  @override
  void initState() {
    super.initState();
    fetchReferralCode(context);
  }

  Future<void> fetchReferralCode(BuildContext context) async {
    EasyLoading.show(status: 'Loading...');
    final api = Provider.of<ApiService>(context, listen: false);
    try {
      final value = await api.getReferalCode(GlobalClass.token, GlobalClass.dbName, GlobalClass.EmpId);
      if (value.statuscode == 200) {
        EasyLoading.dismiss();
        setState(() {
          fetchedReferralCode = value.data;
          referralCodeController.text = fetchedReferralCode;
        });
      } else {
        EasyLoading.dismiss();
        GlobalClass.showErrorAlert(context, value.message, 1);
     //    setState(() {
     //      fetchedReferralCode = value.data;
     //      referralCodeController.text = fetchedReferralCode;
     //    });
      }
    } catch (e) {
      print('Error: $e');
      EasyLoading.dismiss();
      GlobalClass.showErrorAlert(context, "Server Side Error", 2);
    }
  }


/*  void fetchReferralCode() async {
    await Future.delayed(Duration(seconds: 2));

    String fetchedReferralCode = "ZAXM2345D";
    setState(() {
      referralCodeController.text = fetchedReferralCode;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD42D3F),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
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

            Container(
              height: MediaQuery.of(context).size.height -120,
              child:
            SingleChildScrollView(
              child: Column(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => howtoreferactivity(
                          referralCode: referralCodeController.text,
                        ),
                      ),
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
                          AppLocalizations.of(context)!.referal,
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
                              : AppLocalizations.of(context)!.loading,
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
                              title: AppLocalizations.of(context)!.totalreferral,
                              value: '0',
                            ),
                            _buildInfoCard(
                              title: AppLocalizations.of(context)!.totalcashback,
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
                      MaterialPageRoute(
                        builder: (context) => getrewardactivity(
                          referralCode:
                          referralCodeController.text,
                        ),
                      ),
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
                  child: Text(AppLocalizations.of(context)!.refernow),
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
                ),
                SizedBox(height: 20),

              ],),
            ),)


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
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
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
