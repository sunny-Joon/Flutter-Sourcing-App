import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/FamMemIncomeItem.dart';

class FamMemIncome extends StatelessWidget {
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
                child: FamMemIncomeItem(), // Use the custom widget here
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
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(12),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Family Member Name", style: TextStyle(color: Colors.red)),
                            Card(
                              elevation: 2,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Family Member Name",
                                  contentPadding: EdgeInsets.all(8),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text("Relationship", style: TextStyle(color: Colors.red)),
                            Card(
                              elevation: 2,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  border: InputBorder.none,
                                ),
                                items: ["Option 1", "Option 2"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {},
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Aadhar Age", style: TextStyle(color: Colors.red)),
                                      Card(
                                        elevation: 2,
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: "Age",
                                            contentPadding: EdgeInsets.all(8),
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Aadhar Gender", style: TextStyle(color: Colors.red)),
                                      Card(
                                        elevation: 2,
                                        child: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(8),
                                            border: InputBorder.none,
                                          ),
                                          items: ["Male", "Female"].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text("Health", style: TextStyle(color: Colors.red)),
                            Card(
                              elevation: 2,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  border: InputBorder.none,
                                ),
                                items: ["Healthy", "Unhealthy"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {},
                              ),
                            ),
                            SizedBox(height: 8),
                            Text("Education", style: TextStyle(color: Colors.red)),
                            Card(
                              elevation: 2,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  border: InputBorder.none,
                                ),
                                items: ["Primary", "Secondary"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {},
                              ),
                            ),
                            SizedBox(height: 8),
                            Text("School Type", style: TextStyle(color: Colors.red)),
                            Card(
                              elevation: 2,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  border: InputBorder.none,
                                ),
                                items: ["Public", "Private"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {},
                              ),
                            ),
                            SizedBox(height: 8),
                            Text("Business", style: TextStyle(color: Colors.red)),
                            Card(
                              elevation: 2,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Business",
                                  contentPadding: EdgeInsets.all(8),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text("Business Type", style: TextStyle(color: Colors.red)),
                            Card(
                              elevation: 2,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  border: InputBorder.none,
                                ),
                                items: ["Small", "Large"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {},
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Income", style: TextStyle(color: Colors.red)),
                                      Card(
                                        elevation: 2,
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: "123",
                                            contentPadding: EdgeInsets.all(8),
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Income Type", style: TextStyle(color: Colors.red)),
                                      Card(
                                        elevation: 2,
                                        child: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(8),
                                            border: InputBorder.none,
                                          ),
                                          items: ["Salary", "Business"].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            // Add or Update logic
                          },
                          child: Text('Add/Update'),
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Delete logic
                          },
                          child: Text('Delete'),
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: Colors.red, // Set your preferred color
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}