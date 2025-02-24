 import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/Dealer/dealer_homepage.dart';
import 'package:flutter_sourcing_app/sourcing/Collection/collectionbranchlist.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../DATABASE/database_helper.dart';
import '../../Models/range_category_model.dart';
import '../../api_service.dart';
import '../../const/appcolors.dart';
import '../HomePage/home_page.dart';
import '../ProfilePage/profile.dart';
import '../global_class.dart';
import '../leader_board.dart';
import 'on_boarding.dart';

class Fragments extends StatefulWidget {

  @override
  _FragmentsState createState() => _FragmentsState();
}

class _FragmentsState extends State<Fragments> {
  AppColors appColors = new AppColors();
  bool usertypeFlag = false;

  dynamic managerList; // Variable to store the response object
  int _page = 0;

  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    LeaderBoard(),
    OnBoarding(),
    //Collection(),
    CollectionBranchListPage(),
    Profile(),
  ];

  final List<Widget> _widgetOptions2 = <Widget>[
    HomePage(),
  //  LeaderBoard(),
    //OnBoarding(),
    DealerHomePage(),
    //Collection(),
 //   CollectionBranchListPage(),
    Profile(),
  ];


  @override
  void initState() {
    super.initState();
    GlobalClass.userType == 'Dealer'?usertypeFlag =true:usertypeFlag=false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RangeCategory(context);
      Fluttertoast.showToast(msg: 'You are in ${GlobalClass.creator} creator',toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,);
    });
   }

  @override
  Widget build(BuildContext context) {
    return   PopScope(
        canPop: false,
        onPopInvoked: (bool value) {
          _onWillPop();
        },
        child: Scaffold(
        backgroundColor: Color(0xFFD42D3F), // Set background color
        body: usertypeFlag?_widgetOptions2[_page]:_widgetOptions[_page], // Display the selected page
        bottomNavigationBar: CurvedNavigationBar(
          height: 60,
          items: usertypeFlag?<Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: ImageIcon(
                AssetImage(
                    'assets/Images/home_ic.png'), // Replace 'assets/image.png' with your image path
                size: 20, // Adjust the size as needed
                color: _page == 0 ? appColors.mainAppColor : Colors.grey,
                // Adjust the color as needed
              ),
            ),

            Padding(
              padding: EdgeInsets.all(8),
              child: ImageIcon(
                AssetImage(
                    'assets/Images/service_ic.png'), // Replace 'assets/image.png' with your image path
                size: 20, // Adjust the size as needed
                color: _page == 1 ? appColors.mainAppColor : Colors.grey,
                // Adjust the color as needed
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: ImageIcon(
                AssetImage(
                    'assets/Images/prof_ic.png'), // Replace 'assets/image.png' with your image path
                size: 20, // Adjust the size as needed
                color: _page == 2 ? appColors.mainAppColor : Colors.grey,
                // Adjust the color as needed
              ),
            ),
          ]:
          <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: ImageIcon(
                AssetImage(
                    'assets/Images/home_ic.png'), // Replace 'assets/image.png' with your image path
                size: 20, // Adjust the size as needed
                color: _page == 0 ? appColors.mainAppColor : Colors.grey,
                // Adjust the color as needed
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: ImageIcon(
                AssetImage(
                    'assets/Images/leader_ic.png'), // Replace 'assets/image.png' with your image path
                size: 20, // Adjust the size as needed
                color: _page == 1 ? appColors.mainAppColor : Colors.grey,
                // Adjust the color as needed
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: ImageIcon(
                AssetImage(
                    'assets/Images/service_ic.png'), // Replace 'assets/image.png' with your image path
                size: 20, // Adjust the size as needed
                color: _page == 2 ? appColors.mainAppColor : Colors.grey,
                // Adjust the color as needed
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: ImageIcon(
                AssetImage(
                    'assets/Images/earn_ic.png'), // Replace 'assets/image.png' with your image path
                size: 20, // Adjust the size as needed
                color: _page == 3 ? appColors.mainAppColor : Colors.grey,
                // Adjust the color as needed
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: ImageIcon(
                AssetImage(
                    'assets/Images/prof_ic.png'), // Replace 'assets/image.png' with your image path
                size: 20, // Adjust the size as needed
                color: _page == 4 ? appColors.mainAppColor : Colors.grey,
                // Adjust the color as needed
              ),
            ),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 400),
          onTap: (index) {

              setState(() {
                _page = index;
                // if(_page==0){
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => HomePage(), // Pass the response object
                //     ),
                //   );
                // }
                // if(_page==1){
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => LeaderBoard(), // Pass the response object
                //     ),
                //   );
                // }
                // if(_page==2){
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => OnBoarding(), // Pass the response object
                //     ),
                //   );
                // }
                // if(_page==3){
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => Collection(), // Pass the response object
                //     ),
                //   );
                // }
                // if(_page==4){
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => Profile(), // Pass the response object
                //     ),
                //   );
                // }
              });

          },
          letIndexChange: (index) => true,
        ),

      ));

  }
  Future<void> _onWillPop() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure?',
              style: TextStyle(
                  color: Color(0xFFD42D3F),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Do you want to close app?',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShinyButton(
                  'No',
                      () {
                    EasyLoading.dismiss();
                    Navigator.of(context).pop(true);
                  },
                ),
                _buildShinyButton(
                  'Yes',
                      () {
                    EasyLoading.dismiss();
                    exit(0);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
    // return shouldClose ?? false; // Default to false if dismissed
  }
  Widget _buildShinyButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Color(0xFFD42D3F), // foreground/text
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }

  Future<void> RangeCategory(BuildContext context) async {
    EasyLoading.show(status: 'Loading...',);

    final api2 = Provider.of<ApiService>(context, listen: false);
    final dbHelper = DatabaseHelper();

    bool dataExists = await dbHelper.isRangeCategoryDataExists();

    if(!dataExists) {
      final response = await api2.RangeCategory(
          GlobalClass.token, GlobalClass.dbName);

      if (response.statuscode == 200) {
        RangeCategoryModel rangeCategoryModel = response;

        await dbHelper.clearRangeCategoryTable();

        for (var datum in rangeCategoryModel.data) {
          await dbHelper.insertRangeCategory(datum);
        }
        Fluttertoast.showToast(msg: "App is ready to use",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,);
        // Handle successful data update

        EasyLoading.dismiss();
      } else {
        // Handle failed data update
        EasyLoading.dismiss();

        GlobalClass.showUnsuccessfulAlert(context, "Backend Data Not Saved", 1);
      }
    }else{
      EasyLoading.dismiss();

      Fluttertoast.showToast(msg: "App is ready to use",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,);
    }

  }

}
