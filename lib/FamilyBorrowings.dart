import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/FamMemIncomeItem.dart';

import 'FamilyBorrowingsItem.dart';

class FamilyBorrowings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // RecyclerView equivalent
          ListView.builder(
            itemCount: 1, // Replace with your actual data count
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: FamilyBorrowingsItem(), // Use the custom widget here
              );
            },
          ),
          // Button at the bottom
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: () {
                // Add your button action here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Set your preferred color
              ),
              child: Text('Add Family Member Income'),
            ),
          ),
          // Floating Action Button
          Positioned(
            bottom: 60,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(12),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Lender Name', style: TextStyle(
                                color: Colors.red)),
                            Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Lender Name',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text('Lender Type', style: TextStyle(
                                color: Colors.red)),
                            Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  items: ['Bank', 'MFI', 'Others']
                                      .map((String value) =>
                                      DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      ))
                                      .toList(),
                                  onChanged: (newValue) {},
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text('Loan Used By', style: TextStyle(
                                color: Colors.red)),
                            Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  items: ['Personal', 'Business', 'Others']
                                      .map((String value) =>
                                      DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      ))
                                      .toList(),
                                  onChanged: (newValue) {},
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text('Reason For Loan', style: TextStyle(
                                color: Colors.red)),
                            Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  items: ['Education', 'Medical', 'Housing']
                                      .map((String value) =>
                                      DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      ))
                                      .toList(),
                                  onChanged: (newValue) {},
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text('Loan Amount',
                                          style: TextStyle(color: Colors.red)),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text('EMI Amount',
                                          style: TextStyle(color: Colors.red)),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text('Balance Amount',
                                          style: TextStyle(color: Colors.red)),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text('Is MFI',
                                          style: TextStyle(color: Colors.red)),
                                      Card(
                                        elevation: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            items: ['Yes', 'No']
                                                .map((String value) =>
                                                DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                ))
                                                .toList(),
                                            onChanged: (newValue) {},
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Add/Update borrowings logic
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: Text('Add/Update'),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Delete borrowings logic
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: Text('Delete'),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: Text('Cancel'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
    child: Icon(Icons.add),
    backgroundColor: Colors.red,
    ),
    ),

        ],
      ),
    );
  }
}