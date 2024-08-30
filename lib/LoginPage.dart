import 'package:flutter/material.dart';

import 'Fragments.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define your custom color
    const Color customColor = Color(0xFFD42D3F);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align all text to the left
          children: [
            SizedBox(height: 30),
            Image.asset(
              'assets/Images/paisa_logo.png', // Adjust the image path
              width: double.infinity,
            ),
            SizedBox(height: 30),
            Center(
              child: Text(
                'Ver: 1.1',
                style: TextStyle(color: customColor),
              ),
            ),

            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 4,
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: DropdownButton<String>(
                  isExpanded: true,
                  items: [
                    DropdownMenuItem<String>(
                      value: "Database1",
                      child: Text("Database1"),
                    ),
                    DropdownMenuItem<String>(
                      value: "Database2",
                      child: Text("Database2"),
                    ),
                  ],
                  onChanged: (String? newValue) {},
                  hint: Text('Select Database'),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Enter User ID',
              style: TextStyle(
                color: customColor,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'GRST000223',
                  ),
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              'User Name must be at least 10 characters',
              style: TextStyle(
                color: customColor,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Enter Password',
              style: TextStyle(
                color: customColor,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '12345',
                        ),
                        obscureText: true,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Icon(Icons.visibility), // Placeholder for Lottie animation
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Password must be at least 5 characters',
              style: TextStyle(
                color: customColor,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Fragments()),
              );},
              style: ElevatedButton.styleFrom(
                primary: customColor, // Set button color
                onPrimary: Colors.white, // Set text color to white
                minimumSize: Size(double.infinity, 65),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Share Device Id',
                    style: TextStyle(
                      color: customColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      color: customColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        child: Icon(Icons.support_agent), // Placeholder for customer support icon
      ),
    );
  }
}
