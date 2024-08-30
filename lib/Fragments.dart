import 'package:flutter/material.dart';
import 'LeaderBoard.dart';
import 'HomePage.dart';
import 'OnBoarding.dart';
import 'Profile.dart';
import 'Collection.dart';

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
            MaterialPageRoute(builder: (context) => OnBoarding()),
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
}
