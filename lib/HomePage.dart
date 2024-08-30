import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      appBar: AppBar(
        title: Text('HomePage'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20), // Add some space at the top
            Image.asset(
              'assets/upside.png', // replace with your image asset
              width: 30,
              height: 30,
            ),

            // Disbursement section
            Container(
              padding: EdgeInsets.all(30.0),
              margin: EdgeInsets.symmetric(horizontal: 18.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/Images/paisalo_logo.png'), // replace with your background image
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/paisa_logo.png', // replace with your logo
                    height: 45,
                  ),
                  Image.asset(
                    'assets/vectorrupees.png', // replace with your image asset
                    height: 30,
                  ),
                  Text(
                    'Monthly',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF6D6D6D), // dark grey color
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Disbursement Target',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF6D6D6D),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      '₹ 00,00,000',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF6D6D6D),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20), // Add space between sections

            // Bottom section with cards
            Text(
              'Tap to Calculate Incentive',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 10), // Add space before the row

            Row(
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'People Earn More Incentive',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF6D6D6D),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.red[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text(
                            'Earn More Incentive',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Ab Rukna Nahi',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Add some space at the bottom
          ],
        ),
      ),
    );
  }
}

