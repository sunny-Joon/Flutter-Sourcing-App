import 'package:flutter/material.dart';
import 'BorrowerListItem.dart';
import 'ApplicationForm.dart'; // Import the ApplicationForm page

class BorrowerList extends StatelessWidget {
  final String data;

  BorrowerList({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrower List'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 2, // Number of items
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  // Navigate based on the data value
                  if (data == 'APPLICATION FORM') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ApplicationForm()),
                    );
                  } else if (data == 'HouseVisit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ApplicationForm()),
                    );
                  }
                },
                child: BorrowerListItem(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
