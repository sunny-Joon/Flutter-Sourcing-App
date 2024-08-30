import 'package:flutter/material.dart';

class GuarantorsPage extends StatefulWidget {
  @override
  _GuarantorsPageState createState() => _GuarantorsPageState();
}

class _GuarantorsPageState extends State<GuarantorsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guarantors Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with the actual number of items
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Guarantor $index'),
                    subtitle: Text('Details of Guarantor $index'),
                    onTap: () {
                      // Implement onPressed method here
                      _onGuarantorItemPressed(index);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Implement submit action here
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGuarantorDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _onGuarantorItemPressed(int index) {
    // Add your code for onPressed for TextViews here
    print('Guarantor $index pressed');
  }

  void _showAddGuarantorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Guarantor'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(hintText: 'Guarantor Name'),
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Guarantor Details'),
                ),
                // Add more input fields and spinners here
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Add cancel action here
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add save action here
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
