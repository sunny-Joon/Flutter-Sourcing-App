import 'package:flutter/material.dart';

class BorrowerListItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      color: Colors.red.shade700,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/profileimage.png'),
                ),
                SizedBox(width: 10),
                Text(
                  'John Doe', // Replace with dynamic data
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Father/Spouse:',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'Father/Spouse', // Replace with dynamic data
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'FI Code:',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  '2666', // Replace with dynamic data
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mobile:',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  '888888888', // Replace with dynamic data
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Creator:',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'AGRA', // Replace with dynamic data
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              'Address:',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'abcd efgh ijkl mnop qrst uvwx yz', // Replace with dynamic data
              style: TextStyle(color: Colors.white, fontSize: 16),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
