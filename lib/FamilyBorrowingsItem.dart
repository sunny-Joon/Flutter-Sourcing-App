import 'package:flutter/material.dart';

class FamilyBorrowingsItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.red[800], // dark red background
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/profileimage.png'), // replace with your image asset
                  radius: 24,
                ),
                SizedBox(width: 5),
                Text(
                  'Lender Name', // replace with dynamic data if needed
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'VisbyCFRegular', // make sure this font is added to your pubspec.yaml
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            _buildDetailRow(context, 'Lender Type', 'Father/Spouse'),
            _buildDetailRow(context, 'Reason For Loan', '2666'),
            _buildDetailRow(context, 'Is MFI', 'Is MFI'),
            _buildDetailRow(context, 'Lonee', 'AGRA'),
            _buildDetailRow(context, 'Loan Amount', 'AGRA'),
            _buildDetailRow(context, 'Loan EMI', 'Loan EMI'),
            _buildDetailRow(context, 'Balance Amount', 'Balance'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'VisbyCFRegular',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'VisbyCFRegular',
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Family Borrowings'),
      ),
      body: FamilyBorrowingsItem(),
    ),
  ));
}
