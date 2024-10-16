import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ApiService.dart';
import 'GlobalClass.dart';
import 'LeaderBoard.dart';
import 'HomePage.dart';
import 'Models/RangeCategoryModel.dart';
import 'OnBoarding.dart';
import 'Profile.dart';
import 'Collection.dart';
import 'DATABASE/DatabaseHelper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Fragments(),
    );
  }
}

class Fragments extends StatefulWidget {
  @override
  _FragmentsState createState() => _FragmentsState();
}

class _FragmentsState extends State<Fragments> {
  int _selectedIndex = 0;
  dynamic managerList; // Variable to store the response object

  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    LeaderBoard(),
    Collection(),
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
      body: _widgetOptions.elementAt(_selectedIndex), // Display the selected page
      bottomNavigationBar: Container(
        height: 70.0, // Increase height of the BottomNavigationBar
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'LeaderBoard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payment),
              label: 'Collection',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.red,
          backgroundColor: Colors.white, // Ensure the background color is white
          onTap: _onItemTapped,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OnBoarding(), // Pass the response object
            ),
          );
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0), // Make the FAB circular
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> RangeCategory(BuildContext context) async {
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

        // Handle successful data update
        GlobalClass().showSuccessAlert(context);
      } else {
        // Handle failed data update
        GlobalClass().showUnsuccessfulAlert(context);
      }
    } else {
      // If data exists, no need to make the API call
      print('Data already exists in the database.');
    }
  }
}
