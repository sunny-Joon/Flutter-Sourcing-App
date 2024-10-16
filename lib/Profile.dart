import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F), // teal_200 color
      appBar: AppBar(
        title: Text('Page 1'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'PUNCH IN',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: Size(120, 40),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'PUNCH OUT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: Size(120, 40),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Image.asset(
              'assets/profileimage.png', // Replace with your asset image
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Container(
              height: 45,
              child: Center(
                child: Text(
                  'User Name',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Container(
                      height: 45,
                      child: Center(
                        child: Text(
                          'Creator',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 45,
                        alignment: Alignment.centerRight,
                        child: Text(
                          '9999999999',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Container(
                      height: 45,
                      child: Center(
                        child: Text(
                          'ID',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 45,
                        alignment: Alignment.centerRight,
                        child: Text(
                          'CSO',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Card(
                          // child: Lottie.asset(
                          //   'assets/locationtip.json', // Replace with your Lottie asset
                          //   height: 45,
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 45,
                          alignment: Alignment.center,
                          child: Text(
                            'Address Details',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      constraints: BoxConstraints(minHeight: 45),
                      child: Text(
                        'Address Details',
                        maxLines: null,
                        style: TextStyle(
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Container(
                      height: 45,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Get QR Payment Details',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Container(
                      height: 45,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Get Collection Report',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Image.asset(
                    'assets/earn6.png', // Replace with your asset image
                    fit: BoxFit.cover,
                  ),
                  Image.asset(
                    'assets/earn5.png', // Replace with your asset image
                    fit: BoxFit.cover,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Refer Now',
                      style: TextStyle(fontSize: 9),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      fixedSize: Size(75, 45),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
