import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'ApiService.dart';
import 'Branch_List_Page.dart';
import 'GlobalClass.dart';
import 'LeaderBoard.dart';
import 'HomePage.dart';
import 'Models/RangeCategoryModel.dart';
import 'OnBoarding.dart';
import 'Profile.dart';
import 'Collection.dart';
import 'DATABASE/DatabaseHelper.dart';
import 'const/appcolors.dart';


class Fragments extends StatefulWidget {



  @override
  _FragmentsState createState() => _FragmentsState();
}

class _FragmentsState extends State<Fragments> {
  AppColors appColors = new AppColors();

  int _selectedIndex = 0;
  dynamic managerList; // Variable to store the response object
  int _page = 0;
  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    LeaderBoard(),
    OnBoarding(),
    //Collection(),
    BranchListPage(intentFrom: 'COLLECTION'),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RangeCategory(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F), // Set background color
      body: _widgetOptions[_page], // Display the selected page
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        items: <Widget>[
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
          });
        },
        letIndexChange: (index) => true,
      ),

    );
  }

  Future<void> RangeCategory(BuildContext context) async {
    EasyLoading.show(status: 'Loading...',);

    final api2 = Provider.of<ApiService>(context, listen: false);
    final dbHelper = DatabaseHelper();

    // Check if data already exists in the database
    bool dataExists = await dbHelper.isRangeCategoryDataExists();

    if (!dataExists) {
      // If data does not exist, make the API call
      final response = await api2.RangeCategory(GlobalClass.token, GlobalClass.dbName);

      if (response.statuscode == 200) {

        RangeCategoryModel rangeCategoryModel = response;

        await dbHelper.clearRangeCategoryTable();

        // Insert new data into SQLite
        for (var datum in rangeCategoryModel.data) {
          await dbHelper.insertRangeCategory(datum);
        }
        Fluttertoast.showToast(msg: "App is ready to use",toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,);
        // Handle successful data update

        EasyLoading.dismiss();

      } else {
        // Handle failed data update
       EasyLoading.dismiss();

        GlobalClass.showUnsuccessfulAlert(context,"Backend Data Not Saved",1);
      }
    } else {
      EasyLoading.dismiss();
      // If data exists, no need to make the API call
      print('Data already exists in the database.');
    }
  }
}
