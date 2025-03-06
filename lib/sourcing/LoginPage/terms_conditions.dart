import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart';


class TermsConditions extends StatelessWidget {
  // The terms and conditions string

  @override
  Widget build(BuildContext context) {
    String termsText =  AppLocalizations.of(context)!.termandcondition;
    return Scaffold(
        backgroundColor: Color(0xFFD42D3F),
        body: Column(

        children: [
          SizedBox(height: 35,),
        Padding(
          padding: EdgeInsets.all(8),
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
          color: Color(0xFFD42D3F), // Set the background color
          padding: const EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height-150,
          child: SingleChildScrollView(
            child: HtmlWidget(
              termsText,
              textStyle: TextStyle(fontFamily: "Poppins-Regular",
                fontSize: 16,
                color: Colors.white, // Set the text color to white
              ),
            ),
          ),
        ),
      ],)

    );
  }
}
